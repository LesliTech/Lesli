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
import { ref, computed, onMounted, watch, onUnmounted } from "vue"

// · import stores
import { useWorkflow } from "LesliVue/stores/shared/workflow2"

import stepper from "LesliVue/components/diagrams/stepper.vue"

// · implement store
const storeWorkflow = useWorkflow()


// · defining translations
const translations = {
    core: {
        shared: I18n.t("core.shared"),
        workflowStatuses: I18n.t("core.workflow/statuses")
    }
}

// · defining props
const props = defineProps({
    // · prop that indicates the cloud module that you need to interact with.
    cloudModule: {
        type: String,
        required: true,
    },
    // · prop that indicates the cloud object that you need to interact with.
    cloudObject: {
        type: String,
        required: true,
    },
    // · prop that indicates the object id of the resource that you need to interact with.
    workflowId: {
        type: Number,
        required: true,
    },
    // · prop that indicates the object id of the resource that you need to interact with.
    currentStatus: {
        type: Object,
        required: true,
    },
})

// · defining emits
const emit = defineEmits(['onUpdatedStatus']);

// set props to store
storeWorkflow.cloudModule = props.cloudModule
storeWorkflow.cloudObject = props.cloudObject
storeWorkflow.workflowId = props.workflowId
storeWorkflow.currentStatus = props.currentStatus


// · fetch transition options
onMounted(() => {
    storeWorkflow.fetchWorkflowStatuses()
})


</script>

<template>

    <stepper
        :steps="storeWorkflow.workflow_statuses"
        v-model="storeWorkflow.currentStatus"

        :stepsOptions="storeWorkflow.workflow_statuses"
    >

    </stepper>



</template>
