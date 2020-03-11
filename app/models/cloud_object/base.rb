module CloudObject
    class Base < ApplicationRecord
        self.abstract_class = true

=begin
@return [void]
@description After a *cloud_object* is updated, this method can be triggered using the method
    *after_update* *:after_update_actions*. In the base, it checks if the state of the *cloud_object*
    changed. If it did, then a new CloudObject::Activity is created. Developers can extend this method if needed
@example
    ticket = CloudHelp::Ticket.first
    ticket.update(detail_attributes: {cloud_help_workflow_details_id: 4})
    # after the update, this method is executed automatically
=end
        def after_update_actions
            dynamic_info = self.class.dynamic_info
            module_name = dynamic_info[:module_name]
            activity_model = dynamic_info[:activity_model]
            workflow_status_model = dynamic_info[:workflow_status_model]

            workflow_change = saved_changes["cloud_#{module_name}_workflow_statuses_id"]
           
            if workflow_change
                old_status = workflow_status_model.find(workflow_change[0])
                new_status = workflow_status_model.find(workflow_change[1])
                activity_model.create!({
                    description: "#{new_status.name}",
                    field_name: "cloud_#{module_name}_workflow_statuses_id",
                    value_from: old_status.id,
                    value_to: new_status.id,
                    cloud_object: self
                })
            end
        end
        
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
            module_info = self.name.split("::")
            {
                activity_model: "#{self.name}::Activity".constantize,
                module_name: module_info[0].sub("Cloud", "").downcase,
                workflow_model: "#{module_info[0]}::Workflow".constantize,
                workflow_status_model: "#{module_info[0]}::Workflow::Status".constantize
            }
        end
    end
end
