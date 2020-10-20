<script>
import componenRender from "./render.vue"

export default {
    props: {
        renderComponents: {
            requied: true
        },
        cloudEngine: {
            type: String,
            required: true
        },
        engineNamespace: {
            type: String,
            required: true
        }
    },

    components:{
        'component-render': componenRender
    },

    data() {
        return {
            main_route: `/${this.engineNamespace}/dashboards`,
            options_route: `/${this.engineNamespace}/dashboards/options`,
            translations: {
                main: I18n.t(`${this.cloudEngine.toLowerCase()}.dashboards`),
                components: I18n.t(`${this.cloudEngine.toLowerCase()}.dashboard/components`),
                shared: I18n.t(`${this.cloudEngine.toLowerCase()}.shared`),
                roles: I18n.t(`${this.cloudEngine.toLowerCase()}.users`)
            },
            dashboard_id: null,
            dashboard: {},
            active_tab: 0,
            options: {
                roles: [],
                component_ids: []
            },
            submitting_dashboard: false,
            deleting_dashboard: false,
            unsaved_changes: false,
            deleted_components: [],
            new_component_id: null,
            reload_dashboard_render: false,
            selected_dashboard_component: null,
            default_component_configuration: {
                index: 1,
                layout: 4
            }
        }
    },
    mounted() {
        this.setDashboardId()
        this.getDashboardOptions()
    },
    methods: {
        setDashboardId(){
            if (this.$route.params.id) {
                this.dashboard_id = this.$route.params.id
                this.getDashboard()
            }else{
                this.dashboard = {
                    id: null,
                    name: '',
                    default: false,
                    roles_id: null,
                    components: []
                }
            }
        },

        getDashboard() {
            let url = `${this.main_route}/${this.dashboard_id}.json`

            this.http.get(url).then(result => {
                if (result.successful) {
                    this.dashboard = result.data
                }else{
                    this.alert(result.error.message,'danger')
                }
            }).catch(error => {
                console.log(error)
            })
        },

        notifyUnsavedChanges(){
            if( (!this.unsaved_changes) && this.dashboard_id){
                this.unsaved_changes = true
                this.alert(this.translations.main.messages_warning_save_changes_reminder, 'warning')
            }
        },

        getDashboardOptions(){
            let url = `${this.options_route}.json`

            this.http.get(url).then(result => {
                if (result.successful) {
                    this.options = result.data
                }else{
                    this.alert(result.error.message,'danger')
                }
            }).catch(error => {
                console.log(error)
            })
        },

        addComponentToDashboard(event){
            if(event){
                event.preventDefault()
            }

            this.notifyUnsavedChanges()
            if(this.new_component_id){
                let new_component = {
                    id: `${this.new_component_id}-${this.default_component_configuration.index}`,
                    name: '',
                    component_id: this.new_component_id,
                    layout: this.default_component_configuration.layout,
                    index: this.default_component_configuration.index++,
                    query_configuration: {
                        filters: {},
                        pagination: {}
                    },
                    custom_configuration: {
                        arrangement: {}
                    }
                }
                this.dashboard.components.push(new_component)
                this.selectDashboardComponent(new_component)

                this.$nextTick(()=>{
                    this.new_component_id = null
                })
            }
        },

        removeComponentFromDashboard(deleted_component){
            this.notifyUnsavedChanges()
            this.dashboard.components = this.dashboard.components.filter((component)=> {
                return component.id != deleted_component.id
            })

            // We check if the component id is a real number. If it is, de stage it to delete it when saved
            if(! isNaN(deleted_component.id)){
                deleted_component._destroy = true
                this.deleted_components.push(deleted_component)
            }

            this.selected_dashboard_component = null
        },

        selectDashboardComponent(selected_component){
            if(this.dashboard.components.find( component => component.id == selected_component.id)){
                this.selected_dashboard_component = selected_component
            }
        },

        deleteDashboard(){
            this.deleting_dashboard = true
            let url = `${this.main_route}/${this.dashboard_id}.json`

            this.http.delete(url).then(result => {
                this.deleting_dashboard = false
                if (result.successful) {
                    this.alert(this.translations.main.messages_info_dashboard_deleted, 'success')
                    this.$router.push('/')
                } else {
                    this.alert(result.error.message,'danger')
                }
            }).catch(error => {
                console.log(error)
            })
        },

        submitDashboard(event){
            if(event){
                event.preventDefault()
            }

            if(this.dashboard_id){
                this.putDashboard()    
            }else{
                this.postDashboard()
            }

        },

        postDashboard(){
            this.submitting_dashboard = true
            let data = {
                dashboard: {
                    name: this.dashboard.name,
                    default: this.dashboard.default,
                    roles_id: this.dashboard.roles_id,
                    components_attributes: this.dashboard.components.map((component)=>{
                        let parsed_component = {...component}
                        parsed_component.id = null

                        return parsed_component
                    })
                }
            }

            this.http.post(this.main_route, data).then(result => {
                this.submitting_dashboard = false
                if (result.successful) {
                    this.alert(this.translations.main.messages_info_dashboard_created, 'success')
                    this.$router.push(`/${result.data.id}`)
                }else{
                    this.alert(result.error.message,'danger')
                }
            }).catch(error => {
                console.log(error)
            })
        },

        putDashboard(){
            let data = {
                dashboard: {
                    name: this.dashboard.name,
                    default: this.dashboard.default,
                    roles_id: this.dashboard.roles_id,
                    components_attributes: this.dashboard.components.map((component)=>{
                        let parsed_component = {...component}
                        // We check if the id is a valid integer or a placeholder. If it is a placeholder, we set it to null
                        if(isNaN(parsed_component.id)){
                            parsed_component.id = null
                        }

                        return parsed_component
                    })
                }
            }
            data.dashboard.components_attributes = data.dashboard.components_attributes.concat(this.deleted_components)
            this.submitting_dashboard = true

            this.http.put(`${this.main_route}/${this.dashboard_id}`, data).then(result => {
                this.submitting_dashboard = false
                this.unsaved_changes = false
                if (result.successful) {
                    this.alert(this.translations.main.messages_info_dashboard_updated, 'success')
                    this.deleted_components = []
                    // We assign the ids of the components that were created
                    result.data.components.forEach((component)=>{
                        let local_component = this.dashboard.components.find((local_component)=>{
                            return local_component.name == component.name
                        })
                        this.$set(local_component, 'id', component.id)
                        this.reload_dashboard_render = true
                    })
                }else{
                    this.alert(result.error.message,'danger')
                }
            }).catch(error => {
                console.log(error)
            })
        }
    }
}
</script>
<template>
    <div class="card" v-if="dashboard">
        <div class="card-header">
            <h2 class="card-header-title">
                <span v-if="dashboard.name">
                    {{dashboard.name}}
                </span>
                <span v-else>
                    {{translations.main.view_title_new}}
                </span>
            </h2>
            <div class="card-header-icon">
                <router-link to="/">
                    &nbsp;&nbsp;&nbsp;
                    <i class="fas fa-undo"></i>
                    {{translations.shared.btn_return}}
                </router-link>
            </div>
        </div>
        <div class="card-content">
            <b-tabs v-model="active_tab">
                <b-tab-item :label="translations.main.view_tab_title_edition">
                    <form id="form-dashboard" @submit="submitDashboard">
                        <div class="columns">
                            <div class="column is-7">
                                <b-field >
                                    <template slot="label">
                                        {{translations.main.column_name}}<sup class="has-text-danger">*</sup>
                                    </template>
                                    <b-input
                                        v-model="dashboard.name"
                                        type="text"
                                         @change.native="notifyUnsavedChanges"
                                        required
                                    />
                                </b-field>
                            </div>
                            <div class="column is-3">
                                <b-field :label="translations.main.column_roles_id">
                                    <b-select :placeholder="translations.shared.text_select_option" expanded v-model="dashboard.roles_id" @change.native="notifyUnsavedChanges">
                                        <option v-for="role in options.roles" :key="role.value" :value="role.value">
                                            {{object_utils.translateEnum(translations.roles, 'enum_role', role.text)}}
                                        </option>
                                    </b-select>
                                </b-field>
                            </div>
                            <div class="column is-2">
                                <b-field :label="translations.main.column_default">
                                    <b-select :placeholder="translations.shared.text_select_option" expanded v-model="dashboard.default"  @change.native="notifyUnsavedChanges">
                                        <option :value="true">{{translations.shared.text_yes}}</option>
                                        <option :value="false">{{translations.shared.text_no}}</option>
                                    </b-select>
                                </b-field>
                            </div>
                        </div>
                        <hr>
                        <div class="columns">
                            <div class="column is-5">
                                <h6 class="title is-6">
                                    {{translations.main.view_title_add_component}}
                                </h6>
                                <form @submit="addComponentToDashboard">
                                    <div class="columns">
                                        <div class="column is-12">
                                            <b-select
                                                :placeholder="translations.shared.text_select_option"
                                                expanded
                                                required
                                                v-model="new_component_id"
                                                @change.native="addComponentToDashboard"
                                            >
                                                <option v-for="component_id in options.component_ids" :key="component_id.value" :value="component_id.value">
                                                {{object_utils.translateEnum(translations.main, 'column_enum_component_id', component_id.text)}}
                                            </option>
                                            </b-select>
                                        </div>
                                    </div>
                                </form>
                                <hr>
                                <div class="menu-list is-hoverable">
                                    <a
                                        v-for="(component, index) in dashboard.components"
                                        :key="index"
                                        @click="selectDashboardComponent(component)"
                                        :class="['list-item', {'is-active': (selected_dashboard_component && component.id == selected_dashboard_component.id) }]"
                                    >
                                        {{object_utils.translateEnum(translations.main, 'column_enum_component_id', component.component_id)}}
                                        <button type="button" class="delete is-small is-pulled-right" @click="removeComponentFromDashboard(component)">
                                        </button>
                                    </a>
                                </div>
                                <br>
                            </div>
                            <div class="column is-7">
                                <h6 class="title is-6">
                                    {{translations.main.view_title_component_configuration}}
                                </h6>
                                <div v-if="selected_dashboard_component">
                                    <div class="columns is-multiline">
                                        <div class="column is-12">
                                            <b-field
                                                :label="translations.components.column_name"
                                            >
                                                <b-input
                                                    type="text"
                                                    v-model="selected_dashboard_component.name"
                                                    @change.native="notifyUnsavedChanges"
                                                >
                                                </b-input>
                                            </b-field>
                                        </div>
                                        <div class="column is-6">
                                            <b-field
                                                :label="translations.components.column_number"
                                                :message="translations.components.view_text_column_number_description"
                                            >
                                                <b-input
                                                    type="number"
                                                    step="1"
                                                    min="0"
                                                    v-model="selected_dashboard_component.index"
                                                    @change.native="notifyUnsavedChanges"
                                                >
                                                </b-input>
                                            </b-field>
                                        </div>
                                        <div class="column is-6">
                                            <b-field
                                                :label="translations.components.column_layout"
                                                :message="translations.components.view_text_column_layout_description"
                                            >
                                                <b-select
                                                    :placeholder="translations.shared.text_select_option"
                                                    v-model="selected_dashboard_component.layout"
                                                    expanded
                                                    @change.native="addComponentToDashboard"
                                                >
                                                    <option :value="1">8.3%</option>
                                                    <option :value="2">16.7%</option>
                                                    <option :value="3">25%</option>
                                                    <option :value="4">33.3%</option>
                                                    <option :value="5">41.7%</option>
                                                    <option :value="6">50%</option>
                                                    <option :value="7">58.3%</option>
                                                    <option :value="8">66.7%</option>
                                                    <option :value="9">75%</option>
                                                    <option :value="10">83.3%</option>
                                                    <option :value="11">91.7%</option>
                                                    <option :value="12">100%</option>
                                                </b-select>
                                            </b-field>
                                        </div>
                                        <div
                                            class="column is-6"
                                            v-for="(option, index) in options.components_configuration_options[selected_dashboard_component.component_id]"
                                            :key="`query-${index}`"
                                        >
                                            <b-field
                                                v-if="option.type == 'Boolean'"
                                                :label="translations.components[`column_configuration_${option.name}`]"
                                                :message="translations.components[`view_text_column_configuration_${option.name}_description`]"
                                            >
                                                <div class="block">
                                                    <b-radio
                                                        size="is-small"
                                                        v-model="selected_dashboard_component[option.column][option.group][option.name]"
                                                        :native-value="true"
                                                        @change.native="notifyUnsavedChanges"
                                                    >
                                                        {{translations.shared.text_yes}}
                                                    </b-radio>
                                                    <b-radio
                                                        size="is-small"
                                                        v-model="selected_dashboard_component[option.column][option.group][option.name]"
                                                        :native-value="false"
                                                        @change.native="notifyUnsavedChanges"
                                                    >
                                                        {{translations.shared.text_no}}
                                                    </b-radio>
                                                </div>
                                            </b-field>
                                            <b-field
                                                v-if="option.type == 'Integer'"
                                                :label="translations.components[`column_configuration_${option.name}`]"
                                                :message="translations.components[`view_text_column_configuration_${option.name}_description`]"
                                            >
                                                <b-input
                                                    type="number"
                                                    step="1"
                                                    min="0"
                                                    v-model="selected_dashboard_component[option.column][option.group][option.name]"
                                                    @change.native="notifyUnsavedChanges"
                                                >
                                                </b-input>
                                            </b-field>
                                        </div>
                                    </div>
                                </div>
                                <div v-else>
                                    <br>
                                    <br>
                                    <br>
                                    <h6 class="title is-6 has-text-grey-light">
                                        {{translations.components.view_text_please_select_component_to_edit}}
                                    </h6>
                                </div>
                            </div>
                        </div>
                    </form>
                </b-tab-item>
                <b-tab-item :label="translations.main.view_tab_title_render" v-if="dashboard_id">
                    <component-render
                        :dashboard-id="dashboard_id"
                        :reload.sync="reload_dashboard_render"
                        :components="renderComponents"
                        :cloud-engine="cloudEngine"
                        :engine-namespace="engineNamespace"
                    >
                    </component-render>
                </b-tab-item>
                <b-tab-item :label="translations.main.view_tab_title_delete" v-if="dashboard_id">
                    <span class="has-text-danger">
                        {{translations.main.messages_danger_delete_confirmation}}
                    </span>
                    <br>
                    <br>
                    <div class="buttons">
                        <b-button expanded class="is-danger submit-button" :disabled="deleting_dashboard || dashboard.default" @click="deleteDashboard">
                                <span v-if="deleting_dashboard">
                                    <i  class="fas fa-circle-notch fa-spin"></i>
                                    {{translations.main.view_btn_deleting_dashboard}}
                                </span>
                                <span v-else>
                                    <i  class="fas fa-trash-alt"></i>
                                    {{translations.main.view_btn_delete_dashboard}}
                                </span>
                        </b-button>
                    </div>
                </b-tab-item>
            </b-tabs>
            <div v-if="active_tab != 2" class="buttons">
                <b-button type="is-primary" expanded native-type="submit" form="form-dashboard" class="submit-button" :disabled="submitting_dashboard">
                    <span v-if="submitting_dashboard">
                        <i  class="fas fa-circle-notch fa-spin"></i>
                        {{translations.main.view_btn_saving_dashboard}}
                    </span>
                    <span v-else>
                            {{translations.main.view_btn_save_dashboard}}
                    </span>
                    
                </b-button>
            </div>
        </div>
    </div>
</template>
