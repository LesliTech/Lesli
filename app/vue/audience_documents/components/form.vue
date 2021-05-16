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


// ·
export default {
    props: {
        base_path: {
            required: true
        },

        audience_document: {
            required: true
        }
    },

    data() {
        return {
            translations: {
                core: I18n.t('core.shared'),
                main: I18n.t('core.template/audience_documents'),
                templates: I18n.t('deutscheleibrenten.templates')
            },
            submitting_form: false,
            options: []
        }
    },

    mounted() {
        this.getOptions()
    },

    methods: {
        submitForm(event){
            if (event) { event.preventDefault() }

            if(this.audience_document.id){
                this.putTemplateAudience()
            }else{
                this.postTemplateAudience()
            }
        },

        getOptions(){
            this.http.get(`/administration/template/documents/options.json`).then(result => {
                if (result.successful) {
                    this.options = result.data
                } else {
                    this.alert(result.error.message,'danger')
                }
            }).catch(error => {
                console.log(error)
            })
        },

        postTemplateAudience() {
            this.submitting_form = true

            let url = this.url.admin(`template/audience_documents`)

            this.http.post(url, { audience_document: this.audience_document }).then(result => {
                this.submitting_form = false

                if (!result.successful) {
                    this.msg.error(result.error.message)
                    return
                }

                this.msg.success(this.translations.main.messages_success_created)


                if (this.base_path) {
                    this.url.go(`${this.base_path}/${result.data.id}`)
                }
            }).catch(error => {
                console.log(error)
            })
        },

        putTemplateAudience() {
            this.submitting_form = true

            let url = this.url.admin('template/audience_documents/:audience_document_id', { audience_document_id: this.audience_document.id})
            this.http.put(url, { audience_document: this.audience_document }).then(result => {
                this.submitting_form = false

                if (!result.successful) {
                    this.msg.error(result.error.message)
                    return
                }

                this.msg.success(this.translations.main.messages_success_updated)
            }).catch(error => {
                console.log(error)
            })
        }
    }
}

</script>
<template>
    <div class="card">
        <div class="card-content">
            <form @submit.prevent="submitForm">
                <fieldset :disabled="submitting_form">
                    <div class="field">
                        <label class="label"> {{ translations.main.column_name }} <sup class="has-text-danger">*</sup></label>
                        <div class="control">
                            <input class="input" type="text" placeholder="" v-model="audience_document.name" required>
                        </div>
                    </div>

                    <div class="field">
                        <label class="label">{{ translations.main.column_model_type }}<sup class="has-text-danger">*</sup></label>
                        <b-select
                            v-model="audience_document.model_type"
                            :disabled="audience_document.id"
                            requireds
                            expanded
                        >
                            <option
                                v-for="(model_type, index) in options.model_types"
                                :value="model_type.value"
                                :key="`${index}-${model_type.value}`"
                            >
                                {{ model_type.text }}
                            </option>
                        </b-select>
                    </div>

                    <div class="field is-grouped">
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
                    </div>
                </fieldset>
            </form>
        </div>
    </div>
</template>
