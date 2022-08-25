/*
Copyright (c) 2022, all rights reserved.

All the information provided by this platform is protected by international laws related  to 
industrial property, intellectual property, copyright and relative international laws. 
All intellectual or industrial property rights of the code, texts, trade mark, design, 
pictures and any other information belongs to the owner of this platform.

Without the written permission of the owner, any replication, modification,
transmission, publication is strictly forbidden.

For more information read the license file including with this software.

// · ~·~     ~·~     ~·~     ~·~     ~·~     ~·~     ~·~     ~·~     ~·~     ~·~     ~·~     ~·~
// · 
*/

// ·
import { defineStore } from "pinia";

// ·
export const useAccountSettings = defineStore("account_settings", {
    state: () => {
        return {
            view: 0,
            submitting_form : false,
            settings: {
                datetime_format_date: null,
                datetime_format_time: null,
                datetime_format_date_words: null,
                datetime_format_date_time: null,
                datetime_format_date_time_words: null,
                datetime_time_zone: null,
                password_enforce_complexity: null,
                password_minimum_length: null,
                password_expiration_time_days: null,
                password_special_char_count: null,
                password_uppercase_count: null,
                password_lowercase_count: null,
                password_digit_count: null,
                lesli_theme_color_primary: null,
                lesli_theme_color_secondary: null,
                lesli_theme_color_header: null,
                lesli_theme_color_sidebar: null,
                lesli_theme_color_background: null,
                lesli_theme_font_color: null,
                lesli_theme_font_size: null
            },
            old_settings: {
                lesli_theme_color_primary: null,
                lesli_theme_color_secondary: null,
                lesli_theme_color_header: null,
                lesli_theme_color_sidebar: null,
                lesli_theme_color_background: null,
                lesli_theme_font_color: null,
                lesli_theme_font_size: null
            },
            translations: {
                core: {
                    shared:  I18n.t("core.shared"),
                    account_settings: I18n.t("core.account/settings"),
                    account: {
                        settings: I18n.t("core.account/settings"),
                        files: I18n.t('core.account/files')
                    } 
                },
            },
            options: {
                time_zones: []
            }
        }
    },
    actions: {

        /**
         * @description This action is used to fetch the list of options for time zone.
         */
        getOptions (){
            this.loading = true
            this.http.get(this.url.admin("account/options")).then(result => {
                this.options.time_zones = result.time_zones.map((time_zone)=> {
                    return {
                        label: time_zone.text,
                        value: time_zone.value
                    }
                } )
            }).catch(error => {
                console.log(error)
                this.msg.danger(this.translations.core.shared.messages_danger_internal_error)
            }).finally(() => {
                this.loading = false
            })
        },

        /**
         * @description This action is used to post the selected settings
         */
        postSettings() {
            this.submitting_form = true
            this.http.post(this.url.admin("account/settings"), {
                settings: this.settings
            }).then(result => {
                this.msg.success(this.translations.core.account.settings.messages_success_settings_saved_successfully)
            }).catch(error => {
                console.log(error)
                this.msg.danger(this.translations.core.shared.messages_danger_internal_error)
            }).finally(() => {
                this.submitting_form = false
            })
        },

        /**
         * @description This action is used to fetch the currently configured settings
         */
        getSettings (){
            this.http.get(this.url.admin("account/settings")).then(result => {
                this.parseSettings(result)
            }).catch(error => {
                console.log(error)
                this.msg.danger(this.translations.core.shared.messages_danger_internal_error)
            })
        },
        
        /**
         * @description This action is used to parse the settings fetched
         * @param {Object} settings_raw The records fetched from settings
         */
        parseSettings(settings_raw){
            settings_raw.forEach(setting_raw => {
                if (setting_raw.name in this.settings){
                    this.settings[setting_raw.name] = setting_raw.value
                    this.old_settings[setting_raw.name] = setting_raw.value
                }
            })
        },

        /**
         * @description This action is used to replace the new settings with the old settings
         * @param {Object} setting_name The setting that is going to be replaced
         */
        clearSetting(setting_name){
            this.settings[setting_name] = this.old_settings[setting_name]
        }

    },
});
