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

class CloudObject::Activity < ApplicationLesliRecord
    self.abstract_class = true
    belongs_to :user_creator, class_name: "::User", foreign_key: "users_id", optional: true

    # This enum can be overrided by the model that inherits from CloudObject::Activity
    enum category: {
        action_list:                    "action_list",
        action_create:                  "action_create",
        action_show:                    "action_show",
        action_update:                  "action_update",
        action_destroy:                 "action_destroy",
        action_status:                  "action_status",
        action_workflow_action_failed:  "action_workflow_action_failed",
        action_email_sent:              "action_email_sent",
        action_create_file:             "action_create_file",
        action_update_file:             "action_update_file",
        action_destroy_file:            "action_destroy_file"
    }

    # @return [User] This method will always return nil
    # @description At the current time, this is a dummy method that returns nil, so the function is_editable_by? in
    #   ApplicationLesliRecord will work without issues
    def user_main
        return nil
    end

    # @return [Class] The class of the association 'belongs_to'
    # @description All activities belong to a *cloud_object*. This method returns the specific class of
    #     that cloud_object.
    # @example
    #     puts DeutscheLeibrenten::Project::Activity.cloud_object_model.new # This will display an instance of DeutscheLeibrenten::Project
    def self.cloud_object_model
        self.reflect_on_association(:cloud_object).klass
    end


    #######################################################################################
    ##############################  Activities Log Methods   ##############################
    #######################################################################################


    # @param current_user [User] The current logged user
    # @param cloud_id [Integer] Id of the *cloud_object* to which this activities belongs to
    # @param query [Query] that contains the search and pagination information
    # @return [Array] Array of activities. Each activities contains a *responses* element,
    #     which is an array that has all its responses ordered by date
    # @description Retrieves and returns all activities from a *cloud_object*
    # @example
    #    @activities = activity_model.index(
    #        current_user,
    #        profile_id,
    #        @query
    #    )
    def self.index(current_user, cloud_id, query)
        cloud_object_model = self.cloud_object_model
        account_model = cloud_object_model.reflect_on_association(:account).klass
        translations_module = self.name.split("::")[0].gsub("Cloud", "").underscore

        # get search string from query params
        search_string = query[:search].downcase.gsub(" ","%") unless query[:search].blank?
        
        activities = self
        .where("#{cloud_object_model.table_name}_id".to_sym => cloud_id)
        .order(id: :desc)
        .joins("inner join users u on #{self.table_name}.users_id = u.id")
        .joins("inner join user_details ud on ud.users_id = u.id")


        # Filter results by search string
        unless search_string.blank?
            # (LOWER(ud.last_name) SIMILAR TO '%#{search_string}%') OR 
            activities = activities.where("
            (LOWER(#{self.table_name}.field_name) SIMILAR TO '%#{search_string}%') OR
            (LOWER(#{self.table_name}.value_from) SIMILAR TO '%#{search_string}%') OR
            (LOWER(#{self.table_name}.value_to) SIMILAR TO '%#{search_string}%') OR
            (LOWER(ud.first_name) SIMILAR TO '%#{search_string}%')
            ")
        end

        activities = activities.map do |activity|
            # We translate the category, first, we search in the core
            category = I18n.t("core.shared.activities_enum_category_#{activity[:category]}", default: nil)
            
            # Then we search in the engine
            category = I18n.t("#{translations_module}.shared.activities_enum_category_#{activity[:category]}", default: nil) unless category
            
            #Then we default to the real field
            category = activity[:category] unless category

            activity_attributes = activity.attributes
            activity_attributes["category"] = category
            activity_attributes["created_at_raw"] = activity[:created_at]
            activity_attributes["created_at"] = LC::Date.to_string_datetime(activity[:created_at])
            activity_attributes["updated_at"] = LC::Date.to_string_datetime(activity[:updated_at])

            user = activity.user_creator
            activity_attributes[:user_name] = user.full_name

            activity_attributes
        end

        Kaminari.paginate_array(activities).page(query[:pagination][:page]).per(query[:pagination][:perPage])
    end
    
    # @return [void]
    # @param current_user [::User] The user that created the cloud_object
    # @param cloud_object [CloudModule::Model] The cloud_object that was created
    # @description Creates an activity for this cloud_object indicating who created it.
    # Example
    #   params = {...}
    #   ticket = CloudHelp::Ticket.create(params)
    #   CloudHelp::Ticket.log_create(User.first, ticket)
    def self.log_create(current_user, cloud_object)
        cloud_object.activities.create(
            user_creator: current_user,
            category: "action_create"
        )

        # If cloud_object has workflow
        if defined?(cloud_object.status)
            module_name = cloud_object.class.lesli_classname().split("::")[0].underscore
            cloud_object.activities.create(
                user_creator: current_user,
                category: "action_status",
                description: cloud_object.status&.name,
                field_name: "#{module_name}_workflow_statuses_id",
                value_to: cloud_object.status&.name
            )
        end

        yield if block_given?
    end

    # @return [void]
    # @param current_user [::User] The user that created the cloud_object
    # @param cloud_object [CloudModule::Model] The cloud_object that was shown
    # @description Creates an activity for this cloud_object indicating who view it.
    # Example
    #   params = {...}
    #   ticket = CloudHelp::Ticket.create(params)
    #   CloudHelp::Ticket.log_show(User.first, ticket)
    def self.log_show(current_user, cloud_object)
        cloud_object.activities.create(
            user_creator: current_user,
            category: "action_show"
        )

        yield if block_given?
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
    def self.log_update(current_user, cloud_object, old_attributes, new_attributes, category: "action_update")

        # We remove values that are not tracked in the activities
        old_attributes.except!("id", "created_at", "updated_at", "deleted_at")
        old_attributes.each do |key, value|
            next if value == new_attributes[key]
            if key.include?("id")
                if key == "user_main_id" || key == "users_id" || key == "user_branch_office_id"
                    update_user_field(cloud_object, current_user, key, old_attributes[key], new_attributes[key], category)
                elsif key.include?("workflow_statuses_id")
                    update_workflow_status_field(cloud_object, current_user, key, old_attributes[key], new_attributes[key])
                else
                    update_field(cloud_object, current_user, key, old_attributes[key], new_attributes[key], category)
                end
            else
                update_field(cloud_object, current_user, key, old_attributes[key], new_attributes[key], category)
            end
        end

        yield if block_given?
    end

    # @return [void]
    # @param current_user [::User] The user that deleted the cloud_object
    # @param cloud_object [CloudModule::Model] The cloud_object that was destroyed
    # @description Creates an activity for this cloud_object indicating that someone deleted it
    # Example
    #   ticket = CloudHelp::Ticket.find(1)
    #   CloudHelp::TicketLogger.log_destroy(User.first, ticket)
    #   ticket.destroy
    def self.log_destroy(current_user, cloud_object)
        cloud_object.activities.create(
            user_creator: current_user,
            category: "action_destroy"
        )

        yield if block_given?
    end

    protected

    # @return [void]
    # @param current_user [User] The user that deleted the cloud_object
    # @param cloud_object [CloudModule::Model] The cloud_object that updated
    # @param key [String] The user field to be logged
    # @param old_user_id [Integer] The id of the user prior to the update
    # @param new_user_id [Integer] The id of the user after the update
    # @description Logs an "action_update" activity. But instead of using the raw id of the user, it logs their name
    # @example
    #     project = CloudHouse::Project.first
    #     CloudHouse::ProjectLogger.log_update(User.first, project, "users_id", 1, 2)
    #     # This will log a change from user with id 1 to user with id 2 using their names
    def self.update_user_field(cloud_object, current_user, key, old_user_id, new_user_id, category)
        cloud_object.activities.create(
            user_creator: current_user,
            category: category,
            field_name: key,
            value_from: old_user_id ? User.with_deleted.find(old_user_id).full_name : nil,
            value_to:   new_user_id ? User.with_deleted.find(new_user_id).full_name : nil
        )
    end

    # @return [void]
    # @param current_user [User] The user that deleted the cloud_object
    # @param cloud_object [CloudModule::Model] The cloud_object that updated
    # @param key [String] The user field to be logged
    # @param old_workflow_status_id [Integer] The id of the workflow status prior to the update
    # @param new_workflow_status_id [Integer] The id of the workflow status after the update
    # @description Logs an "action_update" activity. But instead of using the raw id of the workflow status, it logs its name
    # @example
    #     project = CloudHouse::Project.first
    #     CloudHouse::ProjectLogger.log_update(User.first, project, "cloud_house_workflow_statuses_id, 1, 2)
    #     # This will log a change from workflow status with id 1 to workflow status with id 2 using their names
    def self.update_workflow_status_field(cloud_object, current_user, key, old_workflow_status_id, new_workflow_status_id)
        module_name = cloud_object.class.lesli_classname().split("::")[0]
        old_status = eval("#{module_name}::Workflow::Status").with_deleted.find(old_workflow_status_id).name
        new_status = eval("#{module_name}::Workflow::Status").with_deleted.find(new_workflow_status_id).name

        cloud_object.activities.create(
            user_creator: current_user,
            description: new_status,
            category: "action_status",
            field_name: key,
            value_from: old_status,
            value_to:   new_status
        )
    end

    # @return [void]
    # @param current_user [User] The user that deleted the cloud_object
    # @param cloud_object [CloudModule::Model] The cloud_object that updated
    # @param key [String] The user field to be logged
    # @param old_field [Integer] The value of the field prior to the update
    # @param new_field [Integer] The value of the field after the update
    # @description Logs an "action_update" activity. If the value that changed is a date, it uses LC::Date to turn it into a string
    #     otherwise, it logs it as is
    # @example
    #     ticket = CloudHelp::Ticket.first
    #     CloudHelp::TicketLogger.log_update(User.first, ticket, "deadline": Time.now - 1.days, Time.now)
    #     # This will log a change from workflow on the deadline, and it will use the format specified by the lesli instance
    def self.update_field(cloud_object, current_user, key, old_field, new_field, category)
        old_field = LC::Date.to_string_datetime(old_field) if old_field.is_a?(Time) || old_field.is_a?(Date)
        new_field = LC::Date.to_string_datetime(new_field) if new_field.is_a?(Time) || new_field.is_a?(Date)

        cloud_object.activities.create(
            user_creator: current_user,
            category: category,
            field_name: key,
            value_from: old_field,
            value_to: new_field
        )
    end
end
