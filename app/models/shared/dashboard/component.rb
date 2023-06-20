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
module Shared
    class Dashboard::Component < ApplicationLesliRecord
        self.abstract_class = true

        enum component_ids: {}

        def render_data(current_user, query)
            model_method = component_id.gsub("-","_").to_sym
            if self.class.respond_to?(model_method) && self.class.component_ids[model_method]
                self.public_send(model_method, current_user, query)
            else
                return "model method not found"
            end
        end

        def self.configuration_options
            return {}
        end

        protected

        # @return [Hash] Hash that contains information about the class
        # @description Returns dynamic information based on the current implementation of this abstract class
        # @example
        #     # Imagine the current class is an instance of CloudHelp::Workflow::Action < Shared::Workflow::Action
        #     info = dynamic_info
        #     puts info[:module_name] # will print 'help'
        def self.dynamic_info
            module_info = self.lesli_classname().split("::")

            module_name = module_info[0].sub("Cloud", "").downcase
            {
                module_name: module_name,
                full_module_name: module_info[0],
                engine_name: module_info[0]
            }
        end

        # @return [Hash] Hash where keys are strings. It contains information about the specific configuration of the component
        # @description Parses and returns the configuration stored in database for the specific component (like dates). If the field is null, an empty array is returned.
        # @example
        #   puts CloudHouse::Dashboard::Component.first.configuration
        #   # This will display something like {date: "2020-08-01"}
        #   puts CloudHouse::Dashboard::Component.first.parse_configuration
        #   # This will display something like {date: <Date Thrustday Augusto 1, 2020>}
        def parse_configuration
            parsed_configuration = {
                query: {
                    pagination: {},
                    filters: {},
                },
                custom: {
                    arrangement: {}
                }
            }
            
            if query_configuration
                parsed_configuration[:query][:pagination] = (query_configuration["pagination"] || {})
                parsed_configuration[:query][:filters] = (query_configuration["filters"] || {})
            end

            if custom_configuration
                parsed_configuration[:custom][:arrangement] = (custom_configuration["arrangement"] || {})
            end

            parsed_configuration
        end
    end
end
        