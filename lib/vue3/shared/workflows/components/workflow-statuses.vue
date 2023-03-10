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
import { inject, onMounted, watch, ref } from "vue"


// · import stores
import { useWorkflow } from "LesliVue/stores/shared/workflow"


// · implement stores
const storeWorkflow = useWorkflow()


// · initialize/inject plugins
const url = inject("url")


// · translations
const translations = {
    workflows: I18n.t('core.workflows'),
    core: I18n.t('core.shared')
}


// · table visible columns
const columns = [{
    field: "name",
    label: "Status"
}, {
    field: "category",
    label: "Category"
}, {
    field: "statuses",
    label: "Connected to",
    align: 'center'
}]



const modified = ref(false)


// change the type of the selected status and reorganize the rest of 
// statuses if needed ej. cant exists two initial statuses
function changeStatusType(selected_status, new_status_type){

    // go over all the statuses of the workflow
    for(let key in storeWorkflow.workflow.statuses){

        // get the details of the status in the loop
        let status = storeWorkflow.workflow.statuses[key]

        // work with the selected status only
        if(status.id == selected_status.id){

            // update the type
            storeWorkflow.workflow.statuses[key].status_type = new_status_type

            // due our work with this status is done
            continue
        }

        // be sure cant be two statuses with as initial
        if(status.status_type == 'initial'){

            // if selected another status as initial I should reorganize 
            storeWorkflow.workflow.statuses[key].status_type = 'normal'

        }
    }
}


// · 
function panelNext(status) {
    storeWorkflow.panelNext = true
    storeWorkflow.selectedStatus = status
}


// · 
watch(() => storeWorkflow.workflow, (newVal) => {
    modified.value = true
}, {
    deep: true
})

</script>
<template>
    <div class="block">
        <!-- Status workflows form -->
        <fieldset :disabled="!storeWorkflow.workflow.id">
            <form @submit.prevent="storeWorkflow.postStatus()">
                <!-- Workflow status name -->
                <div class="columns is-marginless has-border-bottom">
                    <div class="column">
                        <label class="label">
                            {{ translations.workflows.view_title_add_new_status }}
                        </label>
                    </div>
                    <div class="column is-8">
                        <input class="input" type="text" v-model="storeWorkflow.status.name">
                    </div>
                    <div class="column">
                        <lesli-button icon="add" :loading="storeWorkflow.status.loading">
                            Add
                        </lesli-button>  
                    </div>
                </div>
            </form>
        </fieldset>

        <div v-if="modified" class="has-text-centered has-text-warning-dark mb-5">
            <span><b>*</b> changes dont saved <b>*</b></span>
        </div>

        <lesli-table 
            v-if="storeWorkflow.workflow.statuses"
            :columns="columns"
            :records="storeWorkflow.workflow.statuses">
            <template #category="{ record }">
                <p class="icon-text has-text-info" v-if="record.status_type == 'initial'">
                    <span class="icon">
                        <span class="material-icons">
                            play_arrow
                        </span>
                    </span>
                    <span>
                        {{ translations.workflows.messages_info_tooltip_status_initial }}
                    </span>
                </p>
                <p class="icon-text has-text-primary" v-if="record.status_type == 'normal'">
                    <span class="icon">
                        <span class="material-icons">
                            done
                        </span>
                    </span>
                    <span>
                        Normal
                    </span>
                </p>
                <p class="icon-text has-text-success" v-if="record.status_type == 'completed_successfully'">
                    <span class="icon">
                        <span class="material-icons">
                            check_circle
                        </span>
                    </span>
                    <span>
                        {{ translations.workflows.messages_info_tooltip_status_completed_successfully }}
                    </span>
                </p>
                <p class="icon-text has-text-danger" v-if="record.status_type == 'completed_unsuccessfully'">
                    <span class="icon">
                        <span class="material-icons">
                            error_outline
                        </span>
                    </span>
                    <span>
                        {{ translations.workflows.messages_info_tooltip_status_completed_unsuccessfully }}
                    </span>
                </p>
            </template>
            <template #statuses="{ record }">
                {{ record.next.length }} statuses
            </template>
            <template #options="{ record }">
                <a class="dropdown-item" @click="panelNext(record)">
                    <span class="icon">
                        <span class="material-icons">
                            cable
                        </span>
                    </span>
                    Connect statuses
                </a>
                <hr class="dropdown-divider">
                <a class="dropdown-item" @click="changeStatusType(record, 'initial')">
                    <span class="icon">
                        <span class="material-icons">
                            start
                        </span>
                    </span>
                    Mark as initial
                </a>
                <a class="dropdown-item" @click="changeStatusType(record, 'normal')">
                    <span class="icon">
                        <span class="material-icons">
                            check
                        </span>
                    </span>
                    Mark as regular
                </a>
                <a class="dropdown-item" @click="changeStatusType(record, 'completed_successfully')">
                    <span class="icon">
                        <span class="material-icons">
                            stop
                        </span>
                    </span>
                    End successful
                </a>
                <a class="dropdown-item" @click="changeStatusType(record, 'completed_unsuccessfully')">
                    <span class="icon">
                        <span class="material-icons">
                            cancel
                        </span>
                    </span>
                    End failure
                </a>
                <hr class="dropdown-divider">
                <a class="dropdown-item" @click="storeWorkflow.deleteStatus(record.id)">
                    <span class="icon-text">
                        <span class="icon">
                            <span class="material-icons">
                                delete_outline
                            </span>
                        </span>
                        <span>
                            Delete status
                        </span>
                    </span>
                </a>
            </template>
        </lesli-table>
        <button class="button is-primary" @click="storeWorkflow.putWorkflow()">
            <span class="icon">
                <span class="material-icons">
                    save
                </span>
            </span>
            <span>
                <b>save changes</b>
            </span>
        </button>
    </div>
</template>
