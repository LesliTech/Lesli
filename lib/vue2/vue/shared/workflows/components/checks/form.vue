`<script>
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

        statusesTranslationsPath: {
            required: true,
            type: String
        },
        
        viewType: {
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
            check: {
                name: '',
                active: false,
                initial_status_id: null,
                final_status_id: null,
                users_id: null,
                user_type: 'any',
                user_name: '',
                roles_id: null
            }
        }
    },

    mounted(){
        this.setMainRoute()
        this.setTranslations()
        this.setEmptyTransition()
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

        setEmptyTransition(){
            this.transition_statuses.push({
                id: null,
                name: this.translations.core.view_text_none,
                number: null
            })
        },

        setTranslations(){
            this.$set(this.translations, 'statuses', I18n.t(this.statusesTranslationsPath))
        },

        getCheckOptions(){
            let url = `${this.main_route}/options.json`
            this.loading = true

            this.http.get(url).then(result => {
                if (result.successful) {
                    this.options = result.data
                }else{
                    this.msg.error(result.error.message)
                }
            }).catch(error => {
                console.log(error)
            }).finally(()=>{
                this.loading = false
            })
        },

        getWorkflowCheck(){
            this.loading = true
            this.resetCheck()
            let url = `${this.main_route}/${this.check_id}.json`

            this.http.get(url).then(result => {
                if (result.successful) {
                    this.check = result.data
                }else{
                    this.msg.error(result.error.message)
                }
            }).catch(error => {
                console.log(error)
            }).finally(()=>{
                this.loading = false
            })
        },

        submitCheck(event){
            if(event){
                event.preventDefault()
            }

            if(this.check_id){
                this.putCheck()
            }else{
                this.postCheck()
            }
        },

        postCheck(){
            let data = {
                workflow_check: this.check
            }
            this.submitting = true

            this.http.post(`${this.main_route}.json`, data).then(result => {
                if (result.successful) {
                    this.msg.success(this.translations.checks.messages_success_check_created)

                    this.data.checks.selected_record_id = result.data.id
                    this.data.checks.records.push(result.data)
                    this.data.checks.active_tab = 2

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

        putCheck(){
            let url = `${this.main_route}/${this.check_id}.json`

            let data = {
                workflow_check: this.check
            }
            this.submitting = true

            this.http.put(url, data).then(result => {
                if (result.successful) {
                    this.msg.success(this.translations.checks.messages_success_check_updated)

                    this.data.checks.reload = true
                }else{
                    this.msg.error(result.error.message)
                }
            }).catch(error => {
                console.log(error)
            }).finally(()=>{
                this.submitting = false
            })
        },

        confirmCheckDeletion(){
            this.$buefy.dialog.confirm({
                    title: this.translations.checks.messages_danger_delete_confirmation_title,
                    message: this.translations.checks.messages_danger_delete_confirmation_body,
                    cancelText: this.translations.core.view_btn_cancel,
                    confirmText: this.translations.core.view_btn_accept,
                    type: 'is-danger',
                    onConfirm: () => this.deleteCheck()
                })
        },

        deleteCheck(){
            let url = `${this.main_route}/${this.check_id}`

            this.http.delete(url).then(result => {
                if (result.successful) {
                    this.msg.success(this.translations.checks.messages_success_check_destroyed)
                    
                    this.data.checks.records = this.data.checks.records.filter(check => check.id != this.data.checks.selected_record_id)
                    this.data.checks.active_tab = 0

                    this.$nextTick(()=>{
                        this.check_id = null
                        this.data.checks.selected_record_id = null
                    })
                }else{
                    this.msg.error(result.error.message)
                }
            }).catch(error => {
                console.log(error)
            })
        },

        resetCheck(){
            this.check = {
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
                this.check.users_id = user.id
            }else{
                this.check.users_id = null
            }
        }
    },

    watch: {
        'check.initial_status_id'(){
            let transition_statuses = []
            if(this.check.initial_status_id){
                let initial_status = this.options.statuses[this.check.initial_status_id]
                if(initial_status){
                    initial_status.next_statuses.forEach((status_id) => {
                        transition_statuses.push(this.options.statuses[status_id])
                    })
                }
            }else{
                transition_statuses = Object.values(this.options.statuses)
            }
            transition_statuses.unshift({
                id: null,
                name: this.translations.core.view_text_none,
                number: null
            })

            this.transition_statuses = transition_statuses
        },

        'data.checks.selected_record_id'(){
            if(this.viewType != 'edit'){
                return
            }

            if(this.data.checks.selected_record_id){
                this.check_id = this.data.checks.selected_record_id
                this.getWorkflowCheck()
            }else{
                this.check_id = null
                this.resetCheck()
            }
        }
    },

    computed: {
        initialStatuses(){
            if(this.options.statuses){
                let initial_statuses = Object.values(this.options.statuses)
                return initial_statuses
            }else{
                return []
            }
        },

        filteredUsers(){
            return this.options.users.filter((user) => {
                return (user.name || "").toLowerCase().includes((this.check.user_name || "").toLowerCase())
            })
        }
    }
}
</script>
<template>
    <div v-if="translations.checks">
        <component-data-loading v-if="loading" />
        <form v-if="!loading" @submit="submitCheck">
            <fieldset :disabled="submitting">
                <div class="columns is-multiline">
                    <div class="column is-12 has-text-right">
                        <b-button v-if="viewType == 'edit'" type="is-danger" outlined native-type="button" @click="confirmCheckDeletion">
                            <i class="fas fa-trash-alt"></i>
                            {{translations.core.view_btn_delete}}
                        </b-button>
                    </div>
                    <div class="column is-4">
                        <div class="field">
                            <label class="label">{{translations.checks.column_name}}<sup class="has-text-danger">*</sup></label>
                            <div class="control">
                                <input class="input" type="text" v-model="check.name" required>
                            </div>
                        </div>
                    </div>
                    <div class="column is-2">
                        <div class="field">
                            <label class="label">{{translations.checks.column_active}}</label>
                            <b-select expanded v-model="check.active">
                                <option :value="true">{{translations.core.view_text_yes}}</option>
                                <option :value="false">{{translations.core.view_text_no}}</option>
                            </b-select>
                        </div>
                    </div>
                    <div class="column is-3">
                        <div class="field">
                            <label class="label">{{translations.checks.column_initial_status_id}}<sup class="has-text-danger">*</sup></label>
                            <b-select :placeholder="translations.core.view_placeholder_select_option" expanded v-model="check.initial_status_id" required>
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
                            <b-select expanded v-model="check.final_status_id">
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
                        <b-field :message="translations.checks.view_text_column_roles_id_description">
                            <template v-slot:label>
                                <span>{{translations.checks.column_roles_id}}</span>
                                <sup v-if="check.user_type == 'any' || check.user_type == null" class="has-text-danger">*</sup>
                            </template>
                            <b-select
                                expanded
                                v-model="check.roles_id"
                                :required="check.user_type == 'any' || check.user_type == null"
                            >
                                <option :value="null">{{translations.checks.view_text_any_role}}</option>
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
                        <b-field :message="translations.checks.view_text_column_user_type_description">
                            <template v-slot:label>
                                {{translations.checks.column_user_type}}
                                <sup v-if="check.roles_id == null" class="has-text-danger">*</sup>
                            </template>
                            <b-select
                                :placeholder="translations.core.view_placeholder_select_option"
                                expanded
                                v-model="check.user_type"
                                :required="check.roles_id == null"
                            >
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
                        </b-field>
                    </div>

                    <div class="column is-4">
                        <div class="field" v-if="check.user_type == 'custom'">
                            <label class="label">{{translations.checks.column_users_id}}<sup class="has-text-danger">*</sup></label>
                            <div class="control">
                                <b-autocomplete
                                    :placeholder="translations.core.view_placeholder_select_option"
                                    v-model="check.user_name"
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
                </div>
            </fieldset>
        </form>
    </div>
</template>
`
