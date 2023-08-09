<script setup>
/*

Lesli

Copyright (c) 2023, Lesli Technologies, S. A.

This program is free software: you can redistribute it and/or modify
it under the terms of the GNU General Public License as published by
the Free Software Foundation, either version 3 of the License, or
(at your option) any later version.

This program is distributed in the hope that it will be useful,
but WITHOUT ANY WARRANTY; without even the implied warranty of
MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the
GNU General Public License for more details.

You should have received a copy of the GNU General Public License
along with this program. If not, see http://www.gnu.org/licenses/.

Lesli · Your Smart Business Assistant. 

Made with ♥ by https://www.lesli.tech
Building a better future, one line of code at a time.

@contact  hello@lesli.tech
@website  https://lesli.tech
@license  GPLv3 http://www.gnu.org/licenses/gpl-3.0.en.html

// · ~·~     ~·~     ~·~     ~·~     ~·~     ~·~     ~·~     ~·~     ~·~     ~·~     ~·~     ~·~
// · 

*/



// · import vue tools
import { inject, onMounted, watch } from "vue"

// · import stores
import { useWorkflow } from "Lesli/stores/shared/workflow"

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

onMounted(() => {
    if (!props.isEditable){
        storeWorkflow.resetWorkflow()
    } else {
        storeWorkflow.fetchWorkflow(route.params?.id).then(()=>{
            statusesOptions()
        })      
    }
})

</script>
<template>
    <div class="block">
        <!-- Workflow form -->
        <form  
            class="information" 
            @submit.prevent="isEditable? onUpdate() : onCreate()">

            <!-- Name -->
            <div class="columns is-marginless has-border-bottom">
                <div class="column">
                    <label class="label">
                        Workflow Name
                    </label>
                    <input name="name" v-model="storeWorkflow.workflow.name" type="text" class="input"> 
                </div>
            </div>

        </form>
    </div>
    
    <div class="block">
        <!-- Status workflows form -->
        <form @submit.prevent="createStatus()">

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
        
        <br>

        <div class="block" v-if="storeWorkflow.workflow.statuses">
            <div class="columns">
                <div class="column is-8">
                    <span class="has-text-weight-bold">
                        {{translations.workflows.view_title_select_status}}
                    </span>
                    <div class="menu-list is-bg-dark is-hoverable">
                        <a v-for="status in storeWorkflow.workflow.statuses" 
                            class="list-item" 
                            @click="selectStatus(status)"
                            :class="{'is-active':storeWorkflow.selected_status.id == status.id}"
                        >
                            <div class="columns">
                                <!-- Status name -->
                                <div class="column is-paddingless-right is-7">
                                    {{ status.name }}
                                </div>
                                <!-- Status number -->
                                <div class="column is-paddingless-x is-2">
                                    <input type="number" class="input" v-model="status.number"/>
                                </div>
                                <!-- Change status buttons -->
                                <div class="column is-paddingless-left is-3">
                                    <span class="is-pulled-right has-background-white">
                                        <div class="field has-addons">
                                            <p class="control">
                                                <button class="button is-primary is-outlined" @click="selectAsInitial(status)" :title="translations.workflows.messages_info_tooltip_status_initial">
                                                    <span class="material-icons">play_circle</span>
                                                    <span></span>
                                                </button>
                                            </p>
                                            <p class="control">
                                                <button class="button is-success is-outlined" @click="changeStatusType(status, 'completed_successfully')" :title="translations.workflows.messages_info_tooltip_status_completed_successfully">
                                                    <span class="material-icons">check_circle</span>
                                                    <span></span>
                                                </button>
                                            </p>
                                            <p class="control">
                                                <button class="button is-warning is-outlined" @click="changeStatusType(status, 'completed_unsuccessfully')" :title="translations.workflows.messages_info_tooltip_status_completed_unsuccessfully">
                                                    <span class="material-icons">cancel</span>
                                                    <span></span>
                                                </button>
                                            </p>
                                            <p class="control">
                                                <button class="button is-danger is-outlined" @click="changeStatusType(status, 'to_be_deleted')" :title="translations.workflows.messages_info_tooltip_status_to_be_deleted">
                                                    <span class="material-icons">auto_delete</span>
                                                    <span></span>
                                                </button>
                                            </p>
                                        </div>
                                    </span>
                                </div>
                            </div>
                        </a>
                    </div>
                </div>

                <div class="column is-4" v-if="storeWorkflow.selected_status.id">
                    <label class="label">{{translations.workflows.view_title_select_transition_status}}</label>
                    <div class="columns">
                        <div class="column">
                                <div class="control is-expanded">
                                    <span class="select is-fullwidth is-empty">
                                        <lesli-select
                                            :options="storeWorkflow.status_select"
                                            @change="addFollowUpStatus"
                                            v-model="storeWorkflow.status_transition"
                                        >
                                        </lesli-select>
                                    </span>
                                </div>
                        </div>
                    </div>
                    <div class="columns">
                        <div class="column">
                            <span class="has-text-weight-bold">
                                {{translations.workflows.view_title_transition_statuses_list}}
                            </span>
                            <div class="menu-list is-hoverable">
                                <a v-for="workflow_status in storeWorkflow.list_status" class="list-item">
                                    {{ workflow_status.number }} - {{ workflow_status.name }}
                                    <button type="button" class="delete is-pulled-right" @click="deleteTransitionStatus(workflow_status.id)">
                                    </button>
                                </a>
                            </div>
                        </div>
                    </div>
                    <div class="columns">
                        <div class="column">
                            <lesli-button @click="deleteStatus" danger icon="delete">Delete status</lesli-button>
                        </div>
                    </div>
                </div>
            </div>

        </div>

        <div class="columns is-marginless has-border-bottom block" v-if="storeWorkflow.workflow.statuses">
            <div class="column">
                <lesli-button icon="save" @click="storeWorkflow.updateWorkflowStatuses" :loading="storeWorkflow.loading">
                    save
                </lesli-button>  
            </div>
        </div>


    </div>

    

</template>
