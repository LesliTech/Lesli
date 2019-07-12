# This migration comes from cloud_team (originally 20190101000009)
class CreateCloudTeamEmployeeContactDetails < ActiveRecord::Migration[5.2]
    def change
        create_table :cloud_team_employee_contact_details do |t|

            t.timestamps
        end
        add_reference :cloud_team_employee_contact_details, :cloud_team_employees, foreign_key: true, index: { name: 'team_employee_contact_details-team_employees'}
    end
end
