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
import application from "Lesli/public"


// · 
application({

    data() {
        return {
            translations: {
                main: I18n.t("core.otps/show")
            },
            otp: {
                t: "",
                email: ""
            },
            validate_otp: false,
            notification: {
                message: "",
                show: false,
                type: "is-danger"
            }
        }
    },
    methods: {

        // Request OTP
        postOtp(e) {
            this.otp.t=""
            e.preventDefault();
            this.http.post("/otp", this.otp).then(result => {
                this.validate_otp = true
                this.showNotification(this.translations.main.notification_reset_password_instructions_sent, "is-success")
            }).catch(error => {
                this.showNotification(error.message)
            })
        },

        // Validate OTP
        putOtp(e) {
            this.otp.email=""
            e.preventDefault();
            this.http.put("/otp", this.otp).then(result => {
                this.url.go(result.default_path)
            }).catch(error => {
                this.showNotification(error.message)
            })
        },

        showNotification(message, type="is-danger"){
            this.notification.message = message;
            this.notification.type = type;
            this.notification.show = true;
        }

    }

})
