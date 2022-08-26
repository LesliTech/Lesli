<script setup>
/*
Copyright (c) 2022, all rights reserved.

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
})

// set props to store
storeWorkflow.cloudModule = props.cloudModule
storeWorkflow.cloudObject = props.cloudObject

// · defining translations
const translations = {
    core: {
        workflows: I18n.t("core.workflows"),
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
        label: translations.core.workflows.column_name,
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
        </lesli-header>

        <lesli-toolbar @search="storeWorkflow.searchWorkflows" :search-placeholder="translations.core.workflows.view_placeholder_search_text" class="mt-4">
        </lesli-toolbar>

        <lesli-table :columns="columns" :records="workflows">
        </lesli-table>

    </section>
</template>
