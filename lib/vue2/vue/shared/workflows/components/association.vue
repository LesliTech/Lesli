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
        engineNamespace: {
            type: String,
            required: true
        },
        workflowId: {
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
            options_endpoint: '',
            translations: {
                core: I18n.t('core.shared'),
                associations: I18n.t('core.workflow/associations')
            },
            endpoint: '',
            associations: [],
            association_options: [],
            new_association: {
                workflow_for: null,
                global: false
            },
            submitting: false
        }
    },

    mounted(){
        this.setEndpoints()
        this.setTranslations()
        this.getAssociationOptions()
        this.getAssociations()
    },

    methods: {
        setEndpoints(){
            if(this.engineNamespace == '/'){
                this.options_endpoint = `/workflows/associations/options`
                this.endpoint = `/workflows/${this.workflowId}/associations`
            }else{
                this.options_endpoint = `/${this.engineNamespace}/workflows/associations/options`
                this.endpoint = `/${this.engineNamespace}/workflows/${this.workflowId}/associations`
            }
        },

        setTranslations(){
            this.$set(this.translations, 'main', I18n.t(this.translationsPath))
        },

        getAssociations(){
            let url = `${this.endpoint}.json`

            this.http.get(url).then(result => {
                if (result.successful) {
                    this.associations = result.data
                }else{
                    this.msg.error(result.error.message)
                }
            }).catch(error => {
                console.log(error)
            })
        },

        getAssociationOptions(){
            this.http.get(`${this.options_endpoint}.json`).then(result => {
                if (result.successful) {
                    this.association_options = result.data
                }else{
                    this.msg.error(result.error.message)
                }
            }).catch(error => {
                console.log(error)
            })
        },

        postAssociation(event){
            if(event){
                event.preventDefault()
            }

            let data = {
                workflow_association: this.new_association
            }
            this.submitting = true

            this.http.post(`${this.endpoint}.json`, data).then(result => {
                if (result.successful) {
                    this.getAssociations()
                    this.msg.success(this.translations.associations.messages_success_association_created)
                    this.clearNewAssociation()
                }else{
                    this.msg.error(result.error.message)
                }
            }).catch(error => {
                console.log(error)
            }).finally(()=>{
                this.submitting = false
            })
        },

        deleteExtraAssociationFields(){
            if(this.new_association.global){
                for(let key in this.new_association){
                    if(key == 'global' || key == 'workflow_for'){
                        continue
                    }
                    delete this.new_association[key]
                }
            }
        },

        clearNewAssociation(){
            this.new_association = {
                global: true,
                workflow_for: null
            }
            this.deleteExtraAssociationFields()
        },

        confirmAssociationDeletion(association){
            this.$buefy.dialog.confirm({
                title: this.translations.associations.messages_danger_delete_confirmation_title,
                message: this.translations.associations.messages_danger_delete_confirmation_body,
                cancelText: this.translations.core.view_btn_cancel,
                confirmText: this.translations.core.view_btn_accept,
                type: 'is-danger',
                onConfirm: () => {
                    this.deleteAssociation(association)
                }
            })
        },

        deleteAssociation(association){
            let url = `${this.endpoint}/${association.id}`
            this.http.delete(url).then(result => {
                if (result.successful) {
                    this.getAssociations()
                    this.msg.success(this.translations.associations.messages_info_association_deleted)
                }else{
                    this.msg.error(result.error.message)
                }
            }).catch(error => {
                console.log(error)
            })
        },
    },

    computed: {
        detailedAssociationsAvailable(){
            let selected_association = this.association_options.find((association) =>{
                return association.workflow_for == this.new_association.workflow_for
            })

            if(! selected_association){
                return false
            }

            if(selected_association.details.length > 0){
                return true
            }else{
                this.new_association.global = true
                return false
            }
        },

        selectedAssociation(){
            let selected_association = this.association_options.find((association) =>{
                return association.workflow_for == this.new_association.workflow_for
            })

            if(selected_association){
                return selected_association
            }else{
                return {
                    details: []
                }
            }
        }
    }
}
</script>
<template>
    <div v-if="translations.main">
        <h5 class="title is-5">{{translations.associations.view_title_main}}</h5>
        <form @submit="postAssociation">
            <div class="columns">
                <div class="column is-3">
                    <b-field :message="translations.associations.view_text_column_workflow_for_description">
                        <template v-slot:label>
                            {{translations.associations.view_title_assign_to}}
                            <sup class="has-text-danger">*</sup>
                        </template>
                        <b-select expanded :placeholder="translations.associations.view_placeholder_select_resource" v-model="new_association.workflow_for" required>
                            <option
                                v-for="association in association_options"
                                :key="association.workflow_for"
                                :value="association.workflow_for"
                            >
                                {{object_utils.translateEnum(translations.main, 'column_enum_association', association.name)}}
                            </option>
                        </b-select>
                    </b-field>
                </div>
                <div class="column is-3">
                    <b-field v-if="new_association.workflow_for" :label="translations.associations.column_global">
                        <template v-slot:message>
                            <span v-if="detailedAssociationsAvailable">
                                {{translations.associations.view_text_specific_options_available}}
                            </span>
                            <span v-else>
                                {{translations.associations.view_text_only_global_option_available}}
                            </span>
                        </template>
                        <b-checkbox
                            v-model="new_association.global"
                            :disabled="! detailedAssociationsAvailable"
                            @change.native="deleteExtraAssociationFields"
                        >
                            <span v-if="new_association.global"> {{translations.core.view_text_yes}} </span>
                            <span v-else> {{translations.core.view_text_no}} </span>
                        </b-checkbox>
                    </b-field>
                </div>
                <div class="column is-3">
                    <div v-if="! new_association.global">
                        <b-field
                            v-for="detail in selectedAssociation.details"
                            :key="detail.field_name"
                            :label="object_utils.translateEnum(translations.main, `column_enum_association_${selectedAssociation.name}_field`, detail.name)"
                            :message="translations.main[`view_text_association_${selectedAssociation.name}_field_${detail.name}`]"
                        >
                            <b-select
                                expanded
                                :placeholder="translations.core.view_placeholder_select_option"
                                v-model="new_association[detail.field_name]"
                            >
                                <option
                                    v-for="row in detail.list"
                                    :key="row.id"
                                    :value="row.id"
                                >
                                    {{object_utils.translateEnum(translations.main, `column_enum_association_${selectedAssociation.name}_field_${detail.name}`, row.name)}}
                                </option>
                            </b-select>
                        </b-field>
                    </div>
                </div>
            </div>
            <b-field>
                <b-button expanded type="is-primary" native-type="submit" :disabled="submitting">
                    <span v-if="submitting">
                        <b-icon icon="circle-notch" custom-class="fa-spin" size="is-small"></b-icon>
                        <span>{{translations.core.view_btn_saving}}</span>
                        
                    </span>
                    <span v-else>
                        <b-icon icon="save" size="is-small"></b-icon>
                        <span>{{translations.core.view_btn_save}}</span>
                    </span>
                </b-button>
            </b-field>
        </form>
        <hr>

        <b-table v-if="associations.length > 0" :data="associations">
            <template slot-scope="props">
                <b-table-column field="workflow_for" :label="translations.associations.column_workflow_for">
                    {{ object_utils.translateEnum(translations.main, 'column_enum_association', props.row.workflow_for) }}
                </b-table-column>
                <b-table-column field="global" :label="translations.associations.column_global">
                    <span v-if="props.row.global">
                        {{translations.core.view_text_yes}}
                    </span>
                    <span v-else>
                        {{translations.core.view_text_no}}
                    </span>
                </b-table-column>
                <b-table-column field="details" :label="translations.associations.view_table_header_details">
                    {{props.row.details}}
                </b-table-column>
                <b-table-column field="close" label="">
                    <a class="delete is-small" role="button" @click="confirmAssociationDeletion(props.row)"></a>
                </b-table-column>
            </template>
        </b-table>
        <span v-else class="has-text-grey">
            {{translations.associations.view_text_no_associations_set}}
        </span>
    </div>
</template>
