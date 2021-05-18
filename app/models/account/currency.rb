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

    has_many :exchange_rates, inverse_of: :currency, foreign_key: "account_currencies_id"

    def self.index(current_user, query)
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
        
        # Executing the query
        current_date = LC::Date.now
        currencies = current_user.account.currencies
        .joins(:exchange_rates)
        .where("account_currency_exchange_rates.valid_from <= ?", current_date)
        .where("account_currency_exchange_rates.valid_to >= ?", current_date)
        .where(filters_query.join(" and "))
        .select(
            "account_currencies.created_at",
            "account_currencies.id",
            :name,
            :symbol,
            :country_alpha_3,
            :users_id,
            :user_main_id,
            :valid_from,
            :valid_to,
            :exchange_rate
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
                currency_attributes["descriptive_name"] = "#{currency.name} (#{currency.symbol})"

                currency_attributes
            end
        )
    end

    def show(current_user, query)
        self
    end

    def self.list(current_user, query)
        current_user.account.currencies.select(
            :id,
            :name,
            :symbol,
            :country_alpha_3,
            :accounts_id
        ).all
    end
end
