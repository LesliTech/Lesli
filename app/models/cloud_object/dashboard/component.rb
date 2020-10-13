module CloudObject
    class Dashboard::Component < ApplicationLesliRecord
        self.abstract_class = true

        enum component_ids: {}

        def render_data(current_user, query)
            if self.class.respond_to?(component_id.to_sym) && self.class.component_ids[component_id.to_sym]
                self.public_send(component_id.to_sym, current_user, query)
            else
                nil
            end
        end

        protected

        # @return [Hash] Hash that contains information about the class
        # @description Returns dynamic information based on the current implementation of this abstract class
        # @example
        #     # Imagine the current class is an instance of CloudHelp::Workflow::Action < CloudObject::Workflow::Action
        #     info = dynamic_info
        #     puts info[:module_name] # will print 'help'
        def self.dynamic_info
            module_info = self.lesli_classname().split("::")

            module_name = module_info[0].sub("Cloud", "").downcase
            {
                module_name: module_name,
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
        