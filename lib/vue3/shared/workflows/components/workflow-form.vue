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
import { inject, onMounted } from "vue"

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
function deleteStatus(deleted_status){

    let new_statuses = Object.values(storeWorkflow.workflow.statuses).filter((status) => {
        if (status.id != deleted_status.id){
            return status
        }
    })

    deleted_status['_destroy'] = true

    storeWorkflow.deleted_workflow_statuses.push(deleted_status)
    storeWorkflow.workflow.statuses = new_statuses
}

/**
 * @description This function is used to create a new status for a workflow
 */
 const createStatus = () => {
    storeWorkflow.postStatus().then(()=>{
        storeWorkflow.fetchWorkflow(route.params?.id)
    })
}


function possibleFollowUpStatuses(){

    let label = []

    if(! storeWorkflow.selected_status.next_statuses){
        label = label.concat(Object.values(storeWorkflow.workflow.statuses))
        label.sort((a,b) => a.number - b.number)

        storeWorkflow.status_select = []

        label.forEach((option)=>{
            storeWorkflow.status_select.push({
                label: option.name,
                value: option.id
            })
        })

        return label
    }
    
    let follow_up_statuses  = storeWorkflow.selected_status.next_statuses.split('|').map((element)=>{
        return parseInt(element)
    })

    label =  label.concat(Object.values(storeWorkflow.workflow.statuses).filter(element => {
        return ! follow_up_statuses.includes(element.id)
    }))

    return label.sort((a,b) => a.number - b.number)
    
}

function  nextStatusesOfSelectedStatus(){
    storeWorkflow.transition_statuses = []
    if(! storeWorkflow.workflow.statuses[storeWorkflow.selected_status.id]){
        storeWorkflow.transition_statuses = []
    }
    if(storeWorkflow.selected_status.next_statuses){
        let next_statuses_ids = storeWorkflow.selected_status.next_statuses.split('|')
        next_statuses_ids.forEach((id)=>{
            storeWorkflow.transition_statuses.push(next_statuses_ids.workflow.statuses[id])
        })
    }

}


function addFollowUpStatus(){
    if(storeWorkflow.status_transition != null){
        if(storeWorkflow.selected_status.next_statuses){
            storeWorkflow.selected_status.next_statuses += `|${storeWorkflow.status_transition}`
        }else{
            storeWorkflow.selected_status.next_statuses = `${storeWorkflow.status_transition}`
        }

        storeWorkflow.status_select = []

        storeWorkflow.status_transition = null
    }

    nextStatusesOfSelectedStatus()
}





onMounted(() => {
    if (!props.isEditable){
        storeWorkflow.workflow = {}
    } else {
        storeWorkflow.fetchWorkflow(route.params?.id).then(()=>{
            possibleFollowUpStatuses()
        })      
    }
})



</script>
<template>
    <div class="block">
        <!-- Workflow form -->
        <form 
            v-if="!storeWorkflow.loading" 
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

        <div class="block" v-if="!storeWorkflow.loading && storeWorkflow.workflow.statuses">
            <div class="columns">
                <div class="column is-8">
                    <span class="has-text-weight-bold">
                        {{translations.workflows.view_title_select_status}}
                    </span>
                    <div class="menu-list is-bg-dark is-hoverable">
                        <a v-for="status in storeWorkflow.workflow.statuses" 
                            class="list-item" 
                            @click="storeWorkflow.selected_status = status"
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
                                                <button class="button is-primary is-outlined" @click="selectAsInitial(status)">
                                                    <span class="material-icons">play_circle</span>
                                                    <span></span>
                                                </button>
                                            </p>
                                            <p class="control">
                                                <button class="button is-success is-outlined" @click="changeStatusType(status, 'completed_successfully')">
                                                    <span class="material-icons">check_circle</span>
                                                    <span></span>
                                                </button>
                                            </p>
                                            <p class="control">
                                                <button class="button is-warning is-outlined" @click="changeStatusType(status, 'completed_unsuccessfully')">
                                                    <span class="material-icons">cancel</span>
                                                    <span></span>
                                                </button>
                                            </p>
                                            <p class="control">
                                                <button class="button is-danger is-outlined" @click="changeStatusType(status, 'to_be_deleted')">
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
                                <a v-for="(workflow_status, key) in storeWorkflow.transition_statuses" :key="key" class="list-item">
                                    {{ workflow_status.number }}
                                </a>
                            </div>
                        </div>
                    </div>
                </div>
                

            </div>

        </div>

        <div class="columns is-marginless has-border-bottom block" v-if="!storeWorkflow.loading && storeWorkflow.workflow.statuses">
            <div class="column">
                <lesli-button icon="save" @click="storeWorkflow.updateWorkflowStatuses">
                    save
                </lesli-button>  
            </div>
        </div>


    </div>

    

</template>
