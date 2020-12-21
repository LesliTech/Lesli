<script>
/*

Copyright (c) 2020, all rights reserved.

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
export default {

    data() {
        return {
            translations: {
                notifications: I18n.t("bell.notifications")
            },
            open: false,
            notifications: []
        }
    },
    mounted() {
        this.mountListeners()
    },
    methods: {

        mountListeners() {
            this.bus.subscribe("show:/core/layout/notification#panel", () => {
                this.getNotifications()
                this.open = true
            })

        },

        getNotifications() {
            this.http.get(this.url.bell("notifications").s).then(result => {
                if (result.successful) {
                    this.notifications = result.data
                }
            })
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

        putNotification(id) {

            // In this case, there is no need to wait for a response
            this.http.put(`/bell/notifications/${id}/read`).catch(error => {
                console.log(error)
            })

            let position = this.notification.list.map(notification => notification.id).indexOf(id)

            this.notification.list.splice(position, 1)

        },

        readNotifications() {
            this.http.put(this.url.bell("/notifications/read").s).then(result => {
                this.notification.list = []
            }).catch(error => {
                console.log(error)
            })
        }

    }
}
</script>
<template>
    <section>
        <b-sidebar
            class="application-panel-notification"
            :open.sync="open"
            :right="true"
            :fullheight="true"> 
            <div 
                :class="['notification', 'is-'+notification.kind, 'is-light']"
                v-for="notification in notifications" :key="notification.id">
                {{ notification.subject }}
                <p class="has-text-grey-light is-size-7">
                    {{ notification.created_at }} - 
                    <a @click="putNotification(notification.id)">
                        {{ translations.notifications.view_text_mark_as_read }}
                    </a>
                </p>
            </div>
        </b-sidebar>
    </section>
</template>
