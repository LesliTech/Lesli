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

module ApplicationHelper

    # retun the code of the instance builder engine
    # example: lesli_cloud, deutsche_leibrenten, mitwerken_cloud
    def lesli_instance_code()
        LC::System::Info.instance[:code]
    end

    # return the engine code of the controller that is handling the http request
    def lesli_engine()
        controller_path.split('/')[0]
    end

    # return true if the controller requested belongs to the administration area
    def is_lesli_engine_administration?
        [
            "accounts", "account", "roles", "profiles", "users", "abouts", 
            "settings", "cronos", "onboarding", "role_descriptors"
        ].include?(lesli_engine)
    end

    # return true if the controller belongs to an engine nor to builder or administration area
    def is_lesli_engine?(engine=nil)
        current_engine = lesli_engine
        return current_engine == engine if not engine.blank?
        return false if is_lesli_engine_administration?
        return true
    end

    # return the name of the engine loaded for the current path
    # this helper return the name of the engine of the code we are running on
    # example: https://lesli.cloud/driver/events/1/edit -> engine loaded: cloud_driver
    def lesli_engine_or_instance
        return lesli_instance_code if not is_lesli_engine?
        return lesli_engine
    end

    # return the information about the current engine
    def lesli_engine_or_instance_info
        Rails.application.config.lesli.dig(:engines).select { |engine| engine[:code] == lesli_engine_or_instance() }.first
    end

    # check if instance or engine is a builder
    def is_lesli_instance?(instance=nil, engine=nil)

        # return instance name
        return Rails.application.config.lesli[:info][:name] if instance.blank? and engine.blank?

        # current engine id
        current_engine = controller_path.split('/')[0]

        # validate instance
        if Rails.application.config.lesli[:info][:name] == instance and engine.blank?
            return true
        end

        # validate instance and engine
        if Rails.application.config.lesli[:info][:name] == instance and current_engine == engine
            return true
        end

        return false

    end

    # Prints the name of the engine
    def engine_name
        name = lesli_engine_or_instance().sub("_cloud", "").sub("cloud_", "").camelize
        return nil if name == "Lesli"
        name
    end

    # DEPRECATED: used the credentials method directly where you need credentials
    # currently we do not allow helpers or any other method to access credentials for us
    def integration_access_token(integration_name)
        LC::Debug.deprecation("Use Rails.application.credentials directly where it needs to be used")
        return Rails.application.credentials.integrations[integration_name][:access_token]
    end

end
