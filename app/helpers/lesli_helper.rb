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
    def is_lesli_administration?
        [
            "accounts", "account", "roles", "profiles", "users", "abouts", 
            "settings", "cronos", "role_descriptors"
        ].include?(lesli_engine)
    end

    # return true if the controller requested belongs to the administration area
    def is_lesli_onboarding?
        lesli_engine == "onboardings"
    end

end
