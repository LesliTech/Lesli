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
        audienceId: {
            required: true
        },

        source_translation_path: {
            required: true
        },

        active: {
            type: Object,
            default: ()=>{
                return {}
            }
        }
    },
    data() {
        return {
            contacts: [],
            filters: {
                search: ''
            },
            pagination: {
                current_page: 1,
                per_page: 10,
                range_before: 3,
                range_after: 3
            },
            translations: {
                core: I18n.t('core.shared'),
                main: I18n.t('mailer.audiences'),
                contacts: I18n.t('mailer.audience/contacts'),
            },
            loading: false
        }
    },
    mounted() {
        this.data.audiences.getContacts = () => this.getContacts()
    },
    methods: {
        getContacts() {
            this.loading = true

            let url = this.url.mailer(`audiences/${this.audienceId}/contacts`)

            this.http.get(url).then(result => {
                if (result.successful) {

                    this.loading = false
                    this.contacts = result.data.map(e => {
                        return {
                            ...e,
                            source_translated: this.object_utils.translateEnum(this.source_translation_path, 'view_text_table_name', e.source)
                        }
                    })

                } else {
                    this.msg.error(result.error.message)
                }

                this.$set(this.active, 'main_tab', 0)
            }).catch(error => {
                console.log(error)
            })
        },

        deleteAudienceContact(contact){
            let url = this.url.mailer(`audiences/${this.audienceId}/contacts/${contact.id}`)

            this.http.delete(url).then(result => {

                if (result.successful) {
                    this.msg.success(this.translations.main.messages_success_contact_deleted)

                    this.contacts = this.contacts.filter(e => e.id !== contact.id)
                }else{
                    this.msg.error(result.error.message)
                }
            }).catch(error => {
                console.log(error)
            })
        },

        clearSearch(event){
            if(event){
                event.preventDefault()
            }

            this.filters.search = ''
        },

        showContact(contact){
            this.$set(this.active, 'main_tab', 2)
            this.data.selected_audience_contact = contact
        },
    },
    watch: {
        audienceId: function() {
            this.getContacts()
        }
    },
    computed: {
        filteredContacts(){
            this.storage.local("contact_filters", this.filters)
            let search_field = this.filters.search.toLowerCase()

            return this.contacts.filter((contact)=>{
                return (contact.name||'').toLowerCase().includes(search_field.toLowerCase()) ||
                    (contact.email||'').toLowerCase().includes(search_field.toLowerCase()) ||
                    (contact.source_translated||'').toString().toLowerCase().indexOf(search_field.toLowerCase()) >= 0
            })
        }
    },
}
</script>
<template>
    <section>
        <component-data-loading v-if="loading" />
        <component-data-empty v-if="!loading && contacts.length == 0" />

        <template v-if="!loading && contacts.length > 0">
            <div class="box">
                <div class="columns">
                    <div class="column is-full">
                        <b-field>
                            <b-input
                                :placeholder="translations.core.view_placeholder_search"
                                v-model="filters.search"
                                type="text"
                                icon="search"
                                icon-right="close-circle"
                                icon-right-clickable
                                @icon-right-click="clearSearch">
                            </b-input>
                        </b-field>
                    </div>
                </div>

                <b-table
                    :data="filteredContacts"
                    :paginated="true"
                    :per-page="pagination.per_page"
                    :current-page.sync="pagination.current_page"
                    :pagination-simple="false"
                    pagination-position="bottom"
                >
                    <template slot-scope="props">
                        <b-table-column width="30%" field="name" sortable :label="translations.contacts.column_name">
                            {{props.row.name}}
                        </b-table-column>

                        <b-table-column width="30%" field="email" sortable :label="translations.contacts.column_email">
                            {{props.row.email}}
                        </b-table-column>

                        <b-table-column width="20%" field="source" sortable :label="translations.contacts.column_source">
                            {{props.row.source_translated}}
                        </b-table-column>

                        <b-table-column centered width="5%" field="actions" :label="translations.core.view_table_header_actions" class="has-text-right">
                            <b-button type="is-danger" outlined @click.stop="deleteAudienceContact(props.row)">
                                <b-icon size="is-small" icon="trash-alt" />
                            </b-button>
                        </b-table-column>
                    </template>
                </b-table>
            </div>
        </template>
    </section>
</template>
