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
                    console.log(error)
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
