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
    cloudObjectId: {
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
const emit = defineEmits(['onUpdatedStatus'])


// returns a string like: "mitweken_cloud_workflow_statuses_id"
const workflowStatusKey = computed(() => {
    return Object.keys(storeWorkflow.workflow_statuses[0]).find(key => key.endsWith("workflows_id")).replace("workflows_id", "workflow_statuses_id")
})

const dropdownActive = ref(null)

// set props to store
storeWorkflow.cloudModule = props.cloudModule
storeWorkflow.cloudObject = props.cloudObject
storeWorkflow.cloudObjectId = props.cloudObjectId
storeWorkflow.workflowId = props.workflowId
storeWorkflow.currentStatus = props.currentStatus


/**
 * @description This function is called when the user updates the status of the project.
 */
 const onUpdatedStatus = (status) => {
    storeWorkflow.currentStatus = status
    storeWorkflow.updateStatus({[workflowStatusKey.value]: status.id})
    emit('onUpdatedStatus')
}

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

    <!-- Change the current status of the object -->

    <div :class="['dropdown', 'is-right is-hoverable']">
        <div class="dropdown-trigger">
            <button class="button"
                @blur="dropdownActive = false"
                @click="dropdownActive = !dropdownActive">
                <span class="icon">
                    <span v-if="!dropdownActive" class="material-icons">
                        edit
                    </span>
                    <span v-if="dropdownActive" class="material-icons">
                        close
                    </span>
                </span>
            </button>
        </div>
        <Transition>
            <div v-if="dropdownActive" class="dropdown-menu" role="menu">
                <div class="dropdown-content">
                    <div class="dropdown-item" v-for="option in storeWorkflow.workflow_statuses">
                        <div :class="{ active: option.number === currentStatus.number }">
                            <a  @click="onUpdatedStatus(option)">
                                {{ option.name }}
                            </a>
                            <span v-if="option.number === currentStatus.number" class="material-icons">
                                    check_circle
                            </span>
                        </div>
                    </div>
                </div>
            </div>
        </Transition>
    </div>
</template>
