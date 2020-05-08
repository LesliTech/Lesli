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

Lesli - Your Smart Business Assistant

Powered by https://www.lesli.tech
Building a better future, one line of code at a time.

@contact  <hello@lesli.tech>
@website  <https://lesli.tech>
@license  Propietary - all rights reserved.

// · ~·~     ~·~     ~·~     ~·~     ~·~     ~·~     ~·~     ~·~     ~·~     ~·~     ~·~     ~·~
// · 

=end

# · Lesli Core
# · LC::Date.to_string()
# · LC::Date.to_string()
# · Lesli::Date.to_string()
# · Lesli::Date.to_string()
module LC

    class Date
 
        # set timezone and date formats here 
 
        # NOTE: Do not modify formats here,
        # if you need a different date format you should change it in the settings
        # Please read the TODO fole contained in this directory to see the current limitations of this class
        @default_settings = [
            {
                name: "time_zone",
                value: "Europe/Berlin"
            },{
                name: "date_format",
                value: "%Y.%m.%d"
            },{
                name: "date_format_full",
                value: "%a, %B %d, %Y"
            },{
                name: "date_format_time",
                value: "%Y.%m.%d %H:%M"
            },{
                name: "time_format",
                value: "%H:%M"
            }
        ]
        
        # @return [void]
        # @param account [Account] The account whose settings need to be reset
        # @description Resets the settings stored in @default_settings associated to the received account
        # @example
        #   Account.find(1).settings.find_by(name: "time_zone").update(value: "Guatemala")
        #   # -- Time zone at this point has not changed at all in LC::Date
        #   LC::Date.reset_db_settings(Account.find(1))
        #   # -- Time zone at this point has been refresed and updated to "Guatemala"
        def self.reset_db_settings(account)
            account_settings = {}
            db_settings = account.settings
 
            @default_settings.each do |default_setting|
                setting_value = default_setting[:value]
                db_setting = db_settings.find_by(name: default_setting[:name])
                if db_setting
                    setting_value = db_setting.value
                end
 
                account_settings[default_setting[:name].to_sym] = setting_value
            end
 
            @accounts_settings[account.id] = account_settings
        end
 
        # @return [Hash] The settings for this account. If one or more settings are not available in the database, default values are used
        # @param account [Account] The account whose settings need to be reset
        # @description Returns the settings associated to this account that are stored in memory. If there are not, it retrieves them from
        #   the databae keeps them in memory.
        # @example
        #   settings = LC::Date.get_settings(Account.find(1))
        #   puts settings.to_json # will display something like
        #   # {
        #   #      time_zome: "Europe/Berlin",
        #   #     date_format: "%Y.%m.%d",
        #   #     date_format_full: "%a, %B %d, %Y",
        #   #     date_format_time: "%Y.%m.%d %H:%M",
        #   #     time_format: "%H:%M"
        #   # }
        def self.get_settings(account)
            return @accounts_settings[account.id] if @accounts_settings[account.id]
 
            self.reset_db_settings(account)
 
            return @accounts_settings[account.id]
        end
 
        def self.to_string(account, datetime_object)
            settings = self.get_settings(account)
            
            zone = ActiveSupport::TimeZone.new(settings[:time_zone])
            datetime_object.in_time_zone(zone).strftime(settings[:date_format])
        end
 
        def self.to_string_datetime(account, datetime_object)
            settings = self.get_settings(account)
 
            zone = ActiveSupport::TimeZone.new(settings[:time_zone])
            datetime_object.in_time_zone(zone).strftime(settings[:date_format_time])
        end
 
        def self.to_string_datetime_words(account, datetime_object)
            settings = self.get_settings(account)
 
            zone = ActiveSupport::TimeZone.new(settings[:time_zone])
            datetime_object.in_time_zone(zone).strftime(settings[:date_format_full])
        end
 
        def self.to_string_time(account, datetime_object)
            settings = self.get_settings(account)
 
            zone = ActiveSupport::TimeZone.new(settings[:time_zone])
            datetime_object.in_time_zone(zone).strftime(settings[:time_format])
        end
 
        def self.today_at_midnight(account)
            settings = self.get_settings(account)
 
            zone = ActiveSupport::TimeZone.new(settings[:time_zone])
            return Time.current.in_time_zone(zone).beginning_of_day
        end
 
        def self.tomorrow_at_midnight(account)
            settings = self.get_settings(account)
 
            zone = ActiveSupport::TimeZone.new(settings[:time_zone])
            return Time.current.in_time_zone(zone).beginning_of_day + 1.day
        end
 
        def self.now(account)
            settings = self.get_settings(account)
            
            zone = ActiveSupport::TimeZone.new(settings[:time_zone])
            return Time.current.in_time_zone(zone)
        end
 
        def self.distance_to_words(account)
            settings = self.get_settings(account)
 
            zone = ActiveSupport::TimeZone.new(settings[:time_zone])
 
            time_from = time_from.in_time_zone(zone)
            time_to = time_to.in_time_zone(zone)
 
            distance_in_seconds = (time_to - time_from).round
            distance_in_minutes = (distance_in_seconds / 60.0).round
            distance_in_hours= (distance_in_minutes / 60.0).round
            distance_in_days = (distance_in_hours / 24.0).round
            distance_in_weeks = (distance_in_days / 7.0).round
            distance_in_months = (distance_in_days / 30).round
 
            # return distance in days
            return "#{distance_in_days} day ago" if distance_in_days == 1
            return "#{distance_in_days} days ago" if distance_in_days > 1
 
            # return distance in hours
            return "#{distance_in_hours} hour ago" if distance_in_hours == 1
            return "#{distance_in_hours} hours ago" if distance_in_hours > 1
 
            # return distance in minutes
            return "#{distance_in_minutes} minute ago" if distance_in_minutes == 1
            return "#{distance_in_minutes} minutes ago" if distance_in_minutes > 1
 
            # return distance in minutes
            return "#{distance_in_seconds} second ago" if distance_in_seconds == 1
            return "#{distance_in_seconds} seconds ago" if distance_in_seconds > 1
 
            # return generic distance
            return "some time ago"
 
        end
 
        def self.get_year_difference(account, from_time, to_time)
            settings = self.get_settings(account)
 
            # We set the same timezone for both Time variables
            zone = ActiveSupport::TimeZone.new(settings[:time_zone])
            from_time = from_time.in_time_zone(zone)
            to_time = to_time.in_time_zone(zone)
            
            # We extract years, months, and days
            from_year = from_time.year
            to_year = to_time.year
            from_month = from_time.month
            to_month = to_time.month
            from_day = from_time.day
            to_day = to_time.day
 
            year_difference = to_year - from_year
            if from_month > to_month
                return year_difference - 1
            end
 
            if from_month == to_month
                if from_day > to_day
                    return year_difference - 1
                end
            end
 
            return year_difference
        end
 
    end
 
 end
 