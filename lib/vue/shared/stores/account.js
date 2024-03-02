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

Lesli · Ruby on Rails SaaS Development Framework.

Made with ♥ by https://www.lesli.tech
Building a better future, one line of code at a time.

@contact  hello@lesli.tech
@website  https://www.lesli.tech
@license  GPLv3 http://www.gnu.org/licenses/gpl-3.0.en.html

// · ~·~     ~·~     ~·~     ~·~     ~·~     ~·~     ~·~     ~·~     ~·~
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

        update() {
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
