=begin

Lesli

Copyright (c) 2020, Lesli Technologies, S. A.

All the information provided by this website is protected by laws of Guatemala related 
to industrial property, intellectual property, copyright and relative international laws. 
Lesli Technologies, S. A. is the exclusive owner of all intellectual or industrial property
rights of the code, texts, trade mark, design, pictures and any other information.
Without the written permission of Lesli Technologies, S. A., any replication, modification,
transmission, publication is strictly forbidden.
For more information read the license file including with this software.

LesliCloud - Your Smart Business Assistant

Powered by https://www.lesli.tech
Building a better future, one line of code at a time.

@license  Propietary - all rights reserved.
@version  0.1.0-alpha

// · ~·~     ~·~     ~·~     ~·~     ~·~     ~·~     ~·~     ~·~     ~·~     ~·~     ~·~     ~·~
// · 

=end
class Setting < ApplicationRecord
    belongs_to :account, foreign_key: 'accounts_id'

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
            'password_expiration_time_months'
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

        current_user.account.settings.where(query_filters.join(" or "))
    end
end
