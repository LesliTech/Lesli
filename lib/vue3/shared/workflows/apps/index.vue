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
import workflowPanelNew from "../components/panel-workflow.vue"

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
        actions: I18n.t("core.workflow/actions.column_name")
    }
}


// · columns of the table
const columns = [{
    field: "name",
    label: translations.core.actions.column_name,
}, {
    field: "validation",
    label: translations.core.workflows.column_validation,
}, {
    field: "default",
    label: translations.core.workflows.column_default,
}, {
    field: "connectedTo",
    label: translations.core.workflows.column_connected_to,
}];


onMounted(() => {
    storeWorkflow.fetchWorkflows()
})


</script>

<template>
    <section class="application-component">
        
        <lesli-header :title="translations.core.workflows.view_title_workflows">
            <lesli-button
                outlined
                icon="refresh"
                :loading="storeWorkflow.loading"
                @click="storeWorkflow.fetchWorkflows()">
                {{ translations.core.shared.view_text_btn_reload }}
            </lesli-button>
            
            <lesli-button  icon="add" @click="storeWorkflow.panelNew = true">
                add new workflow
            </lesli-button>
        </lesli-header>

        <lesli-toolbar 
            @search="storeWorkflow.searchWorkflows" 
            :search-placeholder="translations.core.workflows.view_placeholder_search_text">
        </lesli-toolbar>

        <lesli-table 
            :columns="columns" 
            :records="storeWorkflow.workflows.records"
            :link="(workflow) => url.root(`${props.appMountPath}/${workflow.id}`)">
        </lesli-table>

    </section>
    <workflow-panel-new></workflow-panel-new>
</template>
