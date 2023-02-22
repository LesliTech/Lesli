<script setup>
/*
Copyright (c) 2023, all rights reserved.
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
// · import vue tools
import { inject, onMounted, watch } from "vue"
// · import components
import mermaidChart from "LesliVue/components/diagrams/mermaid.vue"
// · import stores
import { useWorkflow } from "LesliVue/stores/shared/workflow"
// · implement stores
const storeWorkflow = useWorkflow()
// · initialize/inject plugins
const url = inject("url")
// · defining props
const props = defineProps({
})
// · translations
const translations = {
    workflows: I18n.t('core.workflows'),
    core: I18n.t('core.shared')
}
const columns = [{
    field: "name",
    label: "Status"
}, {
    field: "category",
    label: "Category"
}, {
    field: "statuses",
    label: "Connected to",
    align: 'center'
}]
// change the type of the selected status and reorganize the rest of 
// statuses if needed ej. cant exists two initial statuses
function changeStatusType(selected_status, new_status_type){
    // go over all the statuses of the workflow
    for(let key in storeWorkflow.workflow.statuses){
        // get the details of the status in the loop
        let status = storeWorkflow.workflow.statuses[key]
        // work with the selected status only
        if(status.id == selected_status.id){
            // update the type
            storeWorkflow.workflow.statuses[key].status_type = new_status_type
            // due our work with this status is done
            continue
        }
        // be sure cant be two statuses with as initial
        if(status.status_type == 'initial'){
            // if selected another status as initial I should reorganize 
            storeWorkflow.workflow.statuses[key].status_type = 'normal'
        }
    }
}
/**
 * @description This function is used to delete a status
 */
function deleteStatus(){
    let new_statuses = Object.values(storeWorkflow.workflow.statuses).filter((status) => {
        if (status.id != storeWorkflow.selected_status.id){
            return status
        }
    })
    storeWorkflow.selected_status['_destroy'] = true
    storeWorkflow.deleted_workflow_statuses.push(storeWorkflow.selected_status)
    storeWorkflow.workflow.statuses = new_statuses
    for(let status_id in storeWorkflow.workflow.statuses){
        let workflow_status = storeWorkflow.workflow.statuses[status_id]
        if(workflow_status.next_statuses){
            workflow_status.next_statuses = workflow_status.next_statuses.replace(
                new RegExp(`([^0-9]${storeWorkflow.selected_status.id}$)|(^${storeWorkflow.selected_status.id}[^0-9])|(^${storeWorkflow.selected_status.id}$)`,'g'), ''
            ).replace(
                new RegExp(`([^0-9]${storeWorkflow.selected_status.id}[^0-9])`,'g'), '|'
            )
            if(workflow_status.next_statuses.length == 0){
                workflow_status.next_statuses = null
            }
        }
    }
    storeWorkflow.selected_status = {}
}
/**
 * @description This function is used to create a new status for a workflow
 */
 const createStatus = () => {
    storeWorkflow.postStatus().then(()=>{
        storeWorkflow.fetchWorkflow(route.params?.id)
    })
}
/**
 * @description This function is used to change the possible status to add to a status selected
 */
function statusesOptions(){
    let label = []
    storeWorkflow.status_select = []
    // Check if the status selected doesn't have next statuses
    if(! storeWorkflow.selected_status.next_statuses){
        label = label.concat(Object.values(storeWorkflow.workflow.statuses))
        label.sort((a,b) => a.number - b.number)
        
        label.forEach((option)=>{
            storeWorkflow.status_select.push({
                label: option.name,
                value: option.id
            })
        })
        return label
    }
    
    // If the selected status has next statuses, show all possible states omitting the ones you already have 
    let follow_up_statuses  = storeWorkflow.selected_status.next_statuses
    /*
    let follow_up_statuses  = storeWorkflow.selected_status.next_statuses.split('|').map((element)=>{
        return parseInt(element)
    })
    */
    label =  label.concat(Object.values(storeWorkflow.workflow.statuses).filter(element => {
        return !follow_up_statuses.includes(element.id)
    }))
    label.sort((a,b) => a.number - b.number)
    return label.forEach((option)=>{
        storeWorkflow.status_select.push({
            label: option.name,
            value: option.id
        })
    })
}
/**
 * @description This function is used to add a status as a next status
 */
function addFollowUpStatus(){
    if(storeWorkflow.status_transition != null){
        if(storeWorkflow.selected_status.next_statuses){
            storeWorkflow.selected_status.next_statuses += `|${storeWorkflow.status_transition}`
        }else{
            storeWorkflow.selected_status.next_statuses = `${storeWorkflow.status_transition}`
        }
        storeWorkflow.status_select = storeWorkflow.status_select.filter(status => status.value != storeWorkflow.status_transition)
        storeWorkflow.status_transition = null
    }
}
/**
 * @description This function is used to change the type of the selected status
 */
function  nextStatusesOfSelectedStatus(){
    let transition_statuses = []
    if(! storeWorkflow.workflow.statuses[storeWorkflow.selected_status.id]){
        return transition_statuses
    }
    if(storeWorkflow.selected_status.next_statuses){
        //let next_statuses_ids = storeWorkflow.selected_status.next_statuses.split('|')
        let next_statuses_ids = storeWorkflow.selected_status.next_statuses
        next_statuses_ids.forEach((id)=>{
            transition_statuses.push(storeWorkflow.workflow.statuses[id])
        })
    }
    storeWorkflow.list_status = transition_statuses
    return transition_statuses
}
/**
 * @description This function is used to change the selected status 
 */
function selectStatus(status){
    storeWorkflow.selected_status = status
}
/**
 * @description This function is used to delete a transition status from the selected status 
 */
function deleteTransitionStatus(status_id){
    storeWorkflow.selected_status.next_statuses = storeWorkflow.selected_status.next_statuses.replace(
        new RegExp(`([^0-9]${status_id}$)|(^${status_id}[^0-9])|(^${status_id}$)`,'g'), ''
    ).replace(
        new RegExp(`([^0-9]${status_id}[^0-9])`,'g'), '|'
    )
}
// Watch changes in next status to update status options and list of next statuses
watch(() => storeWorkflow.selected_status.next_statuses, () => {
    statusesOptions()
    nextStatusesOfSelectedStatus()
})
// · 
function parseCurrentStatus(status) {
    //let statuses = JSON.parse(JSON.stringify(storeWorkflow.workflow.statuses))
    let statuses = storeWorkflow.workflow.statuses
    statuses = statuses.map(s => { 
        if (s.id == status.id) {
            return s
        }
        if (!status.next.includes(s.id)) {
            return
        }
        return {
            id:s.id, 
            name:s.name
        } 
    })
        
    return statuses.filter(e => e)
}
</script>
<template>
    <div class="block">
        <!-- Status workflows form -->
        <form class="mb-4" @submit.prevent="createStatus()">
            <!-- Workflow status name -->
            <div class="columns is-marginless has-border-bottom">
                <div class="column">
                    <label class="label">
                        {{ translations.workflows.view_title_add_new_status }}
                    </label>
                </div>
                <div class="column is-8">
                    <input class="input" type="text" v-model="storeWorkflow.new_status_name" :disabled="!storeWorkflow.workflow.id">
                </div>
                <div class="column">
                    <lesli-button icon="add">
                        Add
                    </lesli-button>  
                </div>
            </div>
        </form>
        <lesli-table 
            v-if="storeWorkflow.workflow.statuses"
            :columns="columns"
            :records="storeWorkflow.workflow.statuses">
            <template #category="{ record }">
                <p class="icon-text has-text-info" v-if="record.status_type == 'initial'">
                    <span class="icon">
                        <span class="material-icons">
                            play_arrow
                        </span>
                    </span>
                    <span>
                        {{ translations.workflows.messages_info_tooltip_status_initial }}
                    </span>
                </p>
                <p class="icon-text has-text-primary" v-if="record.status_type == 'normal'">
                    <span class="icon">
                        <span class="material-icons">
                            done
                        </span>
                    </span>
                    <span>
                        Normal
                    </span>
                </p>
                <p class="icon-text has-text-success" v-if="record.status_type == 'completed_successfully'">
                    <span class="icon">
                        <span class="material-icons">
                            check_circle
                        </span>
                    </span>
                    <span>
                        {{ translations.workflows.messages_info_tooltip_status_completed_successfully }}
                    </span>
                </p>
                <p class="icon-text has-text-warning" v-if="record.status_type == 'completed_unsuccessfully'">
                    <span class="icon">
                        <span class="material-icons">
                            error_outline
                        </span>
                    </span>
                    <span>
                        {{ translations.workflows.messages_info_tooltip_status_completed_unsuccessfully }}
                    </span>
                </p>
            </template>
            <template #statuses="{ record }">
                {{ record.next.length }} statuses
            </template>
            <template #options="{ record }">
                <a class="dropdown-item" @click="() => storeWorkflow.panelStatuses = true">
                    Connect statuses
                </a>
                <a class="dropdown-item" @click="changeStatusType(record, 'initial')">
                    Mark as initial
                </a>
                <a class="dropdown-item" @click="changeStatusType(record, 'normal')">
                    Mark as normal
                </a>
                <a class="dropdown-item" @click="changeStatusType(record, 'completed_successfully')">
                    Mark as end (success)
                </a>
                <a class="dropdown-item" @click="changeStatusType(record, 'completed_unsuccessfully')">
                    Mark as end (fail)
                </a>
                <hr class="dropdown-divider">
                <a class="dropdown-item" @click="changeStatusType(record, 'completed_unsuccessfully')">
                    <span class="icon-text">
                        <span class="icon">
                            <span class="material-icons">
                                delete_outline
                            </span>
                        </span>
                        <span>
                            Delete status
                        </span>
                    </span>
                </a>
            </template>
            <!--
            <template #detail="{ record }">
                <div class="has-text-centered">
                    <mermaid-chart type="flowchart" :markers="parseCurrentStatus(record)">
                    </mermaid-chart>
                </div>
            </template>
            -->
        </lesli-table>
    </div>
</template>
