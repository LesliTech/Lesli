=begin
    
Copyright (c) 2020, all rights reserved.

All the information provided by this platform is protected by international laws related  to 
industrial property, intellectual property, copyright and relative international laws. 
All intellectual or industrial property rights of the code, texts, trade mark, design, 
pictures and any other information belongs to the owner of this platform.

Without the written permission of the owner, any replication, modification,
transmission, publication is strictly forbidden.

For more information read the license file including with this software.

// · ~·~     ~·~     ~·~     ~·~     ~·~     ~·~     ~·~     ~·~     ~·~     ~·~     ~·~     ~·~
// · 
    
=end
class CreateAccountCurrencyExchangeRates < ActiveRecord::Migration[6.1]
    def change  
        create_table :account_currency_exchange_rates do |t|
            t.decimal   :exchange_rate

            t.timestamp :valid_from
            t.timestamp :valid_to

            # Foreign key to another currency 
            t.bigint    :reference_currency_id
            
            # Acts as paranoid
            t.datetime  :deleted_at, index: true
            
            t.timestamps
        end
        
        add_reference   :account_currency_exchange_rates, :account_currencies,  foreign_key: true, index: {name: "account_currency_exchange_rates_account_currencies"}
        add_foreign_key :account_currency_exchange_rates, :account_currencies,  column: :reference_currency_id, index: {name: "account_currency_exchange_rates_reference_currency"}
    end
end
