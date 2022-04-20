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
class CloudObject < ApplicationLesliRecord
    include ActiveModel::Dirty 

    self.abstract_class = true

    after_update :notify_subscribers
    
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

    def check_workflow_transitions(current_user, new_attributes)
        status_model = self.class.reflect_on_association(:status).klass
        status_key = "#{status_model.table_name}_id".to_sym

        if new_attributes[status_key]

            checks = status.workflow.checks
            .where(initial_status: status)
            .where("final_status_id is ? or final_status_id = ?", nil, new_attributes[status_key])
            .select(:user_type, :users_id, :roles_id)

            checks_passed = true

            checks.each do |check|

                # We check if the user has the correct role
                next if check.role && current_user.has_roles?(check.role.name)

                # We check if the user is the creator
                next if check.creator? && user_creator == current_user

                # We check if the user is the main user
                next if check.main? && user_main == current_user

                # We check if the user is the specific user
                next if check.custom? && check.user && current_user == check.user

                checks_passed = false
                break
            end

            errors.add(:base, I18n.t("core.workflows.messages_warning_status_change_prevented_by_check"))

            return checks_passed
        end

        return true
        
    end

    # @return [String]
    # @description Returns a string that represents and identifies this cloud_object from all other cloud_objects in the same account
    # @example
    #     project = CloudHouse::Project.find(1)
    #     puts projet.global_identifier # If the CloudHouse::Project class does not have the method overrided, this will print 'CloudHouse::Project - 1'
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

    # @return [String]
    # @param include_engine [Boolean] Optional. Defaults to false. Specifies if the urn should include the engine of the resource
    # @description Returns the relative route the user needs to follow to get to this resource. In most cases, it's: /cloud_object_class/url_identifier.
    #     If not, the child model must override this method. Note that the URL does not contain the engine name.
    # @example
    #     puts CloudHelp::Ticket.first.urn # This will display something like /tickets/1
    #     puts CloudHouse::MaintenanceServices.first.urn # This will display something like /property_managements/1?tab=maintenance_services&maintenance_service_id=1
    def urn(include_engine: false)
        class_name_data = self.class.name.split("::")
        urn = "/#{class_name_data[-1].underscore.pluralize}/#{url_identifier}"
        urn = "/#{class_name_data[0].gsub("Cloud", "").underscore}#{urn}" if include_engine

        return urn
    end
    
    # @return [void]
    # @param original_cloud_object [CloudObject] The original cloud object to be copied
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

    # @return [String] A string representing the url to access this object with ID's  included
    # @param base_url [String] The base url with variables to be replaced
    # @description Replaces variables values un the **base_url** param receied and returns a new String
    # @example
    #     service = CloudHouse::ManteinanceService.last
    #     base_url = "/house/maintenance_services/:id:.json?property_management_id=:cloud_house_property_managements_id:"
    #     service.generate_url_link(base_url)
    #     # This will display something like
    #     /house/maintenance_services/193.json?property_management_id=5623
    def generate_link_url(base_url)
        return base_url
    end

    # @return [User] The user branch_office associated to this cloud_object
    # @description Returns a user that is the branch_office of this cloud_object. This method must be implemented in any CloudObject
    # @example
    #     puts CloudHelp::Ticket.first.user_branch_office # will return null, but will work
    #     puts CloudHouse::Project.first.user_branch_office # will return the user branch_office specified in the offer report
    def user_branch_office
    end

    # @return [Hash] Data containing information about the target for an automated task created by a workflow action
    # @description Returns information of ClouObject that is the target for the automated task. By default, 
    #     the target is the CloudObject itself. However, in some cases, like CloudHouse::MaintenanceServices, the target 
    #     is a record associated to the CloudObject. If you have a custom target, you must override this method in your
    #     implementation of the cloud_object
    # @example
    #   puts CloudHouse::Project.first.task_target.to_json # Will display something like {class: CloudHouse::Project, id: 1}
    #   puts CloudHouse::MaintenanceService.first.task_target # Will display something like {class: CloudHouse::Project, id: 1}
    def focus_task_target
        return {
            class: self.class.name,
            id: self.id
        }
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

    protected

    # @return [void]
    # @descriptions Verifies if the status of the cloud_object changed. If it did, a notification is sent to all users that are
    #     subscribed to it. The method uses dynamic naming, so it works on every cloud_object
    # @example
    #     # Imagine current_user is subscribed to a cloud_help/ticket
    #     ticket = CloudHelp::Ticket.first
    #     ticket.update!(cloud_help_workflow_statuses_id: 4) #The callback will be triggered after these changes are saved 
    def notify_subscribers
        status_class = self.class.reflect_on_association(:status)
        if status_class
            status_class = status_class.klass
            
            if saved_changes["#{status_class.table_name}_id"]
                subscribers_association = self.class.reflect_on_association(:subscribers)

                translations_path = self.class.name.gsub("Cloud", "").underscore.pluralize.gsub("/", ".")
                translations_class = I18n.t("#{translations_path}.view_title_main")

                subscribers_association.klass.notify_subscribers(
                    nil,
                    self,
                    "object_status_updated",
                    subject: "#{translations_class} (#{self.global_identifier}): #{I18n.t("core.shared.view_title_cloud_object_status_changed")} '#{status.name}'",
                    body: "#{I18n.t("core.shared.view_text_cloud_object_status_changed_sentence_1")} '#{status.name}'. #{I18n.t("core.shared.view_text_cloud_object_status_changed_sentence_2")}",
                    url: self.urn,
                ) if subscribers_association

            end
        end


        
    end

end
