module CloudObject
    class Base < ApplicationRecord
        self.abstract_class = true

        
        def set_workflow
            if new_record?
                dynamic_info = self.class.dynamic_info
                workflow_model = dynamic_info[:workflow_model]
                
                workflow_model.set_workflow(self)
            end
        end

=begin
@return [Hash] Hash that contains information about the class
@description Returns dynamic information based on the current implementation of this abstract class
@example
    dynamic_info = CloudHelp::Ticket.dynamic_info
    puts dynamic_info[:module_name] # will print 'help'
    puts dynamic_info[:detail_model].new # will print a new instance of CloudHelp::TicketWorkflow::Detail
    puts dynamic_info[:object_name] # will print ticket_workflow
=end
        def self.dynamic_info
            module_info = self.name.split("::")
            {
                module_name: module_info[0].sub("Cloud", "").downcase,
                workflow_model: "#{module_info[0]}::#{module_info[1]}Workflow".constantize,
            }
        end
    end
end
