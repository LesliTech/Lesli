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
                main: I18n.t("core.users/passwords")
            },
            sign_in: {
                email: "",
                password: ""
            },
            password_edit: {
                new_password: "",
                new_password_confirmation: ""
            },
            notification: {
                message: "",
                show: false,
                type: "danger"
            }
        }
    },
    methods: {

        postPasswordNew(event) {

            event.preventDefault();

            let data = {
                user: {
                    email: this.sign_in.email.toLowerCase(),
                    password: this.sign_in.password
                }
            };

            this.http.post("/password", data).then(response => {

                if(response.successful){
                    this.showNotification(this.translations.main.notification_reset_password_instructions_sent, "has-text-success")
                }else{
                    this.showNotification(response.error.message, "has-text-danger")
                }

            }).catch(error => {
                console.log(error)
            })
        },

        putPasswordEdit(event) {
            event.preventDefault();

            // check if passwords match
            if (this.password_edit.new_password != this.password_edit.new_password_confirmation) {
                this.showNotification(this.translations.main.error_passwords_do_not_match, "warning")
                return
            }

            var token=null

            try {
                token = Object.fromEntries(new URLSearchParams(window.location.search)).reset_password_token
            } catch (error) {
                token=null
            }

            this.http.put("/password", {
                user: {
                    password: this.password_edit.new_password,
                    password_confirmation: this.password_edit.new_password_confirmation,
                    reset_password_token: token
                }
            }).then(response => {

                if(response.successful){
                    this.showNotification(this.translations.main.notification_password_updated, "success")
                    setTimeout(() => {
                        this.url.go("/login")
                    }, 1500)
                }else{
                    this.showNotification(response.error.message)
                }

            }).catch(error => {
                console.log(error)
            })
        },

        showNotification(message, type="danger"){
            this.notification.message = message;
            this.notification.type = type;
            this.notification.show = true;
        }

    }

})
