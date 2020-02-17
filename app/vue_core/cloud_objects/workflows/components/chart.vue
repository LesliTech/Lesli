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
        selectedWorkflowState: {
            type: Number,
            default: null
        },
        rerender: {
            type: Boolean,
            default: false
        }
    },
    data(){
        return {
            parsed_workflow: [],
            workflow_data: null
        }
    },
    mounted(){
        this.setCloudParams()
        this.verifyWorkflow()
        this.displayWorkflow()
    },
    methods: {
        setCloudParams(){
            let module_data = this.cloudModule.split('/')
            this.module_name = module_data[0]
        },

        getIcon(node){
            let icon = 'fas:fa-forward'
            if(node.initial){
                icon = 'fas:fa-play'
            }else if(node.final){
                icon = 'fas:fa-stop'
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
            if(this.workflow_data){
                this.$emit('update:rerender', false)
                let data = []
                Object.values(this.workflow_data).forEach( node => {
                    let parsed_node = {
                        id: node.number,
                        text: `${this.getIcon(node)} ${this.getNodeName(node)}`
                    }
                    if(node.next_statuses){
                        parsed_node.next = node.next_statuses.split("|")
                    }
                    if(this.selectedWorkflowState == node.number){
                        parsed_node.style = 'fill:#EFFD5F,stroke:#FCE205'
                    }
                    data.push(parsed_node)
                })
                this.parsed_workflow = data
            }
        },

        getNodeName(node){
            if(node.initial){
                return 'Created'
            }
            if(node.final){
                return 'Closed'
            }
            return node.name
        }
    },
    watch: {
        selectedWorkflowState(){
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
    <vue-mermaid
        class="workflow-chart"
        v-if="workflow_data"
        :nodes="parsed_workflow"
        type="graph LR"
    >
    </vue-mermaid>
</template>
<style scoped>
.workflow-chart{
    overflow-x: auto;
}
</style>
