# This migration comes from cloud_team (originally 20190101000008)
class CreateCloudTeamEmployeeDetails < ActiveRecord::Migration[5.2]
    def change
        create_table :cloud_team_employee_details do |t|

            t.timestamps
        end
        add_reference :cloud_team_employee_details, :cloud_team_employees, foreign_key: true
    end
end
