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
                pagination: {},
                filtering: {},
                arrangement: {}
            }
            
            if configuration
                parsed_configuration[:pagination] = (configuration["pagination"] || {})
                parsed_configuration[:filtering] = (configuration["filtering"] || {})
                parsed_configuration[:arrangement] = (configuration["arrangement"] || {})
            end

            parsed_configuration
        end

        def has_all_privileges?(user, required_privileges)
            role = user.role

            required_privileges.each do |grant_object, actions|
                privilege = role.privileges.find_by(grant_object: grant_object)

                actions.each do |action|
                    unless privilege["grant_#{action}".to_sym]
                        return false
                    end
                end
            end

            return true
        end
    end
end
        