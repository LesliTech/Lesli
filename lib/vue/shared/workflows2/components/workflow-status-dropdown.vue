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
import { ref, computed, onMounted, watch, onUnmounted } from "vue"

// · import stores
import { useWorkflow } from "Lesli/stores/shared/workflow"

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
// · example translations path "core.workflow/statuses.column_enum_published" for statuses
const options = computed(() => {
    return storeWorkflow.transitionOptions.map(option => {
        return {
            label: translations.core.workflowStatuses[`column_enum_${option.name}`] ?  translations.core.workflowStatuses[`column_enum_${option.name}`] : option.name,
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


</script>

<template>
    <lesli-dropdown 
        :options="options" 
        :label="translations.core.shared.view_btn_change_status" 
        v-model="dropdownValue"
        v-if="!storeWorkflow.loading"
    />
</template>
