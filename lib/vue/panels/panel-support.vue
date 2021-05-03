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
import componentRichTextEditor from '../components/forms/richtext-editor.vue'

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
                subject: '',
                description: null
            }
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
            this.submitting = true
            let url = `${this.main_route}.json`

            this.http.post(url, data).then(result => {
                this.submitting = false
                if (result.successful) {
                    this.data.global.show_support_sidebar = false
                    this.msg.success(this.translations.main.messages_info_ticket_created)
                    this.resetForm()
                } else {
                    this.msg.error(result.error.message)
                }
            }).catch(error => {
                console.log(error)
            })
        },

        resetForm(){
            this.ticket.subject = ''
            this.ticket.description = null
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
                }
            }).catch(error => {
                console.log(error)
            })
        }
    },

    watch: {
        'data.global.show_support_sidebar'(){
            // If the component is shown, and hasn't loaded
            if(this.data.global.show_support_sidebar && !this.loaded){
                this.getTicketOptions()
            }
        }
    }

}
</script>
<template>
    <b-sidebar
        :open.sync="data.global.show_support_sidebar"
        class="application-panel-support"
        right
        :can-cancel="['escape']"
        fullheight
        overlay
    >
        <div class="sidebar-content">
            <form @submit="postTicket">
                <h5 class="title is-5">
                    <div class="columns">
                        <div class="column is-10">
                            {{translations.main.view_title_quick_creation}}
                        </div>
                        <div class="column is-2">
                            <button type="button" class="is-pulled-right delete" @click="() => data.global.show_support_sidebar = false">
                            </button>
                        </div>
                    </div>
                </h5>
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
                    <div class="field text-editor-container">
                        <label class="label">{{translations.main.column_description}}</label>
                        <div class="control">
                            <component-rich-text-editor v-model="ticket.description" type="simple">
                            </component-rich-text-editor>
                        </div>
                    </div>
                    <div class="buttons">
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
<style scoped>
.text-editor-container {
    max-height: 20rem;
    overflow-y: auto;
    overflow-x: hidden;
    scrollbar-width: thin;
    scrollbar-color: #cccccc #ffffff;
}
</style>
