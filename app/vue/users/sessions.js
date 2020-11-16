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
            password: ""
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

        build_redirect_url() {

            let redirect_url= "/"

            try {
                redirect_url = Object.fromEntries(new URLSearchParams(window.location.search)).r
            } catch (error) {
                
            }

            if (!redirect_url) {
                redirect_url= "/" 
            }

            return redirect_url
             
        },

        postLogin(event) {

            event.preventDefault();

            this.notification.show = false

            let data = {user: this.sign_in};
            this.progress_bar_active = true;

            this.http.post(this.url.to("/login"), data).then(response => {

                this.progress_bar_active = false

                // If login went successful, redirect to root
                if (response.successful){
                    this.url.go(this.build_redirect_url())
                    return
                }

                // If login fail due password expired, redirect to public password update
                if (!response.successful && response.error.details.reset_password_token) {
                    this.url.go(`/password/edit?reset_password_token=${response.error.details.reset_password_token}`)
                }

                this.showNotification(response.error.message)

            }).catch(error => {
                console.log(error)
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
