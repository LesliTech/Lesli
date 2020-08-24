<script>
/*
Lesli

Copyright (c) 2019, Lesli Technologies, S. A.

All the information provided by this website is protected by laws of Guatemala related 
to industrial property, intellectual property, copyright and relative international laws. 
Lesli Technologies, S. A. is the exclusive owner of all intellectual or industrial property
rights of the code, texts, trade mark, design, pictures and any other information.
Without the written permission of Lesli Technologies, S. A., any replication, modification,
transmission, publication is strictly forbidden.
For more information read the license file including with this software.

LesliCloud - Your Smart Business Assistant

Powered by https://www.lesli.tech
Building a better future, one line of code at a time.

@dev      Carlos Hermosilla
@author   LesliTech <hello@lesli.tech>
@license  Propietary - all rights reserved.
@version  0.1.0-alpha

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
        cloudModule: {
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
            parsed_workflow: [],
            workflow_data: null,
            translations: {},
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
            let module_data = this.cloudModule.split('/')
            this.module_name = module_data[0]
        },

        setTranslations(){
            if(this.translationsPath){
                this.translations.main = I18n.t(this.translationsPath)
            }
        },

        getIcon(node){
            let icon = ''
            if(node.initial){
                icon = 'fas:fa-play-circle'
            }else if(node.completed_successfully || node.completed_unsuccessfully){
                icon = 'fas:fa-check-circle'
            }else if(node.to_be_deleted){
                icon = 'fas:fa-exclamation-circle'
            }
            return icon
        },

        verifyWorkflow(){
            if(this.workflow){
                this.workflow_data = this.workflow.statuses
            }else{
                this.http.get(`/${this.module_name}/workflows/${this.workflowId}.json`).then(result => {
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
            let style = 'fill:#FFFFFF,stroke:#000000'

            if(node.initial){
                style = 'fill:#3298dc,stroke:#000000'
            }else if(node.completed_successfully){
                style = 'fill:#48c774,stroke:#000000'
            }else if(node.completed_unsuccessfully){
                style = 'fill:#ffdd57,stroke:#000000'
            }else if(node.to_be_deleted){
                style = 'fill:#f14668,stroke:#000000'
            }

            return style
        },

        getNodeName(node){
            if(this.translationsPath){
                return this.object_utils.translateEnum(this.translations.main, 'status', node.name)
            }
            return node.name
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
                                v-for="status in workflow.statuses"
                                :value="status.id"
                                :key="status.id"
                                :hidden="status.id == null"
                                :disabled="status.id == null"  
                            >
                                {{object_utils.translateEnum(translations.main, 'status', status.name)}}
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
