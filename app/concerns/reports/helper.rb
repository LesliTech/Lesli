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
module Reports
    module Helper
        extend ActiveSupport::Concern

        included do

            # @return [String] the new filename of the report in localized language
            # @param filename [String] the name of the translation that contains the name of the report
            # @param translation_path [String] The scope that indicates where to find the translation
            # @description Translates the filename of the report to a localized language. If it exceeds 31 characters
            #     a default name is used instead
            # @example
            #     # Imagine this helper is already installed and locale is en
            #     puts translate_file_name("view_text_filename_tickets_general", "help.reports")
            #     # this will return something line "General Report for Tickets"
            def self.translate_file_name(filename, translation_path)
                translation = I18n.t(filename, scope: translation_path)
                if (translation.size > 31 || !(translation.present?))
                    return "report"
                else
                    return translation
                end
            end

            # @return [String] the new sheetname of the report in localized language
            # @param sheetname [String] the name of the translation that contains the name of the report
            # @param translation_path [String] The scope that indicates where to find the translation
            # @description Translates the sheetname of the report to a localized language. If it exceeds 31 characters
            #     a default name is used instead
            # @example
            #     # Imagine this helper is already installed and locale is en
            #     puts translate_file_name("view_text_sheetname_tickets_general", "help.reports")
            def self.translate_sheet_name(sheetname, translation_path)
                translation = I18n.t(sheetname, scope: translation_path)
                if (translation.size > 31 || !(translation.present?))
                    return "sheet"
                else
                    return translation
                end
            end

            # @return [String] The translated value of the enum
            # @param enum_name [String] The name of the enum
            # @param value [String] The specific value of the enum
            # @param translation_path [String] The scope that indicates where to find the translation
            # @param prefix [String] The prefix usted to design enum translations. If the standard is followed, it should be
            #     'column_enum_'
            # @descriptions Translates the value of an enum to a localized language
            # @example
            #     puts translate_enum('ticket_type', 'bug', 'help.catalog/ticket_types')
            #     # This will print something like Error in spanish
            def self.translate_enum(enum_name, value, translation_path, prefix = "column_enum_")
                return value if value.blank?

                new_value = I18n.t("#{translation_path}.#{prefix}#{enum_name}_#{value}", default: value)

                unless (new_value.blank?)
                    return new_value
                end
            end

            # @return [String] The translated value of the status
            # @param value [String] The specific value of the status
            # @param prefix [String] The prefix usted to design enum translations. If the standard is followed, it should be
            #     'column_enum_status_'
            # @param translation_path [String] The scope that indicates where to find the translation
            # @descriptions Translates the value of a status to a localized language. This is only in case the statuses
            #     are the default values created with the default workflow: "created" and "closed". Otherwise, the 
            #     value of the status will be the one given by the user
            # @example
            #     puts translate_status('created') # This will print something like 'Creado' in spanish
            #     puts translate_status('My custom Status') # This will print 'My custom Status' in any language
            def self.translate_status(value, prefix = "column_enum_status_", translation_path = "core.shared")
                return value if value.blank?

                new_value = I18n.t("#{translation_path}.#{prefix}#{value}", default: value)

                return new_value
            end

            # @return [String] The translated value of the translate_boolean
            # @param value [Boolean] The boolean to be translated
            # @descriptions Translates the value of a boolean to a human readable text based on the selected locale
            # @example
            #     translate_boolean(true) # This will display 'Yes' in english
            #     translate_boolean(false) # This will display 'No' in english
            def self.translate_boolean(value)
                if (value)
                    I18n.t("view_text_yes", scope: "core.shared")
                else
                    I18n.t("view_text_no", scope: "core.shared")
                end
            end

            # @return [Float] The result of a safe division between 2 variables than may or may not be numbers
            # @param num [Float] The numerator
            # @param den [Float] The denominator
            # @param round [Integer] Optional, the number of decimals you want to round the result to. It defauls to 2
            # @description Performs a safe division using 2 variables, only if they are numbers. Otherwise, it returns 0
            # @example
            #     puts safe_divide(1, 3) # This will display 0.33
            #     puts safe_divide('', nil) # This will display 0
            def self.safe_divide(num, den, round = 2)

                return 0 if not num

                return 0 if not den

                return 0 if den == 0

                return (num/den).to_f.round(round)
            end

            # @return [String] A date format based on the account settings but specifically for excel
            # @descriptions Takes the lesli settings and returns a xlsx date format based on the configuration one
            # @example
            #     # Imagine the date format in the lesli settingds is %d.%m.%Y
            #     puts date_format
            #     # This will display dd\mm\yyyy
            def self.date_format
                date_format = Rails.application.config.lesli.dig(:configuration, :datetime, :date_format)

                unless date_format.blank?
                    date_format = date_format.gsub("%Y", "yyyy")
                    date_format = date_format.gsub("%m", "mm\\")
                    date_format = date_format.gsub("%d", "dd\\")
                end

                date_format
            end

            # @return [String] A datetime format based on the account settings but specifically for excel
            # @descriptions Takes the lesli settings and returns a xlsx date format based on the configuration one
            # @example
            #     # Imagine the datetime format in the lesli settingds is %d.%m.%Y %H:%M
            #     puts datetime_format
            #     # This will display dd\mm\yyyy hh:mm
            def self.datetime_format
                date_format = Rails.application.config.lesli.dig(:configuration, :datetime, :date_format_time)

                unless date_format.blank?
                    date_format = date_format.gsub("%Y", "yyyy")
                    date_format = date_format.gsub("%m", "mm\\")
                    date_format = date_format.gsub("%d", "dd\\")
                    date_format = date_format.gsub("%H", "hh")
                    date_format = date_format.gsub("%M", "mm")
                end

                date_format
            end
        end
    end
end
