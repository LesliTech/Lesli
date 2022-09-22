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
            main: I18n.t("core.invites")
        },
        invite: {
            email: "",
            telephone: "",
            full_name: "",
            note: ""
        },
        progress_bar_active: false,
        notification: {
            message: "",
            show: false,
            type: "is-danger"
        }
    },
    methods: {

        postInvite(event) {

            event.preventDefault();

            this.progress_bar_active = true;

            this.http.post("/invite.json", {
                invite: this.invite
            }).then(result => {

                this.progress_bar_active = false

                if (!result.successful) {
                    this.showNotification(result.error.message)
                }

                this.showNotification("Invitation request sent", "is-success")

            }).catch(error => {
                console.log(error)
            }).finally(() => {
                this.invite.email= ""
                this.invite.telephone= ""
                this.invite.full_name= ""
                this.invite.note= ""
            })
        },

        showNotification(message, type="is-danger"){
            this.notification.message = message;
            this.notification.type = type;
            this.notification.show = true;
        }

    }

})
