/*
Copyright (c) 2020, all rights reserved.

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
import app from "LesliVue/public"

// · 
import componentNotificationMessageSimple from "LesliVue/components/notifications/message-simple.vue" 
import componentNotificationProgressBar from "LesliVue/components/notifications/progress-bar.vue" 


// · 
app({

    components: {
        "component-notification-message-simple": componentNotificationMessageSimple,
        "component-notification-progress-bar": componentNotificationProgressBar
    },
    data: {
        translation: I18n.t("core.users/sessions"),
        sign_in: {
            email: "",
            password: "",
            mfa_code: ""
        },
        progress_bar_active: false,
        notification: {
            message: "",
            show: false,
            type: "default"
        }
    },
    mounted() {
        this.build_redirect_url()
    },
    methods: {

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

            event.preventDefault();

            this.notification.show = false

            let data = {
                user: {
                    email: this.sign_in.email.toLowerCase(),
                    password: this.sign_in.password
                }
            };
            
            this.progress_bar_active = true;

            this.http.post(this.url.to("/login"), data).then(response => {

                this.progress_bar_active = false

                // If login went successful, redirect to root
                if (response.successful){
                    this.url.go(this.build_redirect_url(response.data.default_path))
                    return
                }

                // If login fail due password expired, redirect to public password update
                if (!response.successful && response.error.details.reset_password_token) {
                    this.url.go(`/password/edit?reset_password_token=${response.error.details.reset_password_token}`)
                }

                this.showNotification(response.error.message)

            }).catch(error => {
                this.showNotification("Error")
            })
            
        },

        postLoginWithMFA(){
            let key = (new URLSearchParams(window.location.search)).get("key")

            if(!key){
                this.showNotification("Error")
                return
            }

            let endpoint = this.url.to(`/login?key=${key}`)
            let data = { user: { mfa_code: this.sign_in.mfa_code } }

            this.http.post(endpoint, data).then(response => {
                console.log(response)
                if(!response.successful){
                    this.showNotification(response.error.message)
                    return
                }

                this.url.go(this.build_redirect_url(response.data.default_path))

            }).catch(error => {
                this.showNotification("Error")
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
