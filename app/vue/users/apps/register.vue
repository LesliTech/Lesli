<script>
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


// · import core components
// · ~·~     ~·~     ~·~     ~·~     ~·~     ~·~     ~·~     ~·~     ~·~     ~·~     ~·~     ~·~
import componentNotificationMessageSimple from 'LesliCoreVue/components/notifications/message-simple.vue' 
import componentNotificationProgressBar from 'LesliCoreVue/components/notifications/progress-bar.vue' 


// · 
export default {

    components: {
        'component-notification-message-simple': componentNotificationMessageSimple,
        'component-notification-progress-bar': componentNotificationProgressBar
    },
    data(){
        return{
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

}
</script>
<template>
    <section>

        <a class="logo" :href="this.url.to()">
            <img src="/assets/brand/lesli-logo.png" alt="LesliCloud Logo">
        </a>

        <form ref="form" @submit="postRegistration">

            <component-notification-progress-bar :active="progress_bar_active"/>
            <component-notification-message-simple
                :message="notification.message"
                :show.sync="notification.show"
                :type="notification.type"
            />

            <div class="field">
                <p class="control has-icons-left">
                    <label class="sr-only">
                        email
                    </label>
                    <input 
                        class="input" 
                        type="email"
                        v-model="sign_up.email"
                        required="true"
                        placeholder="email"
                    />
                    <span class="icon is-small is-left">
                        <i class="fas fa-envelope"></i>
                    </span>
                </p>
            </div>

            <div class="field">
                <p class="control has-icons-left">
                    <label class="sr-only" for="user_password">
                        password
                    </label>
                    <input 
                        type="password"
                        class="input"
                        required="true"
                        minlength="6"
                        v-model="sign_up.password"
                        placeholder="password"
                        @change="verifyPasswords"
                    />
                    <span class="icon is-small is-left">
                        <i class="fas fa-lock"></i>
                    </span>
                </p>
            </div>

            <div class="field">
                <p class="control has-icons-left">
                    <label class="sr-only" for="user_password">
                    confirm password
                    </label>
                    <input 
                        type="password"
                        class="input"
                        required="true"
                        v-model="sign_up.password_confirmation"
                        placeholder="confirm password"
                        @change="verifyPasswords"
                    />
                    <span class="icon is-small is-left">
                        <i class="fas fa-lock"></i>
                    </span>
                </p>
            </div>

            <input class="button is-primary" type="submit" value="register" />

        </form>

        <div class="links">
            <a @click="$router.push('/login')">
                login
            </a>
            <a @click="$router.push('/confirmation/new')">
                resend confirmation email
            </a>
        </div>

    </section>
</template>

