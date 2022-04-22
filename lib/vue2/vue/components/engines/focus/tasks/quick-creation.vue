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


// · List of Imported Components
// · ~·~     ~·~     ~·~     ~·~     ~·~     ~·~     ~·~     ~·~     ~·~     ~·~     ~·~     ~·~
import taskForm from './quick-form.vue'
import taskList from './quick-list.vue'
// ·
// · ~·~     ~·~     ~·~     ~·~     ~·~     ~·~     ~·~     ~·~     ~·~     ~·~     ~·~     ~·~


export default {
    components: {
        'task-form': taskForm,
        'task-list': taskList
    },

    props: {
        engineEndpoint: {
            type: String,
            default: 'focus'
        },
        model_id: {
            required: true
        },
        model_type: {
            required: true
        },
        statusEvent: {
            default: null
        },
        user_filters: {
            default: '',
            Type: String
        },
        subscribeToEventChanges: {
            type: Boolean,
            default: false
        },
        active: {
            type: Boolean,
            default: true
        }
    },

    data() {
        return {
            users_ready: false,
            options_ready: false,
            options: {},
            translations: {
                tasks: I18n.t('focus.tasks')
            },
            active_tab: 1,
            main_tab_name: 'tasks'
        }
    },


    beforeDestroy(){
        this.deleteSubscriptions()
    },

    mounted(){
        this.setSubscriptions()
        this.getBackendData()

    },

    methods: {
        getBackendData(){
            if(this.active){
                this.getOptions()
                this.getUsers()
                this.setActiveTab()
            }
        },

        setSubscriptions(){
            this.bus.subscribe('new:/focus/task', () => {
                this.active_tab = 1
            })
        },

        setActiveTab(){
            let tab_data = (this.$route.query.tab || '').split('/')
            let tab = tab_data[0]
            let subtab = ''
            if(tab_data.length > 1){
                subtab = tab_data[1]
            }

            if(tab && subtab && tab == this.main_tab_name){
                switch(subtab){
                    case 'new':
                        this.active_tab = 0
                        break
                    case 'list':
                        this.active_tab = 1
                        break
                }
            }
        },

        deleteSubscriptions(){
            this.bus.$off('new:/focus/task')
        },

        openNewTaskTab(){
            this.active_tab = 0
        },

        getOptions() {
            let url = `/${this.engineEndpoint}/tasks/options.json?view_type=index&model_type=${this.model_type}`
            this.http.get(url).then(result => {
                if (result.successful) {
                    for(let key in result.data){
                        this.$set(this.options, key, result.data[key])
                    }
                    this.options_ready = true
                }
            }).catch(error => {
                console.log(error)
            })
        },

        getUsers(){
            let url = this.url.admin('users/list').toString(true)
            url += `?${this.user_filters}&exclude=roles`

            this.http.get(url).then(result => {
                if (result.successful) {
                    this.$set(this.options, 'users', result.data)
                    this.users_ready = true
                }
            }).catch(error => {
                console.log(error)
            })
        }
    },

    watch: {
        active(){
            if(! this.options_ready){
                this.getBackendData()
            }
        }
    }
}

</script>
<template lang="">
    <section>
        <b-tabs :expanded="true" v-model="active_tab">
            <b-tab-item :label="translations.tasks.view_title_new">
                <task-form
                    v-if="options_ready && users_ready"
                    :options="options"
                    :model_id="model_id"
                    :model_type="model_type"
                    :engine-endpoint="engineEndpoint"
                />
            </b-tab-item>
            <b-tab-item :label="translations.tasks.view_tab_title_all">
                <task-list
                    v-if="options_ready && users_ready"
                    :options="options"
                    :model_id="model_id"
                    :model_type="model_type"
                    :status-event="statusEvent"
                    :engine-endpoint="engineEndpoint"
                    :subscribe-to-event-changes="subscribeToEventChanges"
                    :open-new-task-tab="openNewTaskTab"
                />
            </b-tab-item>
        </b-tabs>
    </section>
</template>
