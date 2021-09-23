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
class Account::Currency < ApplicationLesliRecord
    belongs_to :account, foreign_key: "accounts_id", class_name: "Account"
    belongs_to :user_main, foreign_key: "user_main_id", class_name: "User"
    belongs_to :user, foreign_key: "users_id", class_name: "User"


    has_many :exchange_rates, inverse_of: :currency, foreign_key: "account_currencies_id", class_name: "Account::Currency::ExchangeRate"

    def self.index(current_user, query)
        currencies = current_user.account.currencies
        # Parsing filters
        filters = query[:filters]
        filters_query = []

        # We filter by a text string written by the user
        if filters["query"] && !filters["query"].empty?
            query_words = filters["query"].split(" ")
            query_words.each do |query_word|
                query_word = query_word.strip.downcase

                # Filtering by currency data
                filters_query.push("(
                    lower(account_currencies.name) similar to '%#{query_word}%' or
                    lower(account_currencies.country_alpha_3) similar to '%#{query_word}%'
                )")
            end
        end

        if query[:search] && query[:search].present?
            currencies =  currencies.where("lower(account_currencies.name) like :search_string", {
                search_string: "%#{query[:search]}%"
            })
        end

        # To include only currencies with valid exchange rates
        # .filters({
        #   include: {
        #       only: "exchange_rates"
        #   }
        # })
        if filters[:include] && filters[:include] == "exchange_rates"
            current_date = LC::Date.now

            currencies = currencies
            .joins("
                left join (
                    select exchange_rate, valid_from, valid_to, account_currency_exchange_rates.account_currencies_id
                    from account_currency_exchange_rates inner join(
                        select account_currencies_id, max(id) as id
                        from account_currency_exchange_rates 
                        where deleted_at is null and
                        (valid_from <= '#{current_date.to_s(:db)}' or valid_from is null) and
                        valid_to >= '#{current_date.to_s(:db)}'
                        group by account_currencies_id
                    ) as latest_exchange_rate on latest_exchange_rate.id = account_currency_exchange_rates.id
                ) as exchange_rates on
                    exchange_rates.account_currencies_id = account_currencies.id
            ")
            .select(
                :valid_from,
                :valid_to,
                :exchange_rate
            )
        end

        currencies = currencies
        .where(filters_query.join(" and "))
        .select(
            LC::Date2.new.date_time.db_timestamps("account_currencies"),
            "account_currencies.created_at",
            "account_currencies.id",
            :name,
            :symbol,
            :country_alpha_3,
            :users_id,
            :user_main_id
        )

        # Adding pagination to the currencies
        pagination = query[:pagination]
        currencies = currencies.page(
            pagination[:page]
        ).per(
            pagination[:perPage]
        ).order(
            "#{pagination[:orderBy]} #{pagination[:order]} nulls last"
        )

        LC::Response.pagination(
            currencies.current_page,
            currencies.total_pages,
            currencies.total_count,
            currencies.length,
            currencies.map do |currency|
                currency_attributes = currency.attributes
                currency_attributes["valid_from_text"] = LC::Date.to_string_datetime(currency_attributes["valid_from"])
                currency_attributes["valid_to_text"] = LC::Date.to_string_datetime(currency_attributes["valid_to"])
                currency_attributes["descriptive_name"] = "#{currency.country_alpha_3} (#{currency.symbol})"

                currency_attributes
            end
        )
    end

    def show(current_user, query)
        self
    end

    def self.list(current_user, query)
        current_date = LC::Date.now
        current_user.account.currencies.joins(:exchange_rates)
        .where("account_currency_exchange_rates.valid_from <= ?", current_date)
        .where("account_currency_exchange_rates.valid_to >= ?", current_date)
        .select(
            LC::Date2.new.date_time.db_timestamps("account_currencies"),
            "account_currencies.created_at",
            "account_currencies.id",
            :name,
            :symbol,
            :country_alpha_3,
            :users_id,
            :user_main_id,
            LC::Date2.new.date_time.db_column("valid_from"),
            LC::Date2.new.date_time.db_column("valid_to"),
            :valid_from,
            :valid_to,
            :exchange_rate,
        )
    end
end
