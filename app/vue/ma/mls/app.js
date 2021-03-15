/*
Copyright (c) 2021, all rights reserved.
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


app({
    data: {
        magic_link: {
            email: "",
        },
        notification: {
            message: "",
            show: false,
            type: "default"
        }
    },
    mounted() {
    },
    methods: {
        postSendMagicLink(event){
            event.preventDefault();
            this.notification.show = false

            let data = {
                user: {
                    email: this.magic_link.email.toLowerCase(),
                }
            };

            this.http.post(this.url.to("/ma/mls.json"), data).then(response => {
                this.showNotification(response.data.message, "is-success")
            }).catch(error => {
                this.showNotification("Error")
            })
        },

        showNotification(message, type="danger"){
            this.notification.message = message;
            this.notification.type = type;
            this.notification.show = true;
        }
    }

})

