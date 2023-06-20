=begin

Lesli

Copyright (c) 2023, Lesli Technologies, S. A.

This program is free software: you can redistribute it and/or modify
it under the terms of the GNU General Public License as published by
the Free Software Foundation, either version 3 of the License, or
(at your option) any later version.

This program is distributed in the hope that it will be useful,
but WITHOUT ANY WARRANTY; without even the implied warranty of
MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the
GNU General Public License for more details.

You should have received a copy of the GNU General Public License
along with this program. If not, see http://www.gnu.org/licenses/.

Lesli · Your Smart Business Assistant. 

Made with ♥ by https://www.lesli.tech
Building a better future, one line of code at a time.

@contact  hello@lesli.tech
@website  https://lesli.tech
@license  GPLv3 http://www.gnu.org/licenses/gpl-3.0.en.html

// · ~·~     ~·~     ~·~     ~·~     ~·~     ~·~     ~·~     ~·~     ~·~     ~·~     ~·~     ~·~
// ·

=end
class Account::Currency::ExchangeRate < ApplicationLesliRecord
    belongs_to :currency, inverse_of: :exchange_rates, foreign_key: "account_currencies_id"

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
            :account_currencies_id,
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
            account_currencies_id: self.account_currencies_id,
            valid_from_text: LC::Date.to_string_datetime(self.valid_from),
            valid_to_text: LC::Date.to_string_datetime(self.valid_to),
            created_at_text: LC::Date.to_string_datetime(self.created_at),
        }
    end
end
