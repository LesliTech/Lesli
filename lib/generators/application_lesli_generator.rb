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


=begin

Information reference:


rails generate lesli:test CloudEngine/Things

@info = {
    :engine=>"CloudEngine",
    :engine_code=>"cloud_engine",
    :engine_name=>"engine",
    :resources=>"Things",
    :resources_code=>"things",
    :resources_camel=>"things",
    :resource=>"Thing",
    :resource_camel=>"thing"
}

@vue = {
    :path_base=> "~/engines/cloud_engine/lib/vue",
    :path_apps=> "~/engines/cloud_engine/lib/vue/apps/thing",
    :path_store=> "~/engines/cloud_engine/lib/vue/stores/thing.js",
    :path_components=> "~/engines/cloud_engine/lib/vue/apps/thing/components"
}

@services = {
    :path=> "~/engines/cloud_engine/app/services/thing_services.rb"
}

@rspec = {
    :path_request=> "~/engines/cloud_engine/spec/requests/thing"
}
=end
module Lesli
    class ApplicationLesliGenerator < Rails::Generators::NamedBase 

        @info;
        @model;
        @services;
        @rspec;
        @vue;

        def parse_info 

            engine, resource = name.split("/")

            # engine information 
            engine_code = engine.underscore

            # resource information 
            resource_code = resource.underscore

            @info = {
                :engine => engine,
                :engine_code => engine_code,
                :engine_resource => "#{engine}::#{resource}",

                :resource => resource,
                :resource_code => resource_code,
            }
        end

        def parse_model 

            tabla = "#{@info[:engine_resource]}".constantize
            .columns.map do |column| 
                value = '""' if column.type == :string
                value = 1 if column.type == :integer
                value = "'#{Time.now}'" if column.type == :datetime
                { 
                    :name => column.name, 
                    :type => column.type,
                    :value => value
                }
            end

            @model = {
                :name => @info[:engine_resource],
                :columns => tabla
            }
        end

        # def parse_services 

        #     path_base = Rails.root.join("engines", @info[:engine_code], "app", "services")

        #     @services = {
        #         :path => path_base.join(@info[:resource].downcase + "_services.rb")
        #     }
        # end

        # def parse_vue

        #     path_base = Rails.root.join("engines", @info[:engine_code], "lib", "vue")

        #     @vue = {
        #         :path_base => path_base,
        #         :path_apps => path_base.join("apps", @info[:resources_code]),
        #         :path_store => path_base.join("stores", "#{ @info[:resources_camel] }.js"),
        #         :path_components => path_base.join("apps", @info[:resources_code], "components")
        #     }
        # end

        # def parse_rspec 
        #     path_base = Rails.root.join("engines", @info[:engine_code], "spec")

        #     @rspec = {
        #         :path_request => path_base.join("requests", @info[:resources_code]),
        #         :url => @info[:engine_name] + "/" + @info[:resources_code]
        #     }
        # end
    end
end
