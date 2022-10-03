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
export const useAccount = defineStore("account", {
    state: () => {
        return {
            accountInfo: {},
            options: {
                countries: [],
                regions: [],
                time_zones: []
            }
        }
    },
    actions: {
        /**
         * @description This action is used to fetch the list of options for time zone.
         */
        fetch (){
            this.loading = true
            this.http.get(this.url.admin("account")).then(result => {
                this.accountInfo = result
                delete this.accountInfo.created_at
                delete this.accountInfo.updated_at
                delete this.accountInfo.phone_number_2
                delete this.accountInfo.phone_number_3
                delete this.accountInfo.phone_number_4
            }).catch(error => {
                this.msg.danger(I18n.t("core.shared.messages_danger_internal_error")) 
            }).finally(() => {
                this.loading = false
            })
        },

        /**
         * @description This action is used to post the selected settings
         */
        updateInfo() {
            this.submitting_form = true
            this.http.patch(this.url.admin("account"), {
                account: this.accountInfo
            }).then(result => {
                this.msg.success(I18n.t("core.users.messages_success_operation"))
            }).catch(error => {
                this.msg.danger(I18n.t("core.shared.messages_danger_internal_error")) 
            }).finally(() => {
                this.fetch()
            })
        },
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
        }

    },
});
