



##############################################################
######################### DEPRECATED #########################
############ USE APPLICATION_LESLI_RECORD INSTEAD ############
##############################################################



module CloudObject
    class Base < ApplicationLesliRecord
        self.abstract_class = true
        
=begin
@return [void]
@param bypass_new_record [Boolean] Wheter it workflow should be set in *cloud_objects* that are not finished yet or not
@description If the record is new, associates a new workflow with it using the workflow's method
    *set_workflow*
@example
    ticket = CloudHelp::Ticket.new(
        detail_attributes: {
            subject: 'Test',
            cloud_help_ticket_types_id: 1,
            cloud_help_ticket_categories_id: 1,
            cloud_help_ticket_priorities_id: 1
        }
    )
    ticket.set_workflow
    ticket.save!
=end        
        def set_workflow(bypass_new_record=false)
            if new_record? || bypass_new_record
                dynamic_info = self.class.dynamic_info
                workflow_model = dynamic_info[:workflow_model]
                
                workflow_model.set_workflow(self)
            end
        end

=begin
@return [String]
@description Returns a string that represents and identifies this cloud_object from all other cloud_objects in the same account
@example
    project = CloudHouse::Project.find(1)
    puts projet.global_indentifier # If the CloudHouse::Project class does not have the method overrided, this wil print 'CloudHouse::Project - 1'
=end
        def global_identifier
            return "#{self.class.name} - #{id}"
        end

=begin
@return [Hash] Hash that contains information about the class
@description Returns dynamic information based on the current implementation of this abstract class
@example
    dynamic_info = CloudHelp::Ticket.dynamic_info
    puts dynamic_info[:activity_model].new # will print a new instance of CloudHelp::Ticket::Activity
    puts dynamic_info[:module_name] # will print 'help'
    puts dynamic_info[:workflow_status_model].new # will print a new instance of CloudHelp::Workflow::Status
    puts dynamic_info[:workflow_model].new # will print a new instance of CloudHelp::Workflow
=end
        def self.dynamic_info
            module_info = self.lesli_classname().split("::")
            {
                activity_model: "#{self.name}::Activity".constantize,
                module_name: module_info[0].sub("Cloud", "").downcase,
                workflow_model: "#{module_info[0]}::Workflow".constantize,
                workflow_status_model: "#{module_info[0]}::Workflow::Status".constantize
            }
        end

    end
end
