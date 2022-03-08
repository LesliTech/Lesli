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
import componentRichTextEditor from '../components/editors/richtext.vue'

// ·


// ·
export default {
    components: {
        'component-rich-text-editor': componentRichTextEditor
    },

    data(){
        return {
            main_route: '/help/tickets',
            submitting: false,
            loaded: false,
            translations: {
                main: I18n.t('help.tickets'),
                core: I18n.t('core.shared')
            },
            options: {
                types: [],
                categories: [],
                priorities: []
            },
            ticket: {
                cloud_help_catalog_ticket_types_id: null,
                cloud_help_catalog_ticket_workspaces_id: null,
                subject: '',
                description: {},
                reference_url: null
            },
            tickets: [],
            loading: false
        }
    },

    methods: {
        postTicket(event){
            if(event){
                event.preventDefault()
            }
            // We deep copy the object so description changes to data will not affect this.ticket
            let data = {
                ticket: JSON.parse(JSON.stringify(this.ticket))
            }
            data.ticket.description = JSON.stringify(data.ticket.description)
            data.ticket.reference_url = window.location.href
            this.submitting = true
            let url = `${this.main_route}.json`

            this.http.post(url, data).then(result => {
                this.submitting = false
                if (result.successful) {
                    this.msg.success(this.translations.main.messages_info_ticket_created)
                    this.resetForm()
                } else {
                    this.msg.error(result.error.message)
                }
            }).catch(error => {
                console.log(error)
            }).finally(()=>{
                this.data.global.show_panel_support = false
            })
        },

        resetForm(){
            this.ticket.subject = ''
            this.ticket.description = {}
        },

        getTicketOptions() {
            this.loaded = true
            let url = `${this.main_route}/options.json`

            this.http.get(url).then(result => {
                if (result.successful) {
                    this.options = result.data

                    if(this.options.types.length > 0){
                        this.ticket.cloud_help_catalog_ticket_types_id = this.options.types[0].id
                    }

                    if(this.options.workspaces.length > 0){
                        let default_workspace = this.options.workspaces.find(workspace => workspace.default)
                        this.ticket.cloud_help_catalog_ticket_workspaces_id = default_workspace.id
                    }
                }
            }).catch(error => {
                console.log(error)
            })
        },

        getLatestTickets(){
            this.loading = true

            let url = this.url.help('tickets').order(
                'id',
                'desc'
            ).paginate(
                1,
                3
            ).filters({
                search_type: 'active',
                user_type: 'own'
            })

            this.http.get(url).then(result => {
                if (result.successful) {
                    this.tickets = result.data.tickets
                }else{
                    this.msg.error(result.error.message)
                }
            }).catch(error => {
                console.log(error)
            }).finally(()=>{
                this.loading = false
            })
        },

        showTicket(ticket){
            this.url.go(`/help/tickets/${ticket.id}`)
        }
    },

    watch: {
        'data.global.show_panel_support'() {
            // If the component is shown, and hasn't loaded
            if(this.data.global.show_panel_support){
                this.getLatestTickets()

                if(!this.loaded){
                    this.getTicketOptions()
                }
            }

        }
    }

}
</script>
<template>
    <b-sidebar
        class="application-panel-support"
        :open.sync="data.global.show_panel_support"
        :right="true"
        :fullheight="true">
        <div class="panel-title is-size-5">
            <h4>
                {{ translations.main.view_text_support_tickets }}
            </h4>
            <span class="icon is-large hover" @click="data.global.show_panel_support = false">
                <i class="fas fa-lg fa-chevron-right"></i>
            </span>
        </div>

        <div class="panel-content">
            <template  v-if="loading || tickets.length > 0">
                <h6 class="title is-6">{{ translations.main.view_title_latest_tickets }}</h6>
                <component-data-loading v-if="loading"></component-data-loading>
                <component-data-empty v-if="! loading && tickets.length == 0"></component-data-empty>
                <b-table v-if="! loading && tickets.length > 0" :data="tickets" striped narrowed bordered @click="showTicket" hoverable>
                    <template slot-scope="props">
                        <b-table-column field="subject" :label="translations.main.column_subject" >
                            <a :href="`/help/tickets/${props.row.id}`">
                                <small>{{ props.row.subject }}</small>
                            </a>
                        </b-table-column>
                        <b-table-column field="status_name" :label="translations.main.column_cloud_help_workflow_statuses_id">
                            <a :href="`/help/tickets/${props.row.id}`">
                                <small>{{object_utils.translateEnum(translations.core, 'column_enum_status', props.row.status_name)}}</small>
                            </a>
                        </b-table-column>
                    </template>
                </b-table>
                <div class="is-divider"></div>
            </template>

            <h6 class="title is-6">{{translations.main.view_title_quick_creation}}</h6>
            <form @submit="postTicket">
                <fieldset :disabled="submitting">
                    <b-field>
                        <template v-slot:label>
                            {{translations.main.column_subject}} <sup class="has-text-danger">*</sup>
                        </template>
                        <b-input type="text" required v-model="ticket.subject">
                        </b-input>
                    </b-field>
                    <b-field>
                        <template v-slot:label>
                            {{translations.main.column_cloud_help_catalog_ticket_types_id}}<sup class="has-text-danger">*</sup>
                        </template>
                        <b-select
                            :placeholder="translations.core.view_placeholder_select_option"
                            expanded
                            required
                            v-model="ticket.cloud_help_catalog_ticket_types_id"
                        >
                            <option
                                v-for="type in options.types"
                                :key="type.id"
                                :value="type.id"
                            >
                                {{type.name}}
                            </option>
                        </b-select>
                    </b-field>
                    <b-field :label="translations.main.column_cloud_help_catalog_ticket_workspaces_id">
                        <b-select
                            :placeholder="translations.core.view_placeholder_select_option"
                            expanded
                            v-model="ticket.cloud_help_catalog_ticket_workspaces_id"
                        >
                            <option
                                v-for="workspace in options.workspaces"
                                :key="workspace.id"
                                :value="workspace.id"
                            >
                                {{workspace.name}}
                            </option>
                        </b-select>
                    </b-field>
                    <div class="field text-editor-container">
                        <label class="label">{{translations.main.column_description}}</label>
                        <div class="control">
                            <component-rich-text-editor v-model="ticket.description" mode="simple">
                            </component-rich-text-editor>
                        </div>
                    </div>
                    <div class="field">
                        <b-button class="submit-button" type="is-primary" native-type="submit" expanded :disabled="submitting">
                            <span v-if="submitting">
                                <b-icon icon="circle-notch" custom-class="fa-spin" size="is-small">
                                </b-icon>
                                <span>{{translations.core.view_btn_saving}}</span>
                            </span>
                            <span v-else>
                                <b-icon icon="save" size="is-small">
                                </b-icon>
                                <span>{{translations.core.view_btn_save}}</span>
                            </span>
                        </b-button>
                    </div>
                </fieldset>
            </form>
        </div>
    </b-sidebar>
</template>
<style>
.text-editor-container {
    max-height: 20rem;
    overflow-y: auto;
    overflow-x: hidden;
    scrollbar-width: thin;
    scrollbar-color: #cccccc #ffffff;
}
.is-divider {
    display: block;
    position: relative;
    border-top: .1rem solid #dbdbdb;
    height: .1rem;
    margin: 1.1rem 0;
    text-align: center;
}
section.component-data-empty div {
    padding: 0.1rem;
}
</style>
