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

    @info;
    @vue;

    def parse_information 

        engine, resources = name.split("/")

        # engine information 
        engine_code = engine.underscore

        # resource information 
        resources_code = resources.underscore

        @info = {
            :engine => engine,
            :engine_code => engine_code,
            :engine_name => engine_code.sub('cloud_', ''),

            :resources => resources,
            :resources_code => resources_code,
            :resources_camel => resources_code.camelcase(:lower),

            :resource => resources.singularize,
            :resource_camel => resources_code.singularize.camelcase(:lower)
        }
    end

    def parse_vue

        # generator information 
        path_base = Rails.root.join("engines", @info[:engine_code], "lib", "vue")

        @vue = {
            :path_base => path_base,
            :path_apps => path_base.join("apps", @info[:resources_code]),
            :path_store => path_base.join("stores", "#{ @info[:resources_camel] }.js")
        }
    end
end
