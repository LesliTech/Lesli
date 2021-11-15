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
export default {
    props: {
        workflowId: {
            required: true
        },

        engineNamespace: {
            required: true
        },
        translationsPath: {
            required: true,
            type: String
        }
    },

    data(){
        return {
            show: false,
            translations: {
                core: I18n.t('core.shared'),
                checks: I18n.t('core.workflow/checks'),
                roles: I18n.t('core.roles')
            },
            options: {
                roles: [],
                statuses: []
            },
            transition_statuses: [],
            loading: false,
            submitting: false,
            active_tab: 0,
            new_check: {
                name: '',
                active: false,
                initial_status_id: null,
                final_status_id: null,
                users_id: null,
                user_name: '',
                roles_id: null
            }
        }
    },

    mounted(){
        this.setMainRoute()
        this.setTranslations()
        this.getCheckOptions()
    },

    methods: {
        setMainRoute(){
            if(this.engineNamespace == '/'){
                this.main_route = `/workflows/${this.workflowId}/checks`
            }else{
                this.main_route = `/${this.engineNamespace}/workflows/${this.workflowId}/checks`
            }
            
        },

        setTranslations(){
            this.$set(this.translations, 'main', I18n.t(this.translationsPath))
        },

        getCheckOptions(){
            let url = `${this.main_route}/options.json`
            this.loading = true

            this.http.get(url).then(result => {
                if (result.successful) {
                    this.options = result.data
                    this.transition_statuses = Object.values(result.data.statuses)
                }else{
                    this.msg.error(result.error.message)
                }
            }).catch(error => {
                console.log(error)
            }).finally(()=>{
                this.loading = false
            })
        },

        postCheck(event){
            if(event){
                event.preventDefault()
            }

            let data = {
                workflow_check: this.new_check
            }
            this.submitting = true

            this.http.post(this.main_route, data).then(result => {
                if (result.successful) {
                    this.msg.success(this.translations.checks.messages_success_check_created)
                    this.resetCheck()
                }else{
                    this.msg.error(result.error.message)
                }
            }).catch(error => {
                console.log(error)
            }).finally(()=>{
                this.submitting = false
            })
        },

        resetCheck(){
            this.new_check = {
                name: '',
                active: false,
                initial_status_id: null,
                final_status_id: null,
                users_id: null,
                user_name: '',
                roles_id: null
            }
        },

        selectUser(user){
            if(user){
                this.new_check.users_id = user.id
            }else{
                this.new_check.users_id = null
            }
        }
    },

    watch: {
        'new_check.initial_status_id'(){
            let transition_statuses = []
            if(this.new_check.initial_status_id){
                let initial_status = this.options.statuses[this.new_check.initial_status_id]
                if(initial_status){
                    initial_status.next_statuses.forEach((status_id) => {
                        transition_statuses.push(this.options.statuses[status_id])
                    })
                }
            }else{
                transition_statuses = Object.values(this.options.statuses)
            }
            this.transition_statuses = transition_statuses
        }
    },

    computed: {
        initialStatuses(){
            if(this.options.statuses){
                let initial_statuses = Object.values(this.options.statuses)
                initial_statuses.unshift({
                    id: null,
                    name: this.translations.core.view_text_none,
                    number: null
                })
                return initial_statuses
            }else{
                return []
            }
        },

        filteredUsers(){
            return this.options.users.filter((user) => {
                return (user.name || "").toLowerCase().includes((this.new_check.user_name || "").toLowerCase())
            })
        }
    }
}
</script>
<template>
    <div v-if="translations.checks">
        <h5 class="title is-5">{{translations.checks.view_title_main}}</h5>

        <component-data-loading v-if="loading" />
        <form v-if="!loading" @submit="postCheck">
            <fieldset :disabled="submitting">
                <div class="columns is-multiline">
                    <div class="column is-4">
                        <div class="field">
                            <label class="label">{{translations.checks.column_name}}<sup class="has-text-danger">*</sup></label>
                            <div class="control">
                                <input class="input" type="text" v-model="new_check.name" required>
                            </div>
                        </div>
                    </div>
                    <div class="column is-2">
                        <div class="field">
                            <label class="label">{{translations.checks.column_active}}</label>
                            <b-select expanded v-model="new_check.active">
                                <option :value="true">{{translations.core.view_text_yes}}</option>
                                <option :value="false">{{translations.core.view_text_no}}</option>
                            </b-select>
                        </div>
                    </div>
                    <div class="column is-3">
                        <div class="field">
                            <label class="label">{{translations.checks.column_initial_status_id}}<sup class="has-text-danger">*</sup></label>
                            <b-select expanded v-model="new_check.initial_status_id" required>
                                <option
                                    v-for="status in initialStatuses"
                                    :value="status.id"
                                    :key="status.id"
                                >
                                    <small>{{
                                        object_utils.translateEnum(translations.core, 'column_enum_status', status.name, null) ||
                                        object_utils.translateEnum(translations.statuses, 'column_enum_status', status.name, null) ||
                                        object_utils.translateEnum(translations.statuses, 'status', status.name)
                                    }}</small>
                                </option>
                            </b-select>
                        </div>
                    </div>
                    <div class="column is-3">
                        <div class="field">
                            <label class="label">{{translations.checks.column_final_status_id}}</label>
                            <b-select :placeholder="translations.core.view_placeholder_select_option" expanded v-model="new_check.final_status_id">
                                <option
                                    v-for="status in transition_statuses"
                                    :value="status.id"
                                    :key="status.id"
                                >
                                    <small>{{
                                        object_utils.translateEnum(translations.core, 'column_enum_status', status.name, null) ||
                                        object_utils.translateEnum(translations.statuses, 'column_enum_status', status.name, null) ||
                                        object_utils.translateEnum(translations.statuses, 'status', status.name)
                                    }}</small>
                                </option>
                            </b-select>
                        </div>
                    </div>
                    <div class="column is-4">
                        <b-field :message="translations.checks.view_text_column_roles_id_description" :label="translations.checks.column_roles_id">
                            <b-select :placeholder="translations.core.view_placeholder_select_option" expanded v-model="new_check.roles_id">
                                <option
                                    v-for="role in options.roles"
                                    :value="role.id"
                                    :key="role.id"
                                >   
                                    <small>{{object_utils.translateEnum(translations.roles, 'column_enum_role', role.name)}}</small>
                                </option>
                            </b-select>
                        </b-field>
                    </div>

                    <div class="column is-4">
                        <label class="label">{{translations.checks.column_user_type}}<sup class="has-text-danger">*</sup></label>
                        <b-select :placeholder="translations.core.view_placeholder_select_option" expanded v-model="new_check.user_type" required>
                            <option
                                v-for="user_type in options.user_types"
                                :value="user_type.value"
                                :key="user_type.value"
                            >
                                <small>
                                    {{ object_utils.translateEnum(translations.checks, 'column_enum_user_type', user_type.text) }}
                                </small>
                            </option>
                        </b-select>
                    </div>

                    <div class="column is-4">
                        <div class="field" v-if="new_check.user_type == 'custom'">
                            <label class="label">{{translations.checks.column_users_id}}<sup class="has-text-danger">*</sup></label>
                            <div class="control">
                                <b-autocomplete
                                    :placeholder="translations.core.view_placeholder_select_option"
                                    v-model="new_check.user_name"
                                    required
                                    keep-first
                                    field="name"
                                    @select="selectUser"
                                    :data="filteredUsers"
                                >
                                </b-autocomplete>
                            </div>
                        </div>
                    </div>




                </div>
                <div class="column is-12">
                    <b-button type="is-primary" expanded native-type="submit">
                        <span v-if="submitting">
                            <b-icon icon="circle-notch"  custom-class="fa-spin" size="is-small"></b-icon>
                            <span>{{translations.core.view_btn_save}}</span>
                        </span>
                        <span v-else>
                            <b-icon icon="save" size="is-small"></b-icon>
                            <span>{{translations.core.view_btn_save}}</span>
                        </span>
                    </b-button>
                </div>
            </fieldset>
        </form>
    </div>
</template>
