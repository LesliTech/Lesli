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

module LesliHelper

    # return the engine code of the controller that is handling the http request
    def lesli_controller()
        controller_path.split('/')[0]
    end

    # retun the code of the instance builder engine
    # example: lesli_cloud, deutsche_leibrenten, mitwerken_cloud
    def lesli_instance_code()
        LC::System::Info.instance[:code]
    end

    # return the information about the current engine
    def lesli_engine(property=nil)

        # build a special object for the administration section
        if is_lesli_administration?()
            return { 
                :name => "Administration", 
                :code => "administration",
                :core => 3 
            } 
        end

        # build a special object for the onboarding section
        if is_lesli_onboarding?()
            return { 
                :name => "Onboarding", 
                :code => "onboardings",
                :core => 3 
            } 
        end

        # search for the info of the current engine
        engine = Rails.application.config.lesli.dig(:engines).select { |engine| 
            engine[:code] == lesli_controller() 
        }.first
        
        # build a special object for the core
        engine = { :name => "Lesli", :code => "lesli", :core => 3 } if engine.nil?

        # return specific property if requested
        return engine.dig(property) unless property.blank?

        # return the engine info
        engine

    end

    # Prints the name of the engine
    def lesli_engine_name
        name = lesli_engine.dig(:name)
        name = "Admin" if is_lesli_administration?()
        name = name.sub("Cloud", "")
        return nil if name == "Lesli"
        name
    end

    # return true if the controller requested belongs to the administration area
    def is_lesli_administration?
        [
            "accounts", "account", "roles", "profiles", "users", "abouts", 
            "settings", "cronos", "role_descriptors", "descriptors"
        ].include?(lesli_controller())
    end

    # return true if the controller requested belongs to the administration area
    def is_lesli_onboarding?
        lesli_controller() == "onboardings"
    end

end
