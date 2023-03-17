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
        