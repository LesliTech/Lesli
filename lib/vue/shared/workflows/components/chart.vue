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


// · Library List
// · ~·~     ~·~     ~·~     ~·~     ~·~     ~·~     ~·~     ~·~     ~·~     ~·~     ~·~     ~·~
import Vue from 'vue'
import VueMermaid from 'vue-mermaid'
Vue.use(VueMermaid)

export default {
    props: {
        engineNamespace: {
            type: String,
            required: true
        },
        workflowId: {
            default: null,
        },
        workflow: {
            default: null
        },
        rerender: {
            type: Boolean,
            default: false
        },
        translationsPath: {
            type: String,
            default: null
        }
    },
    data(){
        return {
            main_route: null,
            parsed_workflow: [],
            workflow_data: null,
            translations: {
                workflows: I18n.t('core.workflows'),
                core: I18n.t('core.shared')
            },
            selected_status_id: null
        }
    },
    mounted(){
        this.setCloudParams()
        this.setTranslations()
        this.verifyWorkflow()
        this.displayWorkflow()
    },
    methods: {
        setCloudParams(){
            if(this.engineNamespace == '/'){
                this.main_route = '/workflows'
            }else{
                this.main_route = `/${this.engineNamespace}/workflows`
            }
            let module_data = this.engineNamespace.split('/')
            this.module_name = module_data[0]
        },

        setTranslations(){
            if(this.translationsPath){
                this.translations.main = I18n.t(this.translationsPath)
            }
        },

        getIcon(node){
            let icon = ''
            if(node.status_type == 'initial'){
                icon = 'fas:fa-play-circle'
            }else if(node.status_type == 'completed_successfully' || node.status_type == 'completed_unsuccessfully'){
                icon = 'fas:fa-check-circle'
            }else if(node.status_type == 'to_be_deleted'){
                icon = 'fas:fa-exclamation-circle'
            }
            return icon
        },

        verifyWorkflow(){
            if(this.workflow){
                this.workflow_data = this.workflow.statuses
            }else{
                let url = `${this.main_route}/${this.workflowId}.json`

                this.http.get(url).then(result => {
                    if (result.successful) {
                        this.workflow_data = result.data.statuses
                        this.displayWorkflow()
                    }else{
                        this.alert(result.error.message,'danger')
                    }
                }).catch(error => {
                    console.log(error)
                })
            }
        },
        
        displayWorkflow(){
            if(this.workflow_data && this.selected_status_id){
                this.$emit('update:rerender', false)

                let selected_status = this.workflow_data[this.selected_status_id]

                let node = {
                    id: selected_status.id,
                    text: `${this.getIcon(selected_status)} ${this.getNodeName(selected_status)}`,
                    next: (selected_status.next_statuses || '').split('|'),
                    style: this.getStyle(selected_status)
                }
                let data = [node]

                for(let i = 0; i < node.next.length; i++){
                    let next_status_id = node.next[i]
                    if(! next_status_id){
                        continue
                    }
                    let next_status = this.workflow_data[next_status_id]

                    data.push({
                        id: next_status_id,
                        text: `${this.getIcon(next_status)} ${this.getNodeName(next_status)}`,
                        next: [],
                        style: this.getStyle(next_status)
                    })
                }

                let previous_statuses = Object.values(this.workflow_data).filter((previous_status)=> {
                    return (`|${previous_status.next_statuses}|` || "").includes(`|${selected_status.id}|`) && previous_status.id != this.selected_status_id
                })

                previous_statuses.forEach((previous_status)=>{
                    data.push({
                        id: `P${previous_status.id}`,
                        text: `${this.getIcon(previous_status)} ${this.getNodeName(previous_status)}`,
                        next: [this.selected_status_id],
                        style: this.getStyle(previous_status)
                    })
                })

                this.parsed_workflow = data
            }
        },

        getStyle(node){
            let style = 'fill:#FFFFFF'

            if(node.status_type == 'initial'){
                style = 'fill:#3298dc'
            }else if(node.status_type == 'completed_successfully'){
                style = 'fill:#48c774'
            }else if(node.status_type == 'completed_unsuccessfully'){
                style = 'fill:#ffdd57'
            }else if(node.status_type == 'to_be_deleted'){
                style = 'fill:#f14668'
            }

            if(node.id == this.selected_status_id){
                style += ', stroke:#16decd, stroke-width:3px'
            }else{
                style += ', stroke:#000000'
            }

            console.log(style)

            return style
        },

        getNodeName(node){
            return (
                this.object_utils.translateEnum(this.translations.core, 'column_enum_status', node.name, null) ||
                this.object_utils.translateEnum(this.translations.main, 'status', node.name)
            )
        }
    },
    watch: {
        selected_status_id(){
            this.displayWorkflow()
        },

        workflow(){
            this.displayWorkflow()
        },
        
        rerender(){
            if(this.rerender){
                this.displayWorkflow()
            }
        }
    },

    computed: {
        orderedWorkflowStatuses(){
            if(! this.workflow.statuses){
                return []
            }
            
            return Object.values(this.workflow.statuses).sort(function(status_1, status_2){
                return (status_1.number || 0) - (status_2.number || 0)
            })
        }
    }
}
</script>
<template>
    <div class="columns is-multiline">
        <div class="column is-12">
            <b-field>
                <div class="control is-expanded">
                    <span class="select is-fullwidth is-empty">
                        <select v-model="selected_status_id">
                            <option
                                :value="null"
                                hidden
                                disabled
                            >
                                {{translations.workflows.view_placeholder_select_status_to_view_chart}}
                            </option>
                            <option
                                v-for="status in orderedWorkflowStatuses"
                                :value="status.id"
                                :key="status.id" 
                            >
                                {{
                                    object_utils.translateEnum(translations.core, 'column_enum_status', status.name, null) ||
                                    object_utils.translateEnum(translations.main, 'status', status.name)
                                }}
                            </option>
                        </select>
                    </span>
                </div>
            </b-field>
        </div>
        <div class="column is-12">
            <vue-mermaid
                class="workflow-chart"
                v-if="workflow_data"
                :nodes="parsed_workflow"
                type="graph LR"
            >
            </vue-mermaid>
        </div>
    </div>
    
</template>
<style scoped>
.workflow-chart{
    overflow-x: auto;
}
</style>
