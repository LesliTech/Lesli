# This migration comes from cloud_team (originally 20190101000001)
class CreateCloudTeamAccounts < ActiveRecord::Migration[5.2]
    def change
        create_table :cloud_team_accounts do |t|

            t.timestamps
        end
        add_reference :cloud_team_accounts, :accounts, foreign_key: true
    end
end
