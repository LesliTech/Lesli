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

Lesli - Your Smart Business Assistant

Powered by https://www.lesli.tech
Building a better future, one line of code at a time.

@license  Propietary - all rights reserved.
@version  0.1.0-alpha

// · ~·~     ~·~     ~·~     ~·~     ~·~     ~·~     ~·~     ~·~     ~·~     ~·~     ~·~     ~·~
// · 
*/


// · 
// · ~·~     ~·~     ~·~     ~·~     ~·~     ~·~     ~·~     ~·~     ~·~     ~·~     ~·~     ~·~
export default {

    data() {
        return {
            notification: {
                show: false,
                timer: null,
                list: []
            },
            translations: {
                bell: {
                    notifications: I18n.t('bell.notifications')
                }
            },
        }
    },
    mounted() {
        this.mountListeners()
    },
    methods: {

        mountListeners() {
            this.bus.subscribe("show:/core/layout/notification#alert", (message, type='primary') => {
                this.$buefy.toast.open({
                    queue: true,
                    duration: 3500,
                    position: 'is-bottom-right',
                    message: message,
                    type: `is-${ type }`
                })
            })

            this.bus.subscribe("show:/core/layout/notification#panel", () => {
                
                // toggle notification panel
                if (this.notification.show == true) {
                    this.notification.show = false
                    return
                }
                this.showNotificationPanel()
            })

        },

        getNotifications() {
            //this.http.get('/bell/notifications.json').then(result => {
            this.http.get('/crm/dashboards/next-tasks.json').then(result => {
                console.log(result)
                if (result.successful){
                    this.notification.list = result.data
                }
            }).catch(error => {
                console.log(error)
            })
        },

        showNotificationPanel() {
            this.getNotifications()
            this.notification.show = true
            this.notification.timer = setTimeout(() => this.notification.show = false, 600000)
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

        readNotification(id) {

            // In this case, there is no need to wait for a response
            this.http.put(`/bell/notifications/${id}/read`).catch(error => {
                console.log(error)
            })

            let position = this.notification.list.map(notification => notification.id).indexOf(id)

            this.notification.list.splice(position, 1)

        },

        readNotifications() {
            this.http.put('/bell/notifications/read').then(result => {
                this.notification.list = []
            }).catch(error => {
                console.log(error)
            })
        }

    }
}
</script>
<template>
    <section class="application-notification">
        <div :class="[{ 'is-active': notification.show }, 'quickview']">
            <header class="quickview-header" @click="notification.show = false">
                <p class="title">{{ translations.bell.notifications.title }}</p>
                <i class="fas fa-chevron-right"></i>
            </header>
            <div class="quickview-body">
                <div class="quickview-block">
                    <p class="filter-option has-text-right">
                        <!-- <small @click="readNotifications()" class="has-text-grey-light">{{ translations.bell.notifications.text_mark_all_as_read }}</small> -->
                    </p>
                    <div class="section">
                        <ul class="menu-list">
                            <li v-for="notification in notification.list" :key="notification.id" >
                                <a :href="'/crm/tasks/'+notification.id">
                                    {{ notification.title }}
                                </a> 
                                <small class="has-text-grey-light">deadline: {{ notification.deadline }}</small>
                            </li>
                            <!-- 
                            <li v-for="notification in notification.list" :key="notification.id" >
                                <i class="fas fa-info-circle"></i>
                                <a @click="readNotification(index)" href="#">{{ notification.subject }}</a>
                                <a v-if="notification.url" :href="notification.url">
                                    {{ notification.subject }}
                                </a> 
                                <p v-if="!notification.url">
                                    {{ notification.subject }}
                                </p>
                                <small class="has-text-grey-light">{{ notification.created_at }}</small>
                                <small class="has-text-grey-light">-</small>
                                <small class="mark-as-read has-text-grey-light"
                                    @click="readNotification(notification.id)">
                                    {{ translations.bell.notifications.text_mark_as_read }}
                                </small>
                            </li>
                            -->
                        </ul>
                    </div>
                </div>
            </div>
            <!-- 
            <footer class="quickview-footer">
                <a href="/bell/notifications">all notifications</a>
            </footer>
            -->
        </div>
    </section>
</template>
<style>
    .icon-dot {
        display: block;
        width: 5px;
        height: 5px;
        background-color: blue;
    }
</style>
