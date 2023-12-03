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
import application from "Lesli/public"


// · 
application({

    data(){
        return {
            translations: {},
            password_uppercase: 0,
            password_symbol: 0,
            password_number: 0,
            telephone_code: "+49",
            telephone_codes: null,
            sign_up: {
                email: "",
                password: "",
                password_confirmation: '',
                // first_name: null,
                // last_name: null,
                // telephone: null,
            },
            progress_bar_active: false,
            notification: {
                show: false,
                message: '',
                type: 'is-danger'
            }
            
        }
    },
    mounted() {
        this.$refs.email.focus()
    },
    methods: {

        /**
         * @param {*} event that triggers the function
         * @description this function is triggered when the user submits the form to sign up
         */
        postRegistration(event) {

            this.notification.show = false;

            event.preventDefault();

            const user = this.validateFields()

            this.http.post(this.url.to(), user).then(response => {

                //setTimeout(() => { this.url.go("/login") }, 5000)
                
            }).catch((err)=>{
                this.showNotification(err.message)
            })

        },

        typing() {
            this.notification.message= ""
            this.notification.show= false
            this.notification.type= "default"
            this.verifyPasswords()
        },

        showNotification(message,type = "danger") {
            this.notification.message = message
            this.notification.type = type
            this.notification.show = true
        },

        /**
         * @description validates the password strength
         */
        verifyPasswords() {

            this.password_uppercase = 0
            this.password_number = 0
            this.password_symbol = 0
            
            if (this.sign_up.password.length <= 0) {
                return
            }

            if (this.sign_up.password.search(/[A-Z]/) < 0) {
                this.password_uppercase = 1
            } else {
                this.password_uppercase = 2
            }

            if (this.sign_up.password.search(/[0-9]/) < 0) {
                this.password_number = 1
            } else {
                this.password_number = 2
            }

            if (this.sign_up.password.search(/[!#$%&]/) < 0) {
                this.password_symbol = 1
            } else {
                this.password_symbol = 2
            }

        },

        /**
         * @description this function validates if the fields are correct
         * @returns object with the user to be registered
         */
        validateFields() {
            
            // · copy object without reference
            const user = JSON.parse(JSON.stringify(this.sign_up))

            if (user.password_confirmation == "") {
                user.password_confirmation = user.password
            }


            return user
        }

    }
})
