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
// · ~·~     ~·~     ~·~     ~·~     ~·~     ~·~     ~·~     ~·~     ~·~     ~·~     ~·~     ~·~
export default {

    data() {
        return {
            message: {
                active: false,
                message: ""
            },
            notification: {
                show: false,
                timer: null,
                list: []
            },
            translations: {
                focus: {
                    tasks: I18n.t('focus.tasks'),
                },
                bell: {
                    notifications: I18n.t('deutscheleibrenten.notifications')
                }
            },
        }
    },
    mounted() {
        this.mountListeners()
    },
    methods: {

        mountListeners() {

            // alerts
            this.bus.subscribe("show:/lesli/layout/alert", (message, type="info") => {
                this.$buefy.toast.open({
                    queue: false,
                    duration: 5000,
                    position: 'is-bottom-right',
                    message: message,
                    type: `is-${ type }`
                })
            })

            // Notifications
            this.bus.subscribe("show:/lesli/layout/notification", (message, type="info") => {
                this.$buefy.notification.open({
                    queue: false,
                    hasIcon: true,
                    duration: 5000,
                    position: 'is-bottom-right',
                    message: message,
                    type: `is-${ type }`
                })
            })

        },

        getNotifications() {
            this.http.get('/crm/dashboards/resources/overdue-tasks.json?perPage=500&orderColumn=importance').then(result => {
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
        },

        classColor(notification){
            switch (notification.importance) {
                case 'urgent': {
                    return 'has-text-danger'
                }
                case 'important': {
                    return 'has-text-success'
                }
                default: {
                    return 'has-text-info'
                }
            }
        }
    },

    watch: {
        'data.global.show_panel_tasks': function(){
            if(this.data.global.show_panel_tasks){
                // toggle notification panel
                if (this.notification.show == true) {
                    this.notification.show = false
                    return
                }
                this.showNotificationPanel()
            }
        }
    }
}
</script>
<template>
    <b-sidebar
        class="application-panel-notification"
        :open.sync="data.global.show_panel_tasks"
        :right="true"
        :overlay="false"
        :fullheight="true"> 
        <div class="panel-title is-size-5">
            <h4>
                {{translations.focus.tasks.view_title_tasks_due_today}}
            </h4>
            <span class="icon is-large hover" @click="data.global.show_panel_tasks = false">
                <i class="fas fa-lg fa-chevron-right"></i>
            </span>
        </div>
        <div class="quickview-body">
            <div class="section">
                <ul class="menu-list">
                    <li v-for="notification in notification.list" :key="notification.id" >
                        <a :href="`/crm/tasks/${notification.id}/edit`">
                            {{ notification.title }}
                        </a> 
                        <p>
                                <small class="has-text-grey-light"> 
                                {{ `${translations.focus.tasks.column_deadline} : ${notification.deadline}` }} 
                            </small>
                        </p>
                        <p>
                            <small class="has-text-grey-light">
                                {{ `${translations.focus.tasks.column_importance} :` }}
                            </small>
                            <small :class="classColor(notification)">
                                {{ notification.importance }}
                            </small>
                        </p>
                    </li>
                </ul>
            </div>
        </div>
    </b-sidebar>
</template>
<style>
    .notification-message {
        position: fixed;
        right: 10px;
        bottom: 10px;
    }
    .icon-dot {
        display: block;
        width: 5px;
        height: 5px;
        background-color: blue;
    }
</style>
