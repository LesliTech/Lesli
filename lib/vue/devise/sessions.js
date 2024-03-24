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
import application from "Lesli/vue/public"


// · 
application({
    
    data(){
        return {
            loading: false,
            sign_in: {
                email: "",
                password: ""
            },
            notification: {
                message: "",
                show: false,
                type: "default"
            },
            errors: []
        }
    },
    mounted() {
        this.$refs?.email?.focus()

        if (lesli_application_development) {
            this.sign_in.email = "hello@lesli.tech"
            this.sign_in.password = "Tardis2024$"
        }
    },
    methods: {

        togglePasswordInput() {
            if (this.$refs.password.type === "password") {
                this.$refs.password.type = "text";
            } else {
                this.$refs.password.type = "password";
            }
        },

        validateEmail() {
            if (/^\w+([\.-]?\w+)*@\w+([\.-]?\w+)*(\.\w{2,3})+$/.test(this.sign_in.email)) {
                console.log("error")
            }
        },

        build_redirect_url(default_path = null) {

            // redirect to the root of the domain by default
            let redirect_url = "/"

            try {

                // search for a redirection route in the url params
                redirect_url = Object.fromEntries(new URLSearchParams(window.location.search)).r

            } catch (error) {   

            }

            // redirect to the default path if: 
            //      - there is no query params with redirection
            if (!redirect_url && default_path) {
                redirect_url = default_path   
            }
            
            // redirect to the root if: 
            //      - error parsing redirection route
            //      - there is no query params with redirection
            if (!redirect_url) {
                redirect_url = "/" 
            }

            return redirect_url
            
        },

        postLogin(event) {

            this.loading = true
            
            event.preventDefault();

            this.notification.show = false

            let data = {
                user: {
                    email: this.sign_in.email.toLowerCase(),
                    password: this.sign_in.password
                }
            };

            this.http.post("/login", data).then(response => {  
                this.url.go(this.build_redirect_url(response.default_path))
            }).catch(error => { 
                this.showNotification(error.message)
            }).finally(() => {
                this.loading = false
            })

        },

        typing() {
            this.notification.message= ""
            this.notification.show= false
            this.notification.type= "default"
        },

        showNotification(message, type="danger"){
            this.notification.message = message;
            this.notification.type = type;
            this.notification.show = true;
        }

    }
})
