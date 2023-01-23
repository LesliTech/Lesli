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

onMounted(() => {
    if (!props.isEditable){
        storeWorkflow.workflow = {}
    } else {
        storeWorkflow.fetchWorkflow(route.params?.id)
    }
})



</script>
<template>
    <div class="block">
        <!-- Workflow form -->
        <form v-if="!storeWorkflow.loading" class="information" @submit.prevent="
                isEditable
                    ? onUpdate()
                    : onCreate()
        ">

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

        <div class="block">
            <lesli-table 
            :records="storeWorkflow.workflow.statuses"
            :columns="columns"
            v-if="!storeWorkflow.loading && storeWorkflow.workflow.statuses"
            >
                <template #number="{ record }">
                    <input 
                        type="text"
                        class="input"
                        v-model="record.number"
                        @input=""
                    />
                </template>

                <template #marks="{ record }">

                    <div class="field has-addons">
                        <p class="control">
                            <button class="button is-primary is-outlined" @click="selectAsInitial(record)">
                                <span class="material-icons">play_circle</span>
                                <span>Initial</span>
                            </button>
                        </p>
                        <p class="control">
                            <button class="button is-success is-outlined" @click="changeStatusType(record, 'completed_successfully')">
                                <span class="material-icons">check_circle</span>
                                <span>Completed</span>
                            </button>
                        </p>
                        <p class="control">
                            <button class="button is-warning is-outlined" @click="changeStatusType(record, 'completed_unsuccessfully')">
                                <span class="material-icons">cancel</span>
                                <span>Completed unsuccessfully</span>
                            </button>
                        </p>
                        <p class="control">
                            <button class="button is-danger is-outlined" @click="changeStatusType(record, 'to_be_deleted')">
                                <span class="material-icons">auto_delete</span>
                                <span>To be deleted</span>
                            </button>
                        </p>
                    </div>
                </template>

                <template #options="{ record }">
                    <a class="dropdown-item" @click="deleteStatus(record)">
                        <span class="material-icons">
                            delete
                        </span>
                        <span>
                            Delete
                        </span>
                    </a>
                </template>
            </lesli-table>

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
