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

Lesli · Ruby on Rails Development Platform.

Made with ♥ by https://www.lesli.tech
Building a better future, one line of code at a time.

@contact  hello@lesli.tech
@website  https://www.lesli.tech
@license  GPLv3 http://www.gnu.org/licenses/gpl-3.0.en.html

// · ~·~     ~·~     ~·~     ~·~     ~·~     ~·~     ~·~     ~·~     ~·~
// · 
=end
class ApplicationLesliGenerator < Rails::Generators::NamedBase 

    @information_vue;

    def parse_information_vue 

        engine, resource = name.split("/")

        # engine information 
        engine_code = engine.underscore

        # resource information 
        resource_code = resource.underscore

        # generator information 
        path_base = Rails.root.join("engines", engine_code, "lib", "vue")
        store_name = resource_code.camelcase(:lower)

        @information_vue = {
            :engine => engine,
            :engine_code => engine_code,

            :resource => resource,
            :resource_code => resource_code,
            
            :path_base => path_base,
            :path_apps => path_base.join("apps", resource_code),
            :path_store => path_base.join("stores", "#{ store_name }.js"),

            :store_name => store_name,
        }
    end

end
