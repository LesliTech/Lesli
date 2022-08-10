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
                core: {
                    invites: "We receive your invitation request."
                }
            },
            loading: false,
            invite: {
                email: ""
            },
            notification: {
                type: "is-success",
                message: ""
            }
        }
    },
    methods: {
        postInvite(e) {

            this.loading = true
            e.preventDefault()

            this.http.post("invite.json", {
                invite: this.invite
            }).then(result => {
                this.notification.message = this.translations.core.invites
            }).catch(error => {
                console.log("error: ", error)
            }).finally(() => {
                this.loading = false
                this.invite = {}
            })

        }
    }
})