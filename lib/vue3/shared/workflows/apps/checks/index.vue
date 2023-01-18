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
import { ref, computed, onMounted } from "vue"

// · import stores
import { useWorkflow } from "LesliVue/stores/shared/workflow"

// · implement store
const storeWorkflow = useWorkflow()

// · defining props
const props = defineProps({
    // · prop that indicates the cloud module that will be used for interacting with the backend.
    cloudModule: {
        type: String,
        required: true,
    },
    // · prop that indicates the resource that you need to interact with.
    cloudObject: {
        type: Object,
        required: true,
    },
    appMountPath: {
        type: String,
        required: false,
        default: "",
    }
})

// set props to store
storeWorkflow.cloudModule = props.cloudModule
storeWorkflow.cloudObject = props.cloudObject

// · defining translations
const translations = {
    core: {
        workflows: I18n.t("core.workflows"),
        shared: I18n.t("core.shared"),
    }
}



// · columns of the table
const columns = [
    {
        field: "name",
        label: "Name",
    },
    {
        field: "initial_status",
        label: "Initial status",
    },
    {
        field: "final_status",
        label: "Final status",
    },
    {
        field: "role",
        label: "Role",
    },
    {
        field: "verification_type",
        label: "Verification type",
    },
    {
        field: "employee",
        label: "Employee",
    },
]

onMounted(() => {
    // · get workflow status
    storeWorkflow.fetchWorkflows()
})

</script>

<template>
    <lesli-header title="Checks">
        <lesli-button
            outlined
            icon="refresh"
            :loading="storeWorkflow.loading"
            @click="storeWorkflow.fetchWorkflows()"
        >
            {{ translations.core.shared.view_text_btn_reload }}
        </lesli-button>
        
        <lesli-button  icon="add" :to="url.root(props.appMountPath + '/new')">
            add
        </lesli-button>
    </lesli-header>

    <lesli-toolbar @search="storeWorkflow.searchWorkflows" :search-placeholder="translations.core.workflows.view_placeholder_search_text" class="mt-4">
    </lesli-toolbar>

    <lesli-table 
        :columns="columns" 
        :records="workflows"
        :link="(workflow) => url.root(`${props.appMountPath}/${workflow.id}`).s"
    >
    </lesli-table>

</template>
