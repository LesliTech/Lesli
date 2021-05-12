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
            reuired: true
        }
    },
    data() {
        return {
            options: {
                tables: [],
                emails: {},
                filters: {}
            },
            contacts: [],
            current_table: null,
            translations: {
                core: I18n.t('core.shared'),
                main: I18n.t('mailer.audiences'),
                contacts: I18n.t('mailer.audience/contacts'),
            },
            filteredEmails: [],
            submitting_form: false,
            requests: [],
            currentFilters: [],
            filters_selected: {},
            search: null,
            current_data: []
        }
    },
    mounted() {
        this.getOptions()
    },
    methods: {
        submitContacts(event){
            if (event) { event.preventDefault() }

            this.submitting_form = true

            if (this.contacts.length == 0) return

            this.importContacts()
        },

        importContacts(){
            let form = {
                import: {
                    contacts: this.contacts
                }
            }

            let url = this.url.mailer('audiences/:audience_id/resources/import_contacts', { audience_id: this.audienceId})
            this.http.post(url, form).then(result => {
                if (!result.successful) {
                    this.msg.error(result.error.message)
                }

                if (result.data.contacts_not_imported.length > 0){
                    for(let contact of result.data.contacts_not_imported){
                        this.msg.error(contact.errors)
                    }
                }

                this.submitting_form = false

                setTimeout(() => {
                    this.contacts = []

                    this.data.audiences.getContacts()
                    this.msg.info(this.translations.main.messages_info_contacts_import_finished)

                }, (result.data.contacts_not_imported.length||0) * 300)

            }).catch(error => {
                console.log(error)
            })
        },

        getOptions() {
            let url = this.url.mailer('audiences/contacts/options')

            this.http.get(url).then(result => {
                if (!result.successful) {
                    this.msg.error(result.error.message)
                    return
                }

                for(let option of result.data.tables) {
                    this.options.emails[`${option.name}`] = option.data.map(e => {
                        let text = e[`text`]
                        if (!text) text = e[`name`]

                        return {
                            ...e,
                            text: text,
                            source: option.name
                        }
                    })

                    this.options.filters[`${option.name}`] = option.filters||{}

                    this.options.tables.push({
                        value: option.name,
                        text: option.name
                    })
                }
            })
        },

        getFilteredEmails(text) {
            if (text) {
                this.search = text
            }

            let emails = this.current_data.filter((option) => {
                return (option.email||'').toString().toLowerCase().indexOf(text.toLowerCase()) >= 0 ||
                        (option.name||'').toString().toLowerCase().indexOf(text.toLowerCase()) >= 0 ||
                        (option.text||'').toString().toLowerCase().indexOf(text.toLowerCase()) >= 0
            })

            this.filteredEmails = emails
        },

        importAllContacts(){
            this.contacts = this.current_data
        },

        clearForm(){
            this.contacts = []
            this.options = {
                tables: [],
                emails: {}
            }
        }
    },
    watch: {
        current_table(){
            if (this.current_table) {
                this.filters_selected = {}
                this.current_data = this.options.emails[`${this.current_table}`]
                this.currentFilters = this.options.filters[`${this.current_table}`]

                this.filteredEmails = this.current_data

                for(let filter of this.currentFilters) {
                    this.$set(this.filters_selected, filter.field, {value: null, type: filter['type']||null}) // create filters
                }
            }
        },
        'filters_selected': {
            handler(value){
                for(let index in value) {
                    if (value[index]) {
                        this.$set(this.filters_selected, index, value[index]) // create filters
                    }
                }

                this.current_data = this.options.emails[`${this.current_table}`]

                for(let index in this.filters_selected) {
                    let value = this.filters_selected[index]['value']
                    let type = this.filters_selected[index]['type']

                    if (value != null) {
                        if (value == "") {
                            this.current_data = this.current_data // select all
                        } else {
                            switch(type) {
                            case "array":
                                this.current_data = this.current_data.filter((option) => {
                                    return (option[`${index}`]||[]).includes(value)
                                })
                                break;
                            case null:
                                this.current_data = this.current_data.filter((option) => {
                                    return (option[`${index}`]||'').toString().toLowerCase() == value.toLowerCase()
                                })
                                break;
                            }
                        }
                    }
                }

                this.getFilteredEmails(this.search||'')
            },
            deep: true
        }
    }
}

</script>
<template>
    <div class="box">
        <form @submit.prevent="submitContacts()">
            <fieldset :disabled="submitting_form">
                <div class="column is-12">
                    <div class="field is-grouped">
                        <b-field :label="translations.contacts.view_text_select_source">
                            <b-select
                                :placeholder="translations.contacts.view_placeholder_source"
                                v-model="current_table"
                            >
                                <option
                                    v-for="source in options.tables"
                                    :value="source.value"
                                    :key="source.value"
                                >
                                    {{ object_utils.translateEnum(source_translation_path, 'view_text_table_name', source.text ) }}
                                </option>
                            </b-select>
                        </b-field>
                        <template v-for="filter in currentFilters" :label="filter.label">
                            <div class="field">
                                <div class="label">
                                    {{ filter.label }}
                                </div>
                                <div class="control">
                                    <span class="select">
                                        <select v-model="filters_selected[`${filter.field}`]['value']">
                                            <option value=""> {{ translations.contacts.view_text_select_all }} </option>
                                            <option v-for="option in filter.data"
                                                :value="option"
                                            >
                                                {{ option }}
                                            </option>
                                        </select>
                                    </span>
                                </div>
                            </div>
                        </template>
                    </div>
                </div>

                <template v-if="current_table">
                    <b-field :label="translations.contacts.view_text_contacts_entry">
                        <div class="columns">
                            <div class="column is-8">
                                <b-taginput
                                    v-model="contacts"
                                    :data="filteredEmails"
                                    autocomplete
                                    field="email"
                                    :open-on-focus="true"
                                    icon="tag"
                                    :placeholder="translations.core.view_placeholder_search"
                                    @typing="getFilteredEmails">
                                    <template v-slot="props">
                                        <strong> {{props.option.text}} </strong>

                                        <template v-if="props.option.text != props.option.email">
                                            : {{ props.option.email }}
                                        </template>
                                    </template>
                                    <template #empty>
                                        {{ translations.contacts.view_text_email_not_found }}
                                    </template>
                                </b-taginput>
                            </div>

                            <div class="column is-2">
                                <div class="buttons">
                                    <span class="button is-default" @click.stop="importAllContacts">
                                        <b-icon icon="users" size="is-small" />
                                        &nbsp; &nbsp;
                                        {{translations.contacts.view_text_import_all}}
                                    </span>

                                    <span class="button is-default" @click.stop="contacts = []">
                                        <b-icon icon="user-times" size="is-small" />
                                        &nbsp; &nbsp;
                                        {{translations.contacts.view_text_clear_list}}
                                    </span>
                                </div>
                            </div>
                        </div>
                    </b-field>

                    <div class="control">
                        <button class="button is-primary">
                            <span v-if="submitting_form">
                                <b-icon icon="circle-notch" custom-class="fa-spin" size="is-small" />
                                &nbsp;
                                {{translations.core.view_btn_saving}}
                            </span>
                            <span v-else>
                                <b-icon icon="save" size="is-small" />
                                &nbsp;
                                {{translations.core.view_btn_save}}
                            </span>
                        </button>
                    </div>
                </template>
            </fieldset>
        </form>
    </div>
</template>