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
    data(){
        return {
            translations: {},
            sign_up: {
                email: '',
                password: '',
                password_confirmation: ''
            },
            progress_bar_active: false,
            notification: {
                show: false,
                message: '',
                type: 'is-danger'
            }
        }
    },
    methods: {

        postRegistration(event) {

            this.notification.show = false;

            event.preventDefault();

            let data = { user: this.sign_up }

            this.http.post(this.url.to(), data).then(response => {

                if (!response.successful) {
                    this.showNotification(response.error.message)
                    return 
                }

                //this.showNotification(this.translations.registration.notifications.success, 'is-success')
                this.showNotification("We sent an confirmation email, please confirm your email address", "is-success")

                setTimeout(() => { this.url.go("/login") }, 5000)

            }).catch((err)=>{
                console.log(err)
            })

        },

        typing() {
            this.notification.message= ""
            this.notification.show= false
            this.notification.type= "default"
        },

        showNotification(message,type = "is-danger") {
            this.notification.message = message;
            this.notification.type = type;
            this.notification.show = true;
        },

        verifyPasswords() {

            let password = this.sign_up.password

            let password_confirmation = this.sign_up.password_confirmation

            if (password && password_confirmation) {
                if (password !== password_confirmation) {
                    this.showNotification(this.translations.shared.errors.unmatched_passwords)
                    return
                }
            }

            this.notification.show = false

        }

    }

})
