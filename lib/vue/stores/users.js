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
export const useUsers = defineStore("lesli.users", {
    state: () => {
        return {
            list: []
        }
    },
    actions: {

        getUsersList() {
            this.http.get(this.url.lesli("users/list")).then(result => {
                this.list = result
            }).catch(error => {
                this.msg.danger(I18n.t("core.shared.messages_danger_internal_error"))
            })
        }
    }
})


/*
updatePassword() {
    this.http.put("/", {
        user: {
            password: this.user.password,
            password_confirmation: this.user.password_confirmation
        }
    }).then(result => {
        this.msg.success(I18n.t("core.users.messages_success_operation"))
        this.user.password = ""
        this.user.password_confirmation = ""
    }).catch(error => {
        this.msg.danger(I18n.t("core.shared.messages_danger_internal_error"))
    })
},

//  This action is used to change the user status active or inactive
putUserStatus(){
    this.dialog.confirmation({
        title: "Change status",
        text: "Are you sure you want to change the status of this user?",
        confirmText: "Yes",
        cancelText: "No"
    })
    .then(({ isConfirmed }) => {
        if (isConfirmed) {
            this.http.patch(this.url.lesli('users/:id', this.user.id), {
                user: {
                    active: this.user.active
                }
            }).then(result => {
                this.msg.success(I18n.t("core.users.messages_success_operation"))
            }) .catch(error => {
                this.msg.danger(I18n.t("core.shared.messages_danger_internal_error"))                        
            })
        } else {
            this.user.active = !this.user.active
        }
    })
},

*/
