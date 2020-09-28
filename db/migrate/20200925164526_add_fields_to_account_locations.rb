class AddFieldsToAccountLocations < ActiveRecord::Migration[6.0]
    def change
        add_column :account_locations, :calling_code, :integer
    end
end
