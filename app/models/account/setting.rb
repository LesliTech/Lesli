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

class Account::Setting < ApplicationRecord

    belongs_to :account, foreign_key: "accounts_id"

    def self.initialize_data(account)
        lesli_config = Rails.application.config.lesli_settings["configuration"]

        # Initializing datetime settings
        lesli_config["datetime"].each do |key, value|
            account.settings.create!({
                name: key,
                value: value
            })
        end

        # Initializing password settings
        lesli_config["security"]["password"].each do |key, value|
            key = "password_#{key}" unless key.start_with? "password"

            account.settings.create!({
                name: key, 
                value: value
            })
        end
    end

    def self.list(current_user, query)
        
        query_filters = []

        theme_settings = [
            'theme',
            'theme_variation'
        ]

        time_settings = [
            'date_format',
            'date_format_full',
            'date_format_time',
            'time_zone',
            'start_week_on'
        ]

        password_settings = [
            'password_minimum_length',
            'password_expiration_time_months',
            'password_expiration_time_days'
        ]

        currency_settings = [
            'default_currency',
        ]

        # filter[:theme] will indicate if must show theme settings.
        # filter[:time] will indicate if must show time settings.
        # filter[:password] will indicate if must show password settings.
        # For example, filter[:theme] = true

        if query[:filters][:theme] == 'true'
            theme_settings.map do |setting_name|
                query_filters.push("name = '#{setting_name}'")
            end
        end

        if query[:filters][:time] == 'true'
            time_settings.map do |setting_name|
                query_filters.push("name = '#{setting_name}'")
            end
        end

        if query[:filters][:password] == 'true'
            password_settings.map do |setting_name|
                query_filters.push("name = '#{setting_name}'")
            end
        end

        if query[:filters][:goals] == 'true'
            query_filters.push("name = 'configuration_dashboard_goals'")
        end

        if query[:filters][:currency] == 'true'
            currency_settings.map do |setting_name|
                query_filters.push("name = '#{setting_name}'")
            end
        end

        current_user.account.settings.where(query_filters.join(" or "))

    end

    def self.options(current_user, query)
        time_zones = ActiveSupport::TimeZone::MAPPING.map do |key, value|
            {value: value, text: value}
        end
        return {
            time_zones: time_zones.uniq {|time_zone| [time_zone[:value], time_zone[:text]]},
            days_into_week: DateAndTime::Calculations::DAYS_INTO_WEEK.map {|day, value| { value: day, text: I18n.t("core.shared.view_text_day_#{day}") }},
        }
    end
end
