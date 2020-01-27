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
        cloudId: {
            default: null
        },
        workflow: {
            type: Object,
            default: ()=>{
                return {}
            }
        },
        workflowStateInitialId: {
            type:Number,
            default: null
        },
        workflowStateFinalId: {
            type: Number,
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
            default_states: {
                initial: null,
                final: null
            }
        }
    },
    mounted(){
        this.setDefaultStatesIds()
        this.verifyDefaultStates()
        this.verifyWorkflow()
        this.displayWorkflow()
    },
    methods: {

        setDefaultStatesIds(){
            this.default_states.initial = this.workflowStateInitialId,
            this.default_states.final = this.workflowStateFinalId
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

        verifyDefaultStates(){
            if(! this.default_states.initial || ! this.default_states.final){
                this.http.get(`/${this.cloudModule}_workflow_states.json`).then(result => {
                    if (result.successful) {

                        this.default_states.initial = result.data.filter( state => state.initial)[0].id
                        this.default_states.final = result.data.filter( state => state.final)[0].id

                        this.displayWorkflow()
                    }else{
                        this.alert(result.error.message,'danger')
                    }
                }).catch(error => {
                    console.log(error)
                })
            }
        },

        verifyWorkflow(){
            if(! this.workflow){
                console.log("WE SHOULD GET THE WORKFLOW FROM THE SERVER HERE!!!!")
            }
        },
        
        displayWorkflow(){
            if(this.workflow && this.default_states.initial && this.default_states.final){
                this.$emit('update:rerender', false)
                let data = []
                Object.values(this.workflow).forEach( node => {
                    let parsed_node = {
                        id: node.workflow_state_id,
                        text: `${this.getIcon(node)} ${this.getNodeName(node)}`
                    }
                    if(node.next_states){
                        parsed_node.next = node.next_states.split("|")
                    }
                    if(this.selectedWorkflowState == node.workflow_state_id){
                        parsed_node.style = 'fill:#EFFD5F,stroke:#FCE205'
                    }
                    data.push(parsed_node)
                })
                this.parsed_workflow = data
            }
        },

        getNodeName(node){
            if(node.workflow_state_id == this.default_states.initial){
                return 'Created'
            }
            if(node.workflow_state_id == this.default_states.final){
                return 'Closed'
            }
            return node.workflow_state_name
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
        v-if="workflow && default_states.initial && default_states.final"
        :nodes="parsed_workflow"
        type="graph LR"
    >
    </vue-mermaid>
</template>
