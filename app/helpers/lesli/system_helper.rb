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

Made with ♥ by https://www.lesli.tech
Building a better future, one line of code at a time.

@contact  hello@lesli.tech
@website  https://www.lesli.dev
@license  GPLv3 http://www.gnu.org/licenses/gpl-3.0.en.html

// · ~·~     ~·~     ~·~     ~·~     ~·~     ~·~     ~·~     ~·~     ~·~
// ·
=end

module Lesli
    module SystemHelper
        # return the engine code of the controller that is handling the http request
        def lesli_controller
            controller_path.split("/")[0]
        end

        # retun the code of the instance builder engine
        # example: lesli_cloud, deutsche_leibrenten, mitwerken_cloud
        def lesli_instance_code
            return "lesli"
            Lesli::System.instance[:code]
        end

        # return the information about the current engine
        def lesli_engine(property = nil)
            Lesli::System.engine(lesli_controller.camelize, property)
        end

        # return true if the controller requested belongs to the administration area
        def is_lesli_onboarding?
            lesli_controller == "onboardings"
        end
    end
end
