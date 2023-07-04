/*
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
*/


// · 
import { defineStore } from "pinia";

// ·
export const useOnboarding = defineStore("onboarding", {
    state: () => {
        return {
            view: 0,
            companyInfo: {
                company_name: null,
                company_name_legal: null,
                company_tag_line: null,
                address: null,
                country: null,
                region: null,
                public_email: null,
                phone_number_1: null,
                github: null,
                twitter: null,
                youtube: null,
                linkedin: null,
                facebook: null,
                city: null,
                postal_code: null
            },
            settings: {
                datetime_format_date: null,
                datetime_format_time: null,
                datetime_format_date_words: null,
                datetime_format_date_time: null,
                datetime_format_date_time_words: null,
                datetime_time_zone: null,

            },
            translations: {
                core: {
                    onboardings: I18n.t("core.onboardings"),
                    shared:  I18n.t("core.shared"),
                    account_settings: I18n.t("core.account/settings")   
                },
            },
            options: {
                countries: [],
                regions: [],
                time_zones: []
            }
        }
    },
    actions: {
        // Function to handle when the user clicks on continue while completing the onboarding process
        next() {
            this.view++
        },
        back(){
            this.view = 1
        },
        // Function to handle when the user skip onboarding process
        skip() {
            this.dialog
                .confirmation({
                    title: this.translations.core.onboardings.view_text_skip_onboarding_body,
                    text: this.translations.core.onboardings.view_text_skip_onboarding_info,
                    confirmText: this.translations.core.onboardings.view_text_skip_process,
                    cancelText: this.translations.core.onboardings.view_btn_continue
                })
                .then(({ isConfirmed }) => {
                    if (isConfirmed) {
                        this.saveConfiguration(true)
                    }
                })
        },
        // Get options for showing in lesli select component for regions and countries
        getOptions (){
            this.loading = true
            this.http.get(this.url.admin("account/options")).then(result => {
                this.options.countries = result.countries.map((country)=> {
                    return {
                        label: country.name,
                        value: country.id
                    }
                } )
                this.options.regions = result.regions.map((region)=> {
                    return {
                        label: region.value,
                        value: region.key
                    }
                } )
            }).catch(error => {
                this.msg.danger(this.translations.core.shared.messages_danger_internal_error)
            }).finally(() => {
                this.loading = false
            })
            // Get options for time zone selection
            this.http.get(this.url.admin("account/settings/options")).then(result => {
                this.options.time_zones = result.time_zones.map((time_zone)=> {
                    return {
                        label: time_zone.text,
                        value: time_zone.value
                    }
                } )
            }).catch(error => {
                this.msg.danger(this.translations.core.shared.messages_danger_internal_error)
            })
        },
        // Save configuration from onboarding
        saveConfiguration(skipped = false) {
            if (skipped) {
                this.msg.info(this.translations.core.onboardings.messages_info_onboarding_process_skipped)
                this.http.post(this.url.root("onboarding"), {
                    account: {
                        status: 2
                    },
                    account_settings: this.settings 
                }).then(result => {
                    this.msg.success(this.translations.core.account_settings.messages_success_settings_saved_successfully)
                    this.url.go()
                }).catch(error => {
                    this.msg.danger(this.translations.core.shared.messages_danger_internal_error)
                })
            } else {
                this.http.post(this.url.root("onboarding"), {
                    account: this.companyInfo,
                    account_settings: this.settings 
                }).then(result => {
                        this.msg.success(this.translations.core.account_settings.messages_success_settings_saved_successfully)
                        this.url.go()
                }).catch(error => {
                    this.msg.danger(this.translations.core.shared.messages_danger_internal_error)
                })
            }
        },
    },
});
