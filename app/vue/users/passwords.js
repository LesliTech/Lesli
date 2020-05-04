/*
Lesli

Copyright (c) 2020, Lesli Technologies, S. A.

All the information provided by this website is protected by laws of Guatemala related 
to industrial property, intellectual property, copyright and relative international laws. 
Lesli Technologies, S. A. is the exclusive owner of all intellectual or industrial property
rights of the code, texts, trade mark, design, pictures and any other information.
Without the written permission of Lesli Technologies, S. A., any replication, modification,
transmission, publication is strictly forbidden.
For more information read the license file including with this software.

LesliCloud - Your Smart Business Assistant

Powered by https://www.lesli.tech
Building a better future, one line of code at a time.

@license  Propietary - all rights reserved.
@version  0.1.0-alpha

// · ~·~     ~·~     ~·~     ~·~     ~·~     ~·~     ~·~     ~·~     ~·~     ~·~     ~·~     ~·~
// · 
*/


// · 
import app from 'LesliCoreVue/public'

import componentNotificationMessageSimple from 'LesliCoreVue/components/notifications/message-simple.vue' 
import componentNotificationProgressBar from 'LesliCoreVue/components/notifications/progress-bar.vue' 

app({

    components: {
        'component-notification-message-simple': componentNotificationMessageSimple,
        'component-notification-progress-bar': componentNotificationProgressBar
    },
    data: {
        translations: {
            main: I18n.t('core.users/passwords')
        },
        sign_in: {
            email: '',
            password: ''
        },
        password_edit: {
            new_password: "",
            new_password_confirmation: ""
        },
        progress_bar_active: false,
        notification: {
            message: '',
            show: false,
            type: 'is-danger'
        }
    },
    methods: {

        postPasswordNew(event) {

            event.preventDefault();

            let data = {user: this.sign_in};
            this.progress_bar_active = true;

            this.http.post("/password", data).then(response => {

                this.progress_bar_active = false

                if(response.successful){
                    //this.url.go('/')
                }else{
                    this.showNotification(response.error.message)
                }

            }).catch(error => {
                console.log(error)
            })
        },

        putPasswordEdit(event) {
            event.preventDefault();

            // check if passwords match
            if (this.password_edit.new_password != this.password_edit.new_password_confirmation) {
                this.showNotification(this.translations.main.error_passwords_do_not_match, 'is-warning')
                return
            }

            var token=null

            try {
                token = Object.fromEntries(new URLSearchParams(window.location.search)).reset_password_token
            } catch (error) {
                token=null
            }

            this.progress_bar_active = true;

            this.http.put("/password", {
                user: {
                    reset_password_token: token,
                    password: this.password_edit.new_password,
                    password_confirmation: this.password_edit.new_password_confirmation
                }
            }).then(response => {

                this.progress_bar_active = false

                if(response.successful){
                    this.showNotification(this.translations.main.notification_password_updated, "is-success")
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

        showNotification(message, type='is-danger'){
            this.notification.message = message;
            this.notification.type = type;
            this.notification.show = true;
        }

    }

})
