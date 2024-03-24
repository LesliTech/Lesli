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


// · 
import application from "Lesli/vue/public"


// · 
application({

    data() {
        return {
            loading: false,
            translations: {
                main: {}
            },
            sign_in: {
                email: "",
                password: ""
            },
            password_edit: {
                new_password: "",
                new_password_confirmation: ""
            },
            notification: {
                message: "",
                show: false,
                type: ""
            }
        }
    },
    methods: {

        postPasswordNew(event) {

            this.notification.show = false

            this.loading = true

            event.preventDefault();

            let data = {
                user: {
                    email: this.sign_in.email.toLowerCase(),
                    password: this.sign_in.password
                }
            };

            this.http.post("/password", data).then(response => {
                this.showNotification("this.translations.main.notification_reset_password_instructions_sent", "success")
            }).catch(error => {
                this.showNotification(error.message)
            }).finally(() => {
                this.loading = false
            })
        },

        putPasswordEdit(event) {

            this.notification.show = false

            this.loading = true

            event.preventDefault();

            // check if passwords match
            if (this.password_edit.new_password != this.password_edit.new_password_confirmation) {
                this.showNotification("this.translations.main.error_passwords_do_not_match", "danger")
                return
            }

            var token=null

            try {
                token = Object.fromEntries(new URLSearchParams(window.location.search)).reset_password_token
            } catch (error) {
                token=null
            }

            this.http.put("/password", {
                user: {
                    password: this.password_edit.new_password,
                    password_confirmation: this.password_edit.new_password_confirmation,
                    reset_password_token: token
                }
            }).then(response => {
                this.showNotification("this.translations.main.notification_password_updated", "success")
                //setTimeout(() => { this.url.go("/login") }, 2000)
            }).catch(error => {
                this.showNotification(error.message, "danger")
            }).finally(() => {
                this.loading = false
            })

        },

        showNotification(message, type="danger"){
            this.notification.message = message;
            this.notification.type = "is-"+type;
            this.notification.show = true;
        }

    }

})
