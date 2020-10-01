module CloudObject
    class Dashboard < ApplicationLesliRecord
        self.abstract_class = true

=begin
@return [Hash] Hash of containing the information of the dashboard and its statuses. 
@description Returns a hash with information about the dashboard and all its *statuses* 
    that contain the transitions between *states*
@example
    dashboard = CloudHelp::Dashboard.first.full_dashboard
    responseWithSuccessful(dashboard)
=end
        def show
            attributes.merge({
                components: components.order(index: :asc)
            })
        end

        private
        
=begin
@return [Hash] Hash that contains information about the class
@description Returns dynamic information based on the current implementation of this abstract class
@example
    dynamic_info = CloudHelp::Dashboard.dynamic_info
    puts dynamic_info[:module_name] # will print 'help'
    puts dynamic_info[:component_model].new # will print a new instance of CloudHelp::Dashboard::Status
    puts dynamic_info[:component_model] # will print a new instance of CloudHelp::Dashboard::Component
=end
        def self.dynamic_info
            module_info = self.lesli_classname().split("::")
            
            module_name = module_info[0].sub("Cloud", "").downcase

            {
                module_name: module_name,
                component_model: "#{self.name}::Component".constantize
            }
        end
    end
end
