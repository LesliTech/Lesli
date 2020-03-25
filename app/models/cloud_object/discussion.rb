module CloudObject
=begin

Lesli

Copyright (c) 2020, Lesli Technologies, S. A.

All the information provided by this website is protected by laws of Guatemala related 
to industrial property, intellectual property, copyright and relative international laws. 
Lesli Technologies, S. A. is the exclusive owner of all intellectual or industrial property
rights of the code, texts, trade mark, design, pictures and any other information.
Without the written permission of Lesli Technologies, S. A., any replication, modification,
transmission, publication is strictly forbidden.
For more information read the license file including with this software.

LesliCloud - Your Smart Business Assistant

Powered by https://www.lesli.tech
Building a better future, one line of code at a time.

@author   Carlos Hermosilla
@license  Propietary - all rights reserved.
@version  0.1.0-alpha
@description Base abstract model for *discussion* core entity

=end
    class Discussion < ApplicationRecord
        self.abstract_class = true

=begin
@param account [Account] Account from current user
@param cloud_id [Integer] Id of the *cloud_object* to which this discussion belongs to
@return [Array] Array of discussions. Each discussion contains a *responses* element,
    which is an array that has all its responses ordered by date
@description Retrieves and returns all discussions from a *cloud_object*,
    including information of the user that published the comment
@example
    account = current_user.account
    employee_id = params[:employee_id]
    discussions = CloudTeam::Employee::Discussion.detailed_info( account, employee_id )
=end
        def self.detailed_info(account, cloud_id)

            # Select all discussions from the table
            module_info = self.name.split("::")
            module_name = module_info[0].sub("Cloud","").downcase
            object_name = module_info[1].downcase
            
            discussions = self.joins(
                "
                    inner join cloud_#{module_name}_#{object_name.pluralize} CO on 
                        cloud_#{module_name}_#{object_name}_discussions.cloud_#{module_name}_#{object_name.pluralize}_id = CO.id
                "
            ).joins(
                "inner join users U on cloud_#{module_name}_#{object_name}_discussions.users_id = U.id"
            ).select(
                "cloud_#{module_name}_#{object_name}_discussions.id",
                "cloud_#{module_name}_#{object_name}_discussions.content",
                "cloud_#{module_name}_#{object_name}_discussions.created_at",
                "cloud_#{module_name}_#{object_name}_discussions.cloud_#{module_name}_#{object_name}_discussions_id",
                "U.email"
            )
            .where("CO.id = #{cloud_id}")
            .where("CO.cloud_#{module_name}_accounts_id = #{account.id}")
            .order(id: :asc)
            .map { |discussion| 
                discussion_attributes = discussion.attributes
                discussion_attributes["created_at"] = Courier::Core::Date.to_string_full(discussion_attributes["created_at"])
                discussion_attributes
            }

            data = {}
            root_discussions = []

            # Add all responses to that discussion
            discussions.each do |discussion|
                discussion_data = {
                    data: discussion,
                    responses: []
                }
                data[discussion["id"]] = discussion_data

                if discussion["cloud_#{module_name}_#{object_name}_discussions_id"].present?
                    parent_discussion = data[discussion["cloud_#{module_name}_#{object_name}_discussions_id"]]
                    if parent_discussion[:data]["cloud_#{module_name}_#{object_name}_discussions_id"].present?
                        discussion["response_to"] = parent_discussion[:data]["email"]
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

=begin
@return [Hash] Information about the discussion
@description Retrieves and returns a specific discussion, along with information about the user
    that created it
@example
    discussion = CloudHelp::Ticket::Discussion.first
    puts discussion.show #This will display extra information about the discussion, like the user's name
=end
        def show
            attributes.merge({
                email: user.email,
                user_name: user.name
            })
        end

        private

=begin
@param data [Hash] Hash that contains all the discussions, the key is the id of the discussion
@param discussion [Hash] Hash that contains the information
@param responses [Array] Array of discussions, that are the responses to the *discussion* param.
    It should start as an empty array
@return [void]
@description Recursive function that checks all discussions that are actually responses of other 
    discussions and adds them to their *responses* param. It adds direct responses, responses of responses, etc.
    This is a void function that modifies the *discussion* param directly
@example
    data = {}
    CloudHelp::Ticket::Discussion.all.each do |discussion|
        data[discussion.id] = discussion
    end
    CloudHelp::Ticket::Discussion.nest_responses(data, CloudHelp::Ticket::Discussion.first, [])
=end
        def self.nest_responses(data, discussion,  responses)
            discussion[:responses].each do |response_id|
                response = data[response_id]
                responses.push(response[:data])
                self.nest_responses(data, response, responses)
            end
        end
    end
end
