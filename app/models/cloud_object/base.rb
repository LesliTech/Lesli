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
module CloudObject
    class Base < ApplicationLesliRecord
        self.abstract_class = true
        
        # @return [void]
        # @param bypass_new_record [Boolean] Wheter it workflow should be set in *cloud_objects* that are not finished yet or not
        # @description If the record is new, associates a new workflow with it using the workflow's method
        #     *set_workflow*
        # @example
        #     ticket = CloudHelp::Ticket.new(
        #         detail_attributes: {
        #             subject: 'Test',
        #             cloud_help_ticket_types_id: 1,
        #             cloud_help_ticket_categories_id: 1,
        #             cloud_help_ticket_priorities_id: 1
        #         }
        #     )
        #     ticket.set_workflow
        #     ticket.save!
        def set_workflow(bypass_new_record=false)
            if new_record? || bypass_new_record
                workflow_model = self.class.reflect_on_association(:status).klass.reflect_on_association(:workflow).klass                
                workflow_model.set_workflow(self)
            end
        end

        # @return [String]
        # @description Returns a string that represents and identifies this cloud_object from all other cloud_objects in the same account
        # @example
        #     project = CloudHouse::Project.find(1)
        #     puts projet.global_indentifier # If the CloudHouse::Project class does not have the method overrided, this will print 'CloudHouse::Project - 1'
        def global_identifier
            return "#{self.class.name} - #{id}"
        end

        # @return [String]
        # @description Returns the field used for generation a URL to this resource. In most cases, it's the id. If not, the child model must override this method
        # @example
        #     puts CloudHouse::Project.first.url_identifier # This will display the project code
        #     puts CloudHelp::Ticket.first.url_identifier # This will display the ticket id
        def url_identifier
            return id
        end

        # @return [void]
        # @param original_cloud_object [CloudObject::Base] The original cloud object to be copied
        # @description Clones the information of the original cloud_object into the new one
        # @example
        #       project = CloudHouse::Project.find(1)
        #       new_project = CloudHouse::Project.create!()
        #       new_project.clone_associations(project)
        def clone_associations(original_cloud_object)
        end

        # @return [String]
        # @description Returns a string that represents and identifies the chatroom related to this cloud object on the external service
        # @example
        #     chat = ClouTalk::Chatroom.first
        #     puts chat.chatroom_external_id # If the class have the method overrided, this will print 'ZC57SgOT8KVKJXg7GKyh'
        def chatroom_external_id
        end

        # @return [User] The user reviewer associated to this cloud_object
        # @description Returns a user that is the reviewer of this cloud_object. This method must be implemented in any CloudObject
        # @example
        #     puts CloudHelp::Ticket.first.user_reviewer # will return null, but will work
        #     puts CloudHouse::Project.first.user_reviewer # will return the user reviewer specified in the offer report
        def user_reviewer
        end

        #######################################################################################
        ##############################  Activities Log Methods   ##############################
        #######################################################################################

        # @return [void]
        # @param current_user [::User] The user that created the cloud_object
        # @param cloud_object [CloudModule::Model] The cloud_object that was created
        # @description Creates an activity for this cloud_object indicating who created it.
        # Example
        #   params = {...}
        #   ticket = CloudHelp::Ticket.create(params)
        #   CloudHelp::TicketLogger.log_create(User.first, ticket)
        def self.log_activity_create(current_user, cloud_object)
            LC::Debug.deprecation("please use CloudObject::Logger or your own implementation of Engine::ModelLogger instead")
            Logger.log_create(current_user, cloud_object)
        end

        # @return [void]
        # @param current_user [::User] The user that edited the cloud_object
        # @param cloud_object [CloudModule::Model] The cloud_object that was edited
        # @param old_attributes[Hash] The data of the record before update
        # @param new_attributes[Hash] The data of the record after update
        # @description Creates an activity for this cloud_object if someone changed any of this values
        # Example
        #   ticket = CloudHelp::Ticket.find(1)
        #   old_attributes  = ticket.attributes
        #   ticket.update(user_main: User.find(33))
        #   new_attributes = ticket.attributes
        #   CloudHelp::TicketLogger.log_update(User.find(1), ticket, old_attributes, new_attributes)
        def self.log_activity_update(current_user, cloud_object, old_attributes, new_attributes)
            LC::Debug.deprecation("please use CloudObject::Logger or your own implementation of Engine::ModelLogger instead")
            Logger.log_update(current_user, cloud_object, old_attributes, new_attributes)
        end

        # @return [void]
        # @param current_user [::User] The user that deleted the cloud_object
        # @param cloud_object [CloudModule::Model] The cloud_object that was destroyed
        # @description Creates an activity for this cloud_object indicating that someone deleted it
        # Example
        #   ticket = CloudHelp::Ticket.find(1)
        #   CloudHelp::TicketLogger.log_destroy(User.first, ticket)
        #   ticket.destroy
        def self.log_activity_destroy(current_user, cloud_object)
            LC::Debug.deprecation("please use CloudObject::Logger or your own implementation of Engine::ModelLogger instead")
            Logger.log_destroy(current_user, cloud_object)
        end

    end
end
