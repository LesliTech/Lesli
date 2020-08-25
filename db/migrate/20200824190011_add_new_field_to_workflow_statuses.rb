class AddNewFieldToWorkflowStatuses < ActiveRecord::Migration[6.0]
    def change
        add_column :cloud_house_workflow_statuses, :status_type, :string
        add_column :cloud_driver_workflow_statuses, :status_type, :string
        add_column :cloud_focus_workflow_statuses, :status_type, :string
    end
end
