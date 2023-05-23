=begin

Copyright (c) 2023, all rights reserved.

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

    belongs_to :account

    def self.initialize_data(account)
        lesli_config = Rails.application.config.lesli.dig(:configuration)

        # Initializing datetime settings
        lesli_config[:datetime].each do |key, value|
            account.settings.create!({
                name: key,
                value: value
            })
        end

        self.reset_all(account)
    end

    def self.reset_all(account)
        # Set default password complexity configuration
        # Here is used update instead of create_with because the purpose is to force the set of the value
        account.settings.find_or_create_by(name: 'password_enforce_complexity').update(value: 1)
        account.settings.find_or_create_by(name: 'password_expiration_time_days').update(value: 365)
        account.settings.find_or_create_by(name: 'password_special_char_count').update(value: 0)
        account.settings.find_or_create_by(name: 'password_lowercase_count').update(value: 0)
        account.settings.find_or_create_by(name: 'password_uppercase_count').update(value: 0)
        account.settings.find_or_create_by(name: 'password_minimum_length').update(value: 6)
        account.settings.find_or_create_by(name: 'password_digit_count').update(value: 0)

        datetime = Rails.application.config.lesli.dig(:configuration, :datetime)
        account.settings.find_or_create_by(name: 'datetime_time_zone').update(value: datetime[:time_zone])
        account.settings.find_or_create_by(name: 'datetime_start_week_on').update(value: datetime[:start_week_on])
        account.settings.find_or_create_by(name: 'datetime_format_date').update(value: datetime[:formats][:date])
        account.settings.find_or_create_by(name: 'datetime_format_time').update(value: datetime[:formats][:time])
        account.settings.find_or_create_by(name: 'datetime_format_date_time').update(value: datetime[:formats][:date_time])
        account.settings.find_or_create_by(name: 'datetime_format_date_words').update(value: datetime[:formats][:date_words])
        account.settings.find_or_create_by(name: 'datetime_format_date_time_words').update(value: datetime[:formats][:date_time_words])
    end

    def self.theme_settings_keys
        [
            'lesli_theme_color_primary',
            'lesli_theme_color_secondary',
            'lesli_theme_color_header',
            'lesli_theme_color_sidebar',
            'lesli_theme_color_background',
            'lesli_theme_font_color',
            'lesli_theme_font_size'
        ]
    end

    def self.index(current_user, query)

        query_filters = []

        theme_settings = self.theme_settings_keys

        time_settings = [
            'date_format',
            'date_format_full',
            'date_format_time',
            'time_zone',
            'start_week_on'
        ]

        password_settings = [
            'password_enforce_complexity',
            'password_expiration_time_days',
            'password_special_char_count',
            'password_lowercase_count',
            'password_uppercase_count',
            'password_minimum_length',
            'password_digit_count'
        ]

        currency_settings = [
            'default_currency',
        ]

        # filter[:theme] will indicate if must show theme settings.
        # filter[:time] will indicate if must show time settings.
        # filter[:password] will indicate if must show password settings.
        # For example, filter[:theme] = true

        if query[:filters][:theme] == "true"
            theme_settings.map do |setting_name|
                query_filters.push("name = '#{setting_name}'")
            end
        end

        if query[:filters][:time] == "true"
            time_settings.map do |setting_name|
                query_filters.push("name = '#{setting_name}'")
            end
        end

        if query[:filters][:password] == "true"
            password_settings.map do |setting_name|
                query_filters.push("name = '#{setting_name}'")
            end
        end

        if query[:filters][:goals] == "true"
            query_filters.push("name = 'configuration_dashboard_goals'")
        end

        if query[:filters][:currency] == "true"
            currency_settings.map do |setting_name|
                query_filters.push("name = '#{setting_name}'")
            end
        end

        current_user.account.settings.order(created_at: :asc).where(query_filters.join(" or "))

    end

    def self.options(current_user, query)
        time_zones = ActiveSupport::TimeZone::MAPPING.map { |key, value| { value: value, text: value } }

        return {
            time_zones: time_zones.uniq { |time_zone| [time_zone[:value], time_zone[:text]] },
            days_into_week: DateAndTime::Calculations::DAYS_INTO_WEEK.map { |day, value| { value: day, text: I18n.t("core.shared.view_text_day_#{day}") } },
        }
    end

    # This method updates a list of settings for the current account
    def self.update(current_user, params)
        if params.empty?
            return false
        end

        params.each do |key, value|
            setting = current_user.account.settings.find_by(name: key)

            if setting.present?
                setting.update_attribute(:value, value)
            else
                current_user.account.settings.create!(name: key, value: value)
            end
        end

        return true
    end

end
