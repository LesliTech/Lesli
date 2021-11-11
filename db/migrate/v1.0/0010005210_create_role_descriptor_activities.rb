class CreateRoleDescriptorActivities < ActiveRecord::Migration[6.1]
    def change
        table_base_structure = JSON.parse(File.read(Rails.root.join('db','structure','00000004_activities.json')))
        create_table :role_descriptor_activities do |t|
            table_base_structure.each do |column|
                t.send(
                    column["type"].parameterize.underscore.to_sym,
                    column["name"].parameterize.underscore.to_sym
                )
            end
            t.timestamps
        end
        
        add_reference   :role_descriptor_activities, :role_descriptors, foreign_key: true, index: { name: "role_descriptor_activities_descriptors" }
        add_foreign_key :role_descriptor_activities, :users, column: :users_id
    end 
end
