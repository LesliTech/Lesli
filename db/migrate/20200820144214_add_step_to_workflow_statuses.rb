class AddStepToWorkflowStatuses < ActiveRecord::Migration[6.0]
    def change
        add_column :cloud_house_workflow_statuses, :step, :integer, {default: 0}

        add_column :cloud_driver_workflow_statuses, :step, :integer, {default: 0}

        add_column :cloud_focus_workflow_statuses, :step, :integer, {default: 0}
    end
end
