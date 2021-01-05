class CreateRoleActivities < ActiveRecord::Migration[6.0]
  def change
    table_base_structure = JSON.parse(File.read(Rails.root.join('db','structure','00000004_activities.json')))
        create_table :role_activities do |t|
            table_base_structure.each do |column|
                t.send(
                    column["type"].parameterize.underscore.to_sym,
                    column["name"].parameterize.underscore.to_sym
                )
            end
            t.timestamps
        end
        
        add_reference   :role_activities, :roles, foreign_key: true, index: { name: "role_activities_roles" }
        add_foreign_key :role_activities, :users, column: :users_id
    end
end
