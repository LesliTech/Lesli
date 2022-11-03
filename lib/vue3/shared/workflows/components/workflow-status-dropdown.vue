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
import { ref, computed, onMounted, watch, onUnmounted } from "vue"

// · import stores
import { useWorkflow } from "LesliVue/stores/shared/workflow"

// · implement store
const storeWorkflow = useWorkflow()


// · defining translations
const translations = {
    core: {
        shared: I18n.t("core.shared"),
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
    cloudObjectId: {
        type: Number,
        required: true,
    },
})

// · defining emits
const emit = defineEmits(['onUpdatedStatus']);

// set props to store
storeWorkflow.cloudModule = props.cloudModule
storeWorkflow.cloudObject = props.cloudObject
storeWorkflow.cloudObjectId = props.cloudObjectId

// · dropdown's current value
const dropdownValue = ref(null)

// returns a string like: "mitweken_cloud_workflow_statuses_id"
const workflowStatusKey = computed(() => {
    return Object.keys(storeWorkflow.transitionOptions[0]).find(key => key.endsWith("workflows_id")).replace("workflows_id", "workflow_statuses_id")
})

// · transform options to an acceptable format for the dropdown 
const options = computed(() => {
    return storeWorkflow.transitionOptions.map(option => {
        return {
            label: option.name,
            value: option.id,
        }
    })
})

// · when cloud object id changes, fetch the transition options for this id
watch(() => props.cloudObjectId, (newId) => {
    storeWorkflow.cloudObjectId = newId
    storeWorkflow.fetchTransitionOptions()
})

// · when dropdown changes, update the workflow status
watch(dropdownValue, () => {
    if (dropdownValue.value) {
        storeWorkflow.updateStatus({[workflowStatusKey.value]: dropdownValue.value})
        emit('onUpdatedStatus')
    }
})

// · fetch transition options
onMounted(() => {
    storeWorkflow.fetchTransitionOptions()
})


// · when component is unmounted, clear the store
onUnmounted(() => {
    storeWorkflow.reset()
})
</script>

<template>
    <lesli-dropdown 
        :options="options" 
        :label="translations.core.shared.view_btn_change_status" 
        v-model="dropdownValue"
    />
</template>
