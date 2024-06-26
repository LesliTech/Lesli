=begin

Lesli

Copyright (c) 2023, Lesli Technologies, S. A.

This program is free software: you can redistribute it and/or modify
it under the terms of the GNU General Public License as published by
the Free Software Foundation, either version 3 of the License, or
(at your option) any later version.

This program is distributed in the hope that it will be useful,
but WITHOUT ANY WARRANTY; without even the implied warranty of
MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the
GNU General Public License for more details.

You should have received a copy of the GNU General Public License
along with this program. If not, see http://www.gnu.org/licenses/.

Lesli · Ruby on Rails SaaS Development Framework.

Made with ♥ by LesliTech
Building a better future, one line of code at a time.

@contact  hello@lesli.tech
@website  https://www.lesli.tech
@license  GPLv3 http://www.gnu.org/licenses/gpl-3.0.en.html

// · ~·~     ~·~     ~·~     ~·~     ~·~     ~·~     ~·~     ~·~     ~·~
// · 
=end
module Lesli
    class CloudObject::Discussion < ApplicationLesliRecord
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
        # @param query [Query] that contains the search and pagination information
        # @return [Array] Array of discussions. Each discussion contains a *responses* element,
        #     which is an array that has all its responses ordered by date
        # @description Retrieves and returns all discussions from a *cloud_object*,
        #     including information of the user that published the comment
        # @example
        #     current_user = the user making this request
        #     employee_id = params[:employee_id]
        #     discussions = CloudTeam::Employee::Discussion.index( account, employee_id, @query )
        def self.index(current_user, cloud_id, query)
            cloud_object_model = self.cloud_object_model
            account_model = cloud_object_model.reflect_on_association(:account).klass
            
            # get search string from query params
            #search_string = query[:search].downcase.gsub(" ","%") unless query[:search].blank?
            
            discussions = self.joins(:cloud_object)
            .joins("inner join lesli_users u on #{self.table_name}.user_id = u.id")
            .where("#{cloud_object_model.table_name}.id = #{cloud_id}")
            .where("#{cloud_object_model.table_name}.account_id = #{current_user.account.id}")
            .select(
                "#{self.table_name}.id",
                "#{self.table_name}.user_id",
                "#{self.table_name}.content",
                Date2.new.date_time.db_timestamps("#{self.table_name}"),
                "u.email",
                "CONCAT_WS(' ', u.first_name, u.last_name) as user_name"
            )

            # Filter results by search string
            # unless search_string.blank?
            #     discussions = discussions.where("
            #     (LOWER(ud.first_name) SIMILAR TO '%#{search_string}%') OR 
            #     (LOWER(ud.last_name) SIMILAR TO '%#{search_string}%') OR 
            #     (LOWER(#{self.table_name}.content) SIMILAR TO '%#{search_string}%')
            #     ")
            # end

            discussions = self.format_discussions(discussions)

            Kaminari.paginate_array(discussions).page(query[:pagination][:page]).per(query[:pagination][:perPage])
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
                    next unless parent_discussion

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
