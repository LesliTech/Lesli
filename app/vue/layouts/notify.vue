<script>
/*
Lesli

Copyright (c) 2019, Lesli Technologies, S. A.

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

@dev      Luis Donis <ldonis@lesli.tech>
@author   LesliTech <hello@lesli.tech>
@license  Propietary - all rights reserved.
@version  GIT: 0.1.0 alpha

//  · 
// ~·~        ~·~        ~·~        ~·~        ~·~        ~·~        ~·~        ~·~        ~·~
*/


// · LesliCloud component
// · ~·~     ~·~     ~·~     ~·~     ~·~     ~·~     ~·~     ~·~     ~·~     ~·~     ~·~
export default {

    data() {
        return {
            notification: {
                show: false,
                timer: null,
                list: []
            }
        }
    },
    mounted() {
        this.mountListeners()
        this.getNotifications()
    },
    methods: {

        mountListeners() {
            
            this.bus.subscribe('show:/cloud/layout/notify#alert', (message, type='primary') => {
                this.$buefy.toast.open({
                    queue: true,
                    duration: 3500,
                    position: 'is-bottom-right',
                    message: message,
                    type: `is-${ type }`
                })
            })

            this.bus.subscribe('show:/cloud/layout/notify#notification', (message, type='success') => {
                this.$buefy.notification.open({
                    queue: true,
                    duration: 2000,
                    position: 'is-bottom-right',
                    message: message,
                    type: `is-${ type }`
                })
            })

            this.bus.subscribe('get:/cloud/layout/notify#notification', () => {
                this.getNotifications()
            })

            this.bus.subscribe('open:/cloud/layout/notify#notification', () => {
                this.openNotificationsPanel()
            })

        },

        getNotifications() {
            this.http.get('/bell/notifications.json').then(result => {
                if (result.successful){
                    this.notification.list = result.data
                }
            }).catch(error => {
                console.log(error)
            })
        },

        openNotificationsPanel() {
            this.getNotifications()
            this.notification.show = true
            this.notification.timer = setTimeout(() => this.notification.show = false, 25000)
        },
        

        prepareDesktopNotification() {

            if (!("Notification" in window)) {
                console.log("This browser does not support desktop notification");
                return
            }

            // Let's check whether notification permissions have already been granted
            if (Notification.permission === "granted") {
                // If it's okay let's create a notification
                var notification = new Notification("Hi there!");
                return
            }

            // Otherwise, we need to ask the user for permission
            if (Notification.permission !== "denied") {
                Notification.requestPermission().then(function (permission) {
                    // If the user accepts, let's create a notification
                    if (permission === "granted") {
                        var notification = new Notification("Hi there!");
                    }
                });
            }
            
        },

        readNotification(index) {
            var notification = this.notification.list[index]
            // In this case, there is no need to wait for a response
            this.http.put(`/bell/api/notifications/${notification.id}/read`).catch(error => {
                console.log(error)
            })
            window.location.href = notification.href

        }

    }
}
</script>
<template>
    <section>
        <div :class="[{ 'is-active': notification.show }, 'quickview']">
            <header class="quickview-header" @click="notification.show = false">
                <p class="title">Notifications</p>
                <i class="fas fa-chevron-right"></i>
            </header>
            <div class="quickview-body">
                <div class="quickview-block">
                    <div class="section">
                        <ul class="menu-list">
                            <li v-for="(notification, index) in notification.list" :key="index" >
                                <a @click="readNotification(index)" href="#">{{ notification.subject }}</a>
                            </li>
                        </ul>
                    </div>
                </div>
            </div>
            <footer class="quickview-footer">
                <a href="/bell/notifications">all notifications</a>
            </footer>
        </div>
    </section>
</template>


