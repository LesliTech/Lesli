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

// · import stores
import { useWorkflow } from "LesliVue/stores/shared/workflow"

// · import vue router composable
import { useRouter, useRoute } from "vue-router"

// · implement stores
const storeWorkflow = useWorkflow()

// · initialize/inject plugins
const router = useRouter()
const url = inject("url")
const route = useRoute()

// · defining props
const props = defineProps({
    isEditable: {
        type: Boolean,
        required: false,
        default: false,
    },
    appMountPath: {
        type: String,
        required: false,
        default: "",
    }
})


// · translations
const translations = {
    workflows: I18n.t('core.workflows'),
    core: I18n.t('core.shared')
}

const columns = [{
    field: "name",
    label: ""
},
{
    field: "number",
    label: ""
},
{
    field: "marks"
},
{
    field: "completed_workflow"
},
{
    field: "failed_workflow"
},
{
    field: "to_be_deleted"
}]


/**
 * @description This function is used to update the workflow information
 */
const onUpdate = () => {
    storeWorkflow.updateWorkflow()
}

/**
 * @description This function is used to create a new workflow
 */
const onCreate = () => {
    storeWorkflow.postWorkflow().then(()=> {
        router.push(url.root(`${props.appMountPath}/${storeWorkflow.workflow.id}`).s)
    })
}

/**
 * @description This function is used to set the selected_status as initial
 */
function selectAsInitial(selected_status){
    for(let key in storeWorkflow.workflow.statuses){
        let status = storeWorkflow.workflow.statuses[key]

        if(status.id == selected_status.id){
            storeWorkflow.workflow.statuses[key].status_type = 'initial'
            continue
        }

        if(status.status_type == 'initial'){
            storeWorkflow.workflow.statuses[key].status_type = 'normal'
        }
    }
}

/**
 * @description This function is used to change the type of the selected status
 */
function changeStatusType(selected_status, new_status_type){
    for(let key in storeWorkflow.workflow.statuses){

        if(storeWorkflow.workflow.statuses[key].id == selected_status.id){

            if(selected_status.status_type == new_status_type){
                storeWorkflow.workflow.statuses[key].status_type = 'normal'
            }else{
                storeWorkflow.workflow.statuses[key].status_type = new_status_type
            }
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
    let follow_up_statuses  = storeWorkflow.selected_status.next_statuses.split('|').map((element)=>{
        return parseInt(element)
    })

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
        let next_statuses_ids = storeWorkflow.selected_status.next_statuses.split('|')
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


</script>
<template>
    <form @submit.prevent="createStatus()">
        <div class="field">
            <label class="label">
                {{ translations.workflows.view_title_add_new_status }}
            </label>
            <div class="field is-grouped">
                <p class="control is-expanded">
                    <input 
                        class="input" 
                        type="text" 
                        placeholder="Enter status name"
                        v-model="storeWorkflow.new_status_name" 
                        :disabled="!storeWorkflow.workflow.id">
                </p>
                <p class="control">
                    <lesli-button icon="add" solid>
                        Add status
                    </lesli-button> 
                </p>
            </div>
        </div>
    </form>
</template>
