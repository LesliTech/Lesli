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

Lesli - Your Smart Business Assistant

Powered by https://www.lesli.tech
Building a better future, one line of code at a time.

@contact  <hello@lesli.tech>
@website  <https://lesli.tech>
@license  Propietary - all rights reserved.

// · ~·~     ~·~     ~·~     ~·~     ~·~     ~·~     ~·~     ~·~     ~·~     ~·~     ~·~     ~·~
// · 
*/


// · 
import app from 'LesliCoreVue/public'


// · import core components
// · ~·~     ~·~     ~·~     ~·~     ~·~     ~·~     ~·~     ~·~     ~·~     ~·~     ~·~     ~·~
import componentNotificationMessageSimple from 'LesliCoreVue/components/notifications/message-simple.vue' 
import componentNotificationProgressBar from 'LesliCoreVue/components/notifications/progress-bar.vue' 


// · 
app({

    components: {
        'component-notification-message-simple': componentNotificationMessageSimple,
        'component-notification-progress-bar': componentNotificationProgressBar
    },
    data: {
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
    },
    methods: {

        postRegistration(event) {
            event.preventDefault();

            let data = { user: this.sign_up }

            this.progress_bar_active = true

            this.http.post(this.url.to(), data).then(response => {

                this.progress_bar_active = false

                if (response.successful) {
                    this.showNotification(this.translations.registration.notifications.success,'is-success')
                    setTimeout(() => {
                        this.$router.push('/login')
                    }, 5000)
                }else{
                    this.showNotification(response.error.message);
                }

            }).catch((err)=>{
                console.log(err)
            })

        },

        showNotification(message,type='is-danger') {
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
