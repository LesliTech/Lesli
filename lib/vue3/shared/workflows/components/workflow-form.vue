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
import { useWorkflowStatus } from "LesliVue/stores/shared/workflows/status"

// · import vue router composable
import { useRouter, useRoute } from "vue-router"

// · implement stores
const storeWorkflow = useWorkflow()
const storeStatus = useWorkflowStatus()

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
    storeWorkflow.postWorkflow()
}


function selectAsInitial(selected_status){
    storeWorkflow.updateWorkflowStatus(selected_status.id, "normal")
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
        <form @submit.prevent="storeWorkflow.postStatus()">

            <!-- Workflow status name -->
            <div class="columns is-marginless has-border-bottom">
                <div class="column">
                    <label class="label">
                        {{ translations.workflows.view_title_add_new_status }}
                    </label>
                    <input class="input" type="text" v-model="storeWorkflow.new_status_name">
                </div>
                <div class="column">
                    <lesli-button icon="add">
                        Add
                    </lesli-button>  
                </div>
            </div>

          

            <div class="columns is-marginless has-border-bottom">
                <div class="column">
                    <lesli-button icon="save">
                        save
                    </lesli-button>  
                </div>
            </div>

        </form>

        <lesli-table 
                :records="storeWorkflow.workflow.statuses"
                :columns="columns"
            >
                <template #number="{ value }">
                    <input 
                        type="text"
                        class="input"
                        @input=""
                        v-model="value"
                    />
                </template>

                <template #marks="{ record }">
                    <lesli-button icon="play_circle" @click="selectAsInitial(record)"></lesli-button>
                    <lesli-button icon="check_circle"></lesli-button>
                    <lesli-button icon="cancel"></lesli-button>
                    <lesli-button icon="auto_delete"></lesli-button>
                </template>

                <template #options="{ record }">
                    <a class="dropdown-item" @click="storeWorkflow.deleteWorkflowStatus(record.id)">
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

    

</template>
