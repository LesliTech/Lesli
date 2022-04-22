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
    props: {
        instanceEndpoint: {
            type: String,
            default: 'focus'
        }
    },

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
            render_component: true
        }
    },
    methods: {

        getTasks() {
            this.http.get('/focus/tasks/resources/overdue_tasks.json?perPage=500&orderColumn=importance').then(result => {
                if (result.successful){
                    this.notification.list = result.data
                }
            }).catch(error => {
                console.log(error)
            })
        },

        showNotificationPanel() {
            this.getTasks()
            this.notification.show = true
            this.notification.timer = setTimeout(() => this.notification.show = false, 600000)
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
        },

        cleanNotification(){
            this.notification = {
                show: false,
                timer: null,
                list: []
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
        },

        "$route": {
            handler: function(){
                this.render_component = false

                this.$nextTick(()=>{
                    this.render_component = true
                })

                this.cleanNotification()
                this.getTasks()
            },
            deep: true
        },

        "notification.list": {
            handler: function(new_values, _){
                this.lesli.tasks = new_values.length
            },
            deep: true
        }
    }
}
</script>
<template>
    <b-sidebar
        v-if="render_component"
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
                        <a :href="`/${instanceEndpoint}/tasks/${notification.id}/edit`">
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
