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

Lesli · Ruby on Rails Development Platform.

Made with ♥ by https://www.lesli.tech
Building a better future, one line of code at a time.

@contact  hello@lesli.tech
@website  https://www.lesli.tech
@license  GPLv3 http://www.gnu.org/licenses/gpl-3.0.en.html

// · ~·~     ~·~     ~·~     ~·~     ~·~     ~·~     ~·~     ~·~     ~·~     ~·~     ~·~     ~·~
// · 
*/


// · 
import { defineStore } from "pinia"


// · 
export const useIntegration = defineStore("administration.integration", {
    state: () => {
        return {
            token: "",
            records: [],
            pagination: {},
            integration: {
                name: ""
            }
        }
    },
    actions: {

        fetch() {
            this.http.get(this.url.admin("account/integrations")).then(result => {
                this.pagination = result.pagination
                this.records = result.records.map(integrations => {
                    integrations.created_at = this.date.dateTime(integrations.created_at)
                    return integrations
                })
            })
        },

        post() {

            if (this.integration.name == "") {
                return 
            }

            this.http.post(this.url.admin("account/integrations"), {
                account_integration: this.integration
            }).then(result => {
                this.integration.name = ""
                this.token = result
            })
        },
        /**
         * @description This action is used to delete an integration
         */
        deleteIntegration(integration_id){
            this.dialog.confirmation({
                title: "Delete integration",
                text: 'Are you sure you want to delete this integration?',
                confirmText: "Yes",
                cancelText: "No"
            })
            .then(({ isConfirmed }) => {
                if (isConfirmed) {
                    this.http.delete(this.url.admin("account/integrations/:id", { id: integration_id})).then(result => {
                        // delete user associated with integration
                        this.http.delete(this.url.admin("/users/:user_id", {
                            user_id: result.users_id
                        })).then(result => {
                            this.msg.success(I18n.t("core.users.messages_success_operation"))
                        }).catch(error => {
                            this.msg.danger(I18n.t("core.shared.messages_danger_internal_error"))                        
                        })
                    }).catch(error => {
                        this.msg.danger(I18n.t("core.shared.messages_danger_internal_error"))
                    })
                    this.fetch()
                }
            })
        }
    }
})
