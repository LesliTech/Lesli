
import app from 'LesliCoreVue/public'

import componentNotificationMessageSimple from 'LesliCoreVue/components/notifications/message-simple.vue' 
import componentNotificationProgressBar from 'LesliCoreVue/components/notifications/progress-bar.vue' 

app({

    components: {
        'component-notification-message-simple': componentNotificationMessageSimple,
        'component-notification-progress-bar': componentNotificationProgressBar
    },
    data: {
        translations: { },
        sign_in: {
            email: 'admin@lesli.cloud',
            password: ''
        },
        progress_bar_active: false,
        notification: {
            message: '',
            show: false,
            type: 'is-danger'
        }
    },
    methods: {

        postLogin(event) {
            event.preventDefault();

            let data = {user: this.sign_in};
            this.progress_bar_active = true;

            this.http.post(this.url.to("/login"), data).then(response => {

                this.progress_bar_active = false

                if(response.successful){
                    this.url.go('/')
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
