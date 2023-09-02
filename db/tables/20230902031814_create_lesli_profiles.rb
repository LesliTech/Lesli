class CreateLesliProfiles < ActiveRecord::Migration[7.0]
  def change
    create_table :lesli_profiles do |t|

      t.timestamps
    end
  end
end
