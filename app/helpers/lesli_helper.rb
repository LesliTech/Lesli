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

Lesli · Your Smart Business Assistant. 

Made with ♥ by https://www.lesli.tech
Building a better future, one line of code at a time.

@contact  hello@lesli.tech
@website  https://lesli.tech
@license  GPLv3 http://www.gnu.org/licenses/gpl-3.0.en.html

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
        Lesli::System.instance[:code]
    end

    # return the information about the current engine
    def lesli_engine(property=nil)

        engine = nil 

        # build a special object for the administration section
        if is_lesli_administration?()
            engine = { 
                :name => "Administration", 
                :code => "administration",
                :core => 3 
            } 
        end

        # build a special object for the onboarding section
        if is_lesli_onboarding?()
            engine = { 
                :name => "Onboarding", 
                :code => "onboardings",
                :core => 3 
            } 
        end

        if engine.nil? 

            # search for the info of the current engine
            engine = Rails.application.config.lesli.dig(:engines).select { |engine| 
                engine[:code] == lesli_controller() 
            }.first
        end
        
        if engine.nil?

            # build a special object for the core
            engine = { :name => "Lesli", :code => "lesli", :core => 3 } 
        end

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
