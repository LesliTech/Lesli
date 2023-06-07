=begin
Copyright (c) 2021, all rights reserved.

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
class Account::Currency::ExchangeRate < ApplicationLesliRecord
    belongs_to :currency, inverse_of: :exchange_rates, foreign_key: "account_currencie_id"

    validates_presence_of :exchange_rate

    def self.index(current_user, query, currency)
        current_date = LC::Date.now

        active_exchange_rate_id = currency.exchange_rates.where(
            "(valid_from is null or valid_from <= ?) and valid_to >= ?",
            current_date,
            current_date
        ).maximum(:id)

        exchange_rates = currency.exchange_rates
        .page(query[:pagination][:page])
        .per(query[:pagination][:perPage])
        .order(valid_to: :desc)
        .select(
            :id,
            :exchange_rate,
            :account_currencie_id,
            :valid_from,
            :valid_to,
            LC::Date2.new.date_time.db_column("valid_from"),
            LC::Date2.new.date_time.db_column("valid_to"),
            LC::Date2.new.date_time.db_timestamps
        )

        LC::Response.pagination(
            exchange_rates.current_page,
            exchange_rates.total_pages,
            exchange_rates.total_count,
            exchange_rates.length,
            exchange_rates.map do |exchange_rate|
                
                exchange_rate_attributes = exchange_rate.attributes
                exchange_rate_attributes["valid_from_text"] = LC::Date.to_string_datetime(exchange_rate_attributes["valid_from"])
                exchange_rate_attributes["valid_to_text"] = LC::Date.to_string_datetime(exchange_rate_attributes["valid_to"])
                exchange_rate_attributes["active"] = true if exchange_rate.id == active_exchange_rate_id

                exchange_rate_attributes
            end
        )
    end

    def show(current_user, query)
        {
            id: self.id,
            exchange_rate: self.exchange_rate,
            valid_from: self.valid_from,
            valid_to: self.valid_to,
            created_at: LC::Date.to_string_datetime(self.created_at),
            account_currencie_id: self.account_currencie_id,
            valid_from_text: LC::Date.to_string_datetime(self.valid_from),
            valid_to_text: LC::Date.to_string_datetime(self.valid_to),
            created_at_text: LC::Date.to_string_datetime(self.created_at),
        }
    end
end
