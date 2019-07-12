# This migration comes from cloud_team (originally 20190101000007)
class CreateCloudTeamEmployees < ActiveRecord::Migration[5.2]
    def change
        create_table :cloud_team_employees do |t|

            t.timestamps
        end
        add_reference :cloud_team_employees, :cloud_team_accounts, foreign_key: true
    end
end
