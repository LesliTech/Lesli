module CloudObject
=begin

Copyright (c) 2020, all rights reserved.

All the information provided by this platform is protected by international laws related  to 
industrial property, intellectual property, copyright and relative international laws. 
All intellectual or industrial property rights of the code, texts, trade mark, design, 
pictures and any other information belongs to the owner of this platform.

Without the written permission of the owner, any replication, modification,
transmission, publication is strictly forbidden.

For more information read the license file including with this software.

// · ~·~     ~·~     ~·~     ~·~     ~·~     ~·~     ~·~     ~·~     ~·~     ~·~     ~·~     ~·~
// · 

=end
    class Discussion < ApplicationLesliRecord
        self.abstract_class = true
        belongs_to :user_creator, class_name: "::User", foreign_key: "users_id"

        # @return [User] This method will always return nil
        # @description At the current time, this is a dummy method that returns nil, so the function is_editable_by? in
        #   ApplicationLesliRecord will work without issues
        def user_main
            return nil
        end

        # @param account [Account] Account from current user
        # @param cloud_id [Integer] Id of the *cloud_object* to which this discussion belongs to
        # @return [Array] Array of discussions. Each discussion contains a *responses* element,
        #     which is an array that has all its responses ordered by date
        # @description Retrieves and returns all discussions from a *cloud_object*,
        #     including information of the user that published the comment
        # @example
        #     current_user = the user making this request
        #     employee_id = params[:employee_id]
        #     discussions = CloudTeam::Employee::Discussion.index( account, employee_id )
        def self.index(current_user, cloud_id)
            cloud_object_model = self.cloud_object_model
            account_model = cloud_object_model.reflect_on_association(:account).klass
            
            discussions = self.joins(:cloud_object).joins(
                "inner join users u on #{self.table_name}.users_id = u.id"
            ).joins(
                "inner join user_details ud on ud.users_id = u.id"
            ).select(
                "#{self.table_name}.id",
                "#{self.table_name}.users_id",
                "#{self.table_name}.content",
                "#{self.table_name}.created_at",
                "#{self.table_name}.#{self.table_name}_id",
                "u.email",
                "CONCAT(ud.first_name, ' ', ud.last_name) as user_name"
            )
            .where("#{cloud_object_model.table_name}.id = #{cloud_id}")
            .where("#{cloud_object_model.table_name}.#{account_model.table_name}_id = #{current_user.account.id}")
            .order(id: :asc)
            .map { |discussion| 
                discussion_attributes = discussion.attributes
                discussion_attributes["created_at_raw"] = discussion_attributes["created_at"]
                discussion_attributes["editable"] = discussion.is_editable_by?(current_user)
                discussion_attributes["created_at"] = LC::Date.to_string_datetime(discussion_attributes["created_at"])
                discussion_attributes
            }

            self.format_discussions(discussions)
        end

        # @return [Hash] Information about the discussion
        # @description Retrieves and returns a specific discussion, along with information about the user
        #     that created it
        # @example
        #     discussion = CloudHelp::Ticket::Discussion.first
        #     puts discussion.show #This will display extra information about the discussion, like the user's name
        def show(current_user = nil)
            discussion_attributes = attributes.merge({
                editable: is_editable_by?(current_user),
                email: user_creator.email,
                user_name: user_creator.full_name
            })
            discussion_attributes["created_at"] = LC::Date.to_string_datetime(discussion_attributes["created_at"])

            discussion_attributes
        end

        # @return [Class] The class of the association 'belongs_to'
        # @description All discussions belong to a *cloud_object*. This method returns the specific class of
        #     that cloud_object.
        # @example
        #     puts DeutscheLeibrenten::Project::Discussion.cloud_object_model.new # This will display an instance of DeutscheLeibrenten::Project
        def self.cloud_object_model
            self.reflect_on_association(:cloud_object).klass
        end

        private

        # @param discussions [Arrray] An array of discussions that were previously filtered
        # @return [Array] A new array of discussions, nesting the responses within the parent discussions
        # @description Geretes a new array of discussions, nesting the responses inside the parent discussions and order them by date
        #     This method uses the *nest_responses* method to support the nesting action recursively
        # @example
        #     # Imagine that discussions has 2 discussions, the first one is a normal discussion, and the second one is a response to the first one
        #     puts discussions # will display something like
        #     # [
        #     #     {
        #     #         id: 1,
        #     #         users_id: 2,
        #     #         created_at: Date(),
        #     #         content: 'This is a root discussion',
        #     #         user_name: 'System',
        #     #         discussions_id: null
        #     #     }, {
        #     #         id: 2,
        #     #         users_id: 2,
        #     #         created_at: Date(),
        #     #         content: 'This is a response',
        #     #         user_name: 'Test',
        #     #         discussions_id: 1
        #     #     }
        #     # ]
        #     puts Discussion.format_discussions(discussions) # Will display something like 
        #     # [
        #     #     {
        #     #         id: 1,
        #     #         users_id: 2,
        #     #         created_at: Date(),
        #     #         content: 'This is a root discussion',
        #     #         user_name: 'System',
        #     #         discussions_id: null,
        #     #         responses: [{
        #     #             id: 2,
        #     #             users_id: 2,
        #     #             created_at: Date(),
        #     #             content: 'This is a response',
        #     #             response_to: 'System'
        #     #             user_name: 'Test',
        #     #             discussions_id: 1
        #     #         }]
        #     #     }
        #     # ]
        def self.format_discussions(discussions)
            data = {}
            root_discussions = []

            # Add all responses to that discussion
            discussions.each do |discussion|
                discussion_data = {
                    data: discussion,
                    responses: []
                }
                data[discussion["id"]] = discussion_data

                if discussion["#{self.table_name}_id"].present?
                    parent_discussion = data[discussion["#{self.table_name}_id"]]
                    if parent_discussion[:data]["#{self.table_name}_id"].present?
                        discussion["response_to"] = parent_discussion[:data]["user_name"]
                    end
                    parent_discussion[:responses].push(discussion["id"])
                else
                    root_discussions.push(discussion_data)
                end
            end

            # Nest the responses to root discussions. A root discussion is any comment that is not a response to another comment
            root_discussions.each do |discussion|
                responses = []
                self.nest_responses(data, discussion, responses)
                discussion[:responses] = responses
            end

            # revert the root discussions so the most recent comments appear in the top
            root_discussions.reverse
        end

        # @param data [Hash] Hash that contains all the discussions, the key is the id of the discussion
        # @param discussion [Hash] Hash that contains the information
        # @param responses [Array] Array of discussions, that are the responses to the *discussion* param.
        #     It should start as an empty array
        # @return [void]
        # @description Recursive function that checks all discussions that are actually responses of other 
        #     discussions and adds them to their *responses* param. It adds direct responses, responses of responses, etc.
        #     This is a void function that modifies the *discussion* param directly
        # @example
        #     data = {}
        #     CloudHelp::Ticket::Discussion.all.each do |discussion|
        #         data[discussion.id] = discussion
        #     end
        #     CloudHelp::Ticket::Discussion.nest_responses(data, CloudHelp::Ticket::Discussion.first, [])
        def self.nest_responses(data, discussion,  responses)
            discussion[:responses].each do |response_id|
                response = data[response_id]
                responses.push(response[:data])
                self.nest_responses(data, response, responses)
            end
        end
    end
end
