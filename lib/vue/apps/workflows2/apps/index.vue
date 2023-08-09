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


/**
 * @param {*} workflow
 * @description This function is used to get the validation column of the table
 */
const getValidation = (workflow) => {
    const countTrueChecks = Object.keys(workflow.checks).reduce((acc, key) => {
        if (workflow.checks[key].passed) return acc + 1
        return acc
    }, 0)

    return countTrueChecks === 4 ? 
        translations.core.workflows.view_text_fully_configured :
        `${countTrueChecks} ${translations.core.workflows.view_text_posibble_issue}`
}

/**
 * @param {*} workflow
 * @description This function is used to get the connected_to column of the table
 */
const getConnectedTo = (workflow) => {
    if (workflow.connected_to.length === 0) return translations.core.workflows.view_text_without_connections
    
    // return string like "Match, Project"
    return workflow.connected_to.map((item) => {
        // capitalize first letter of each word and return the string
        return item.workflow_for.charAt(0).toUpperCase() + item.workflow_for.slice(1)
    }).join(", ")
}

// · workflows to use in the table
const workflows = computed(() => {
    return storeWorkflow.workflows.map(workflow => {
        getValidation(workflow)
        return {
            id: workflow.id,
            name: workflow.name,
            validation: getValidation(workflow),
            default: workflow.default,
            connectedTo: getConnectedTo(workflow),
        }
    })
})

// · columns of the table
const columns = [
    {
        field: "name",
        label: translations.core.actions.column_name,
    },
    {
        field: "validation",
        label: translations.core.workflows.column_validation,
    },
    {
        field: "default",
        label: translations.core.workflows.column_default,
    },
    {
        field: "connectedTo",
        label: translations.core.workflows.column_connected_to,
    },
];

onMounted(() => {
    // · get workflow status
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

    </section>
</template>
