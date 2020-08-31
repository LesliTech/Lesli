class RemoveDedicatedFieldsFromWorkflowStatuses < ActiveRecord::Migration[6.0]
    def change
        remove_column :cloud_house_workflow_statuses, :initial
        remove_column :cloud_house_workflow_statuses, :to_be_deleted
        remove_column :cloud_house_workflow_statuses, :completed_successfully
        remove_column :cloud_house_workflow_statuses, :completed_unsuccessfully
        
        remove_column :cloud_driver_workflow_statuses, :initial
        remove_column :cloud_driver_workflow_statuses, :to_be_deleted
        remove_column :cloud_driver_workflow_statuses, :completed_successfully
        remove_column :cloud_driver_workflow_statuses, :completed_unsuccessfully
        
        remove_column :cloud_focus_workflow_statuses, :initial
        remove_column :cloud_focus_workflow_statuses, :to_be_deleted
        remove_column :cloud_focus_workflow_statuses, :completed_successfully
        remove_column :cloud_focus_workflow_statuses, :completed_unsuccessfully
    end
end
