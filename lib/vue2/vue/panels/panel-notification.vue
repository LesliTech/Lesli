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
            notifications: []
        }
    },

    mounted() {
        this.data.global.cloud_bell_notifications = this.lesli.notifications
    },

    beforeDestroy() {
        this.wss.close()
    },

    methods: {

        getNotifications() {
            this.http.get(this.url.profile("notifications")).then(result => {
                if (result.successful) {
                    this.notifications = result.data
                }
            })
        },

        putNotification(current) {

            this.http.put(this.url.profile("notifications/:id", current.id)).then(result => {

                let position = this.notifications.records.map(notification => notification.id).indexOf(current.id)

                this.notifications.records.splice(position, 1)

                this.notifications.pagination.count_total--

            }).finally(() => {
                if (current.url) {
                    this.url.go(current.url)
                }
            })

        },

        readNotifications() {
            this.http.put(this.url.profile("notifications/all")).then(result => {
                this.notifications.pagination.count_total = 0
                this.notifications.records = []
            })
        }

    },
    watch: {

        // update notification count in the main header after mark a notification as read
        'notifications.pagination.count_total': function (val) {
            this.data.global.cloud_bell_notifications = val
        },

        // get user notifications every time the user opens the notifications panel
        'data.global.show_panel_notifications': function(open) {
            if (open) {
                this.getNotifications()
            }
        }

    }
    
}
</script>
<template>
    <b-sidebar
        class="application-panel-notification"
        :open.sync="data.global.show_panel_notifications"
        :right="true"
        :fullheight="true">
        <div class="panel-title is-size-5">
            <h4>
                Notifications
                ({{ notifications.pagination ? notifications.pagination.count_total : 0 }})
            </h4>
            <button class="button is-text" @click="readNotifications()">
                mark all as read
            </button>
            <span class="icon is-large hover" @click="data.global.show_panel_notifications = false">
                <i class="fas fa-lg fa-chevron-right"></i>
            </span>
        </div>
        <div
            v-for="notification in notifications.records" :key="notification.id"
            :class="['lesli-notification', notification.category, {'has-url': !!notification.url }]"
            @click="putNotification(notification)">
            <span class="icon">
                <i class="fas fa-info-circle"></i>
            </span>
            <div class="details">
                <strong :class="(!!notification.url ? 'has-text-link' : false)">
                    {{ notification.subject }}
                </strong>
                <p>{{ notification.body }}</p>
                <p class="has-text-grey-light is-size-7">
                    {{ notification.created_at }} ago -
                    <a v-if="!notification.url" @click="putNotification(notification.id)">
                        {{ translations.notifications.view_text_mark_as_read || 'mark as read' }}
                    </a>
                    <span v-if="notification.url">
                        <i class="fas fa-external-link-alt"></i>
                    </span>
                </p>
            </div>
        </div>
    </b-sidebar>
</template>
