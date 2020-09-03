class CreateTemplates < ActiveRecord::Migration[6.0]
    def change
        create_table :templates do |t|
            t.datetime :deleted_at, index: true
            
            t.timestamps
        end
        
        add_reference :templates, :accounts, foreign_key:true
    end
end