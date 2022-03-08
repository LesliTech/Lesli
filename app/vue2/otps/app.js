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
import componentNotificationMessageSimple from "LesliCoreVue/components/notifications/message-simple.vue" 
import componentNotificationProgressBar from "LesliCoreVue/components/notifications/progress-bar.vue" 


// · 
app({
    components: {
        "component-notification-message-simple": componentNotificationMessageSimple,
        "component-notification-progress-bar": componentNotificationProgressBar
    },
    data: {
        translations: {
            main: I18n.t("core.otps/show")
        },
        otp: {
            email: ""
        },
        validate_otp: false,
        progress_bar_active: false,
        notification: {
            message: "",
            show: false,
            type: "is-danger"
        }
    },
    mounted() {
        this.validate_otp = false
    },
    methods: {

        postOtp(event) {

            event.preventDefault();

            this.progress_bar_active = true;

            this.http.post("/otp", this.otp).then(result => {

                this.progress_bar_active = false

                if (result.successful) {
                    this.validate_otp = true
                    this.showNotification(this.translations.main.notification_reset_password_instructions_sent, "is-success")
                } else {
                    this.validate_otp = false
                    this.showNotification(result.error.message)
                }

            }).catch(error => {
                console.log(error)
            })
        },

        showNotification(message, type="is-danger"){
            this.notification.message = message;
            this.notification.type = type;
            this.notification.show = true;
        }

    }

})
