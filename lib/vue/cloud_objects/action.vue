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
import componentActionForm from "./actions/form.vue"
import componentActionList from "./actions/list.vue"


export default {
    props: {
        cloudModule: {
            type: String,
            required: true
        },
        cloudId: {
            required: true
        },
        active: {
            type: Boolean,
            default: true
        }
    },

    components: {
        'component-action-form': componentActionForm,
        'component-action-list': componentActionList
    },

    data(){
        return {
            module_name: null,
            object_name: null,
            loaded: false,
            loading: false,
            translations: {
                core: I18n.t('core.shared')
            },
            action_groups: {},
            new_group_name: ''
        }
    },

    mounted(){
        this.parseCloudModule()
        this.getBackendData()
    },

    methods: {
        parseCloudModule(){
            let parsed_data = this.object_utils.parseCloudModule(this.cloudModule)
            this.object_name = parsed_data.cloud_object_name
            this.module_name = parsed_data.cloud_module_name
        },

        getBackendData(){
            if(this.active){
                this.getActions()
            }
        },

        getActions(){
            let url = `/${this.module_name.slash}/${this.object_name.plural}/${this.cloudId}/actions.json`
            this.loading = true

            this.http.get(url).then(result => {
                if (result.successful) {
                    this.action_groups = this.parseActions(result.data)
                }else{
                    this.msg.error(result.error.message)
                }
            }).catch(error => {
                console.log(error)
            }).finally(()=>{
                this.loaded = true
                this.loading = false
            })
        },

        parseActions(actions){
            for(let key in actions){
                actions[key] = {
                    new_action: {
                        instructions: ''
                    },
                    actions: actions[key]
                }
            }

            console.log(JSON.stringify(actions))
            return actions
        },

        createGroup(event){
            if(event){
                event.preventDefault()
            }

            if(! this.new_group_name){
                this.msg.warn('(T) You need to set a new name for the group')
                return
            }

            if(this.groupNameValid()){
                this.$set(this.action_groups, this.new_group_name, {new_action: {instructions: ''}, actions: []})
                this.$nextTick(()=>{
                    this.$refs[`input-new-action-${this.downcase(this.new_group_name)}`][0].focus()
                    this.new_group_name = ''
                })
            }else{
                this.msg.warn('(T) The group name you selected is already taken')
            }
        },

        createAction(event, group_name){
            if(event){
                event.preventDefault()
            }

            let group = this.action_groups[group_name]
            if(! group.new_action.instructions){
                this.msg.warn('(T) You need to set instructions for the action')
                return
            }

            let data = {}
            data[`${this.object_name.singular}_action`] = {
                instructions: group.new_action.instructions,
                group: group_name
            }
            let url = `/${this.module_name.slash}/${this.object_name.plural}/${this.cloudId}/actions`
            this.submitting_form = true

            this.http.post(url, data).then(result => {
                if (result.successful) {
                    group.actions.push({
                        instructions: result.data.instructions,
                        complete: result.data.complete,
                        user_creator_name: result.data.user_creator_name,
                        created_at_text: result.data.created_at_text
                    })
                    group.new_action.instructions = ''

                    this.msg.success('(T) Action created successfully')
                }else{
                    this.msg.error(result.error.message)
                }
            }).catch(error => {
                console.log(error)
            }).finally(()=>{
                this.submitting_form = false
            })
        },

        groupNameValid(){
            return Object.keys(this.action_groups).indexOf(this.new_group_name) == -1
        },

        downcase(group_name){
            return group_name.toLowerCase().replace(/ /g,"_")
        },

        completedActions(group){
            return group.actions.filter(action => action.complete).length
        },

        completedGroup(group){{
            return this.completedActions(group) == group.actions.length
        }}
    },

    watch: {
        cloudId(){
            this.getActions()
        },

        active(){
            if(! this.loaded){
                this.getBackendData()
            }
        }
    }
}
</script>
<template>
    <section>
        <div class="card">
            <div class="card-header">
                <div class="card-header-title is-shadowless">
                    <h4 class=" title is-4">
                        {{translations.core.view_text_quick_actions}}
                    </h4>
                </div>
            </div>
            <div class="card-content">
                <br>
                <component-data-loading v-if="loading"></component-data-loading>
                <div class="columns is-multiline" v-else>
                    
                    <div class="column is-4" v-for="(group, name, index) in action_groups" :key="name">
                        <b-collapse class="card" animation="slide" :aria-id="`action-group-${index}`">
                            <template v-slot:trigger>
                                <div
                                    :class="['card-header', {'has-text-success': completedGroup(group)}]"
                                    role="button"
                                    :aria-controls="`action-group-${index}`"
                                >
                                    <p class="card-header-title">
                                        {{name}}
                                    </p>
                                    <a class="card-header-icon">
                                        <span>{{completedActions(group)}}/{{group.actions.length}}</span>
                                        &nbsp;
                                        <b-icon size="is-small" icon="check-square">
                                        </b-icon>
                                    </a>
                                </div>
                            </template>
                            <div class="card-content">
                                <div class="content">
                                    <form @submit="createAction($event, name)">
                                        <b-field label-position="on-border">
                                            <template v-slot:label>
                                                (T) Add a new Action <sup class="has-text-danger">*</sup>
                                            </template>
                                            <b-input :ref="`input-new-action-${downcase(name)}`" type="text" expanded v-model="group.new_action.instructions">
                                            </b-input>
                                            <p class="control">
                                                <b-button native-type="submit" expanded class="has-text-centered">
                                                    <b-icon icon="plus"></b-icon>
                                                    <span>(T) Add</span>
                                                </b-button>
                                            </p>
                                        </b-field>
                                        <hr>
                                        <b-field v-for="(action, index) in group.actions" :key="index">
                                            <b-checkbox v-model="action.complete">
                                                {{action.instructions}}
                                                <sub><small>{{action.user_creator_name}} - {{action.created_at_text}}</small></sub>
                                            </b-checkbox>
                                        </b-field>
                                    </form>
                                </div>
                            </div>
                        </b-collapse>
                    </div>
                    <div class="column is-4">
                        <form @submit="createGroup">
                            <b-field label-position="on-border">
                                <template v-slot:label>
                                    (T) Add a new Group <sup class="has-text-danger">*</sup>
                                </template>
                                <b-input type="text" expanded v-model="new_group_name">
                                </b-input>
                                <p class="control">
                                    <b-button native-type="submit" expanded class="has-text-centered">
                                        <b-icon icon="plus"></b-icon>
                                        <span>(T) Add</span>
                                    </b-button>
                                </p>
                            </b-field>
                        </form>
                    </div>
                </div>
            </div>
        </div>
    </section>
</template>
