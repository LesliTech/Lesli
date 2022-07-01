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
                main: I18n.t("core.passes/new")
            },
            pass: {
                email: ""
            },
            notification: {
                message: "",
                show: false,
                type: "is-danger"
            }
        }
    },
    methods: {

        postPass(event) {

            event.preventDefault();

            this.http.post("/pass", this.pass).then(result => {
                console.log(result)
                if (result.successful) {
                    this.showNotification("If there is an account associated with this e-mail, your will shortly receive an e-mail with a Magic link for login.", "has-text-success")
                } else {
                    this.showNotification(result.error.message)
                }

            }).catch(error => {
                console.log(error)
            }).finally(() => {
                this.pass.email = ""
            })
        },

        showNotification(message, type="is-danger"){
            this.notification.message = message;
            this.notification.type = type;
            this.notification.show = true;
        }

    }

})
