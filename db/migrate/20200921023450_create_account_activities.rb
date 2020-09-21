class CreateAccountActivities < ActiveRecord::Migration[6.0]
  def change
    create_table :account_activities do |t|

      t.timestamps
    end
  end
end
