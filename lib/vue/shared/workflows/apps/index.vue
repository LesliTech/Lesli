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
import { ref, computed, onMounted } from "vue"


// · import stores
import workflowPanelNew from "../components/panel-workflow.vue"

// · import stores
import { useWorkflow } from "Lesli/stores/shared/workflow"


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
