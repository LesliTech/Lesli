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
import application from "Lesli/public"


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
            errors: ["holi"]
        }
    },
    mounted() {
        this.$refs?.email?.focus()
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
