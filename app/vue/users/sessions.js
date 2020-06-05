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
        translation: I18n.t('core.users/sessions'),
        sign_in: {
            email: '',
            password: ''
        },
        progress_bar_active: false,
        notification: {
            message: '',
            show: false,
            type: 'is-danger'
        }
    },
    mounted() {
        this.build_redirect_url()
    },
    methods: {

        build_redirect_url() {

            let redirect_url= '/'

            try {
                redirect_url = Object.fromEntries(new URLSearchParams(window.location.search)).r
            } catch (error) {
                
            }

            if (!redirect_url) {
                redirect_url= "/" 
            }

            return redirect_url
             
        },

        postLogin(event) {

            event.preventDefault();

            this.notification.show = false

            let data = {user: this.sign_in};
            this.progress_bar_active = true;

            this.http.post(this.url.to("/login"), data).then(response => {

                this.progress_bar_active = false

                if(response.successful){
                    this.url.go(this.build_redirect_url())
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
