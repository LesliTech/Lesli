<script>
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
                global: true
            }
        }
    },

    mounted(){
        this.setEndpoints()
        this.setTranslations()
        this.mountSubscriptions()
        this.getAssociationOptions()
        this.getAssociations()
    },

    methods: {
        setEndpoints(){
            this.options_endpoint = `/${this.engineNamespace}/workflows/associations/options`
            this.endpoint = `/${this.engineNamespace}/workflows/${this.workflowId}/associations`
        },

        setTranslations(){
            this.$set(this.translations, 'main', I18n.t(this.translationsPath))
        },

        mountSubscriptions(){
            this.bus.subscribe('show:/module/workflows/association', () => {
                this.show = ! this.show
            })
        },

        getAssociations(){
            let url = `${this.endpoint}.json`

            this.http.get(url).then(result => {
                if (result.successful) {
                    this.associations = result.data
                }else{
                    this.alert(result.error.message,'danger')
                }
            }).catch(error => {
                console.log(error)
            })
        },

        getAssociationOptions(){
            this.http.get(this.options_endpoint).then(result => {
                if (result.successful) {
                    this.association_options = result.data
                }else{
                    this.alert(result.error.message,'danger')
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

            this.http.post(this.endpoint, data).then(result => {
                if (result.successful) {
                    this.getAssociations()
                    this.alert(this.translations.associations.messages_success_association_created, 'success')
                    this.clearNewAssociation()
                }else{
                    this.alert(result.error.message,'danger')
                }
            }).catch(error => {
                console.log(error)
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

        deleteAssociation(association){
            let url = `${this.endpoint}/${association.id}`
            this.http.delete(url).then(result => {
                if (result.successful) {
                    this.getAssociations()
                    this.alert(this.translations.associations.messages_info_association_deleted, 'success')
                }else{
                    this.alert(result.error.message,'danger')
                }
            }).catch(error => {
                console.log(error)
            })
        }
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
    <section v-if="translations.main">
        <div :class="[{ 'is-active': show }, 'quickview', 'is-size-medium']">
            <header class="quickview-header" @click="show = false">
                <p class="title">{{translations.associations.view_title_main}}</p>
                <i class="fas fa-chevron-right"></i>
            </header>
            <div class="quickview-body">
                <div class="quickview-block">
                    <div class="section">
                        <form @submit="postAssociation">
                            <b-field :label="translations.associations.view_title_assign_to">
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
                            <div class="field" v-if="new_association.workflow_for">
                                <b-checkbox
                                    v-model="new_association.global"
                                    :disabled="! detailedAssociationsAvailable"
                                    @change.native="deleteExtraAssociationFields"
                                >
                                    {{translations.associations.column_global}}
                                </b-checkbox>
                            </div>
                            <div v-if="! new_association.global">
                                <b-field
                                    v-for="detail in selectedAssociation.details"
                                    :key="detail.field_name"
                                    :label="object_utils.translateEnum(translations.main, `column_enum_association_${selectedAssociation.name}_field`, detail.name)"
                                >
                                    <b-select
                                        required
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
                            <hr>
                            <b-field>
                                <b-button expanded type="is-primary" native-type="submit">
                                    {{translations.core.view_btn_save}}
                                </b-button>
                            </b-field>
                        </form>
                        <b-table :data="associations">
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
                                    <a class="delete is-small" role="button" @click="deleteAssociation(props.row)"></a>
                                </b-table-column>
                            </template>
                        </b-table>
                    </div>
                </div>
            </div>
            <footer class="quickview-footer">
            </footer>
        </div>
    </section>
</template>
