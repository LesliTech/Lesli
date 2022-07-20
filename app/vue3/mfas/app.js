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
import app from "LesliVue/public"


// · 
app({
    data() {
        return {
            translations: {
                main: I18n.t("core.otps/show")
            },
            mfa: {
                t: ""
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

        putMfa(event) {

            event.preventDefault();

            this.http.put("/mfa", this.mfa).then(result => {
                this.url.go(result.default_path)
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
