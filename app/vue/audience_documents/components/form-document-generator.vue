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
        audience_document: {
            required: true
        },
        base_translation_path: {
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
            references: [],
            current_table: null,
            translations: {
                core: I18n.t('core.shared'),
                main: I18n.t('core.template/audience_documents'),
                references: I18n.t('core.template/audience_references'),
            },
            filteredData: [],
            submitting_form: false,
            requests: [],
            currentFilters: [],
            filters_selected: {},
            search: null,
            current_data: [],
            template_documents: [],
            template_documents_options: {
                id: null,
                model_type: '',
            }
        }
    },
    mounted() {
        this.getOptions()
        this.getTemplateDocuments()
    },
    methods: {
        submitAudienceDocument(event){
            if (event) { event.preventDefault() }

            let form = {
                ids: this.references.map(e => e.id),
                template_document_id: this.template_documents_options.id
            }

            let url = this.url.admin('template/audience_documents/:audience_document_id/resources/generate_file', { audience_document_id: this.audience_document.id})
            this.http.post(url, form).then(result => {
                this.submitting_form = false

                if (!result.successful) {
                    this.msg.error(result.error.message)
                    return

                }

                this.msg.info(this.translations.main.messages_info_generating_document)

                this.$router.push("/")
            }).catch(error => {
                console.log(error)
            })
        },

        getOptions() {
            let url = this.url.admin('template/audience_documents/options')

            this.http.get(url).then(result => {
                if (!result.successful) {
                    this.msg.error(result.error.message)
                    return
                }

                let table_options = result.data.tables.filter(e => e.model_type === this.audience_document.model_type)

                for(let option of table_options) {
                    this.options.emails[`${option.name}`] = option.data.map(e => {
                        return {
                            ...e,
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

            this.filteredData = emails
        },

        importAllReferences(){
            this.references = this.references.concat(this.current_data)
        },

        clearForm(){
            this.references = []
            this.options = {
                tables: [],
                emails: {}
            }
        },

        getTemplateDocuments(){
            let url = this.url.admin(`template/documents`)
            url.filters = { model_type: this.audience_document.model_type}

            this.http.get(url).then(result => {

                if (result.successful) {
                    this.template_documents = result.data
                }else{
                    this.alert(result.error.message,'danger')
                }
            }).catch(error => {
                console.log(error)
            })
        }
    },
    watch: {

        current_table(){
            if (this.current_table) {
                this.filters_selected = {}
                this.current_data = this.options.emails[`${this.current_table}`]
                this.currentFilters = this.options.filters[`${this.current_table}`]

                this.filteredData = this.current_data

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
    <form @submit.prevent="submitAudienceDocument">
        <fieldset :disabled="submitting_form">
            <div class="field is-grouped">
                <b-field :label="translations.main.view_text_select_source">
                    <b-select
                        :placeholder="translations.main.view_placeholder_source"
                        v-model="current_table"
                    >
                        <option
                            v-for="source in options.tables"
                            :value="source.value"
                            :key="source.value"
                        >
                            {{ object_utils.translateEnum(base_translation_path, 'view_text', source.text ) }}
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
                                    <option value=""> {{ translations.main.view_text_select_all }} </option>
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

                <div class="buttons buttons-box">
                    <span class="button is-default" @click.stop="importAllReferences">
                        <b-icon icon="users" size="is-small" />
                        &nbsp; &nbsp;
                        {{translations.main.view_text_select_all}}
                    </span>

                    <span class="button is-default" @click.stop="references = []">
                        <b-icon icon="user-times" size="is-small" />
                        &nbsp; &nbsp;
                        {{translations.main.view_text_clear_list}}
                    </span>
                </div>
            </div>

            <template v-if="current_table">
                <div class="field">
                    <label class="label">
                        {{ translations.main.view_text_records }} {{ `(${filteredData.length} / ${(options.emails[`${this.current_table}`]||[]).length})` }}
                        <sup class="has-text-danger">*</sup>
                    </label>
                    <div class="columns">
                        <div class="column is-12">
                            <b-taginput
                                v-model="references"
                                :data="filteredData"
                                autocomplete
                                field="text"
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
                                    {{ translations.main.view_text_records_not_found }}
                                </template>
                            </b-taginput>
                        </div>
                    </div>
                </div>

                <div class="field">
                    <label class="label"> {{ 'Template'}} <sup class="has-text-danger">*</sup> </label>
                    <div class="control">
                        <b-select expanded :placeholder="translations.main.text_select_option" v-model="template_documents_options.id" required>
                            <option v-for="template_document in template_documents" :key="template_document.id" :value="template_document.id">
                                {{(
                                    template_document.name
                                )}}
                            </option>
                        </b-select>
                    </div>
                </div>

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
</template>