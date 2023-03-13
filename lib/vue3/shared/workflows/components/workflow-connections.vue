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
import { onMounted, inject, watch, ref } from "vue"
import { useRouter } from 'vue-router'


// · import stores
import { useWorkflow } from "LesliVue/stores/shared/workflow"


// · import components
import mermaidChart from "LesliVue/components/diagrams/mermaid.vue"


// · defining props
const props = defineProps({
    appMountPath: {
        type: String,
        required: false,
        default: "",
    }
})


// · implement stores
const storeWorkflow = useWorkflow()


// · initialize/inject plugins
const router = useRouter()
const url = inject("url")


// · translations
const translations = {
    workflows: I18n.t('core.workflows'),
    core: I18n.t('core.shared')
}


// · 
const fullView = ref(false)


// · 
const changed = ref(false)


// · 
function selectStatus(status){

    // Important: here we keep the selectedStatus with a reference 
    // of the status in the workflow object in the store, so,
    // we can modify selectedStatus directly and the changes will 
    // affect the corresponding status in the workflow in the store :) 
    storeWorkflow.selectedStatus = status
}


// · add or remove a next status to the selected status
function addRemoveStatus(status) {

    // search for the status (validate if status is already in the next statuses for the current status)
    let i = storeWorkflow.selectedStatus.next_statuses.findIndex(statusId => statusId == status.id)

    // remove the status if exists
    if (i >= 0) {
        storeWorkflow.selectedStatus.next_statuses.splice(i, 1)
        return
        
    }

    // add the status if the status does not exist
    storeWorkflow.selectedStatus.next_statuses.push(status.id)
    
}


// · 
function enterFullView() {
    fullView.value = !fullView.value
}
</script>
<template>
    <div class="mb-4" v-if="changed">
        <button class="button is-primary is-fullwidth" @click="storeWorkflow.putWorkflow()">
            <span class="icon">
                <span class="material-icons">
                    save
                </span>
            </span>
            <span>
                <b>save workflow changes</b>
            </span>
        </button>
    </div>
    {{ storeWorkflow.selectedStatus.next_statuses }}
    <div class="columns mb-4">
        <div class="column">
            <h4 class="is-4">
                Statuses
            </h4>
        </div>
        <div class="column has-text-centered">
            <button class="button" @click="enterFullView()">
                <span class="icon">
                    <span class="material-icons">
                        open_in_full
                    </span>
                </span>
            </button>
        </div>
        <div class="column has-text-right">
            <h4 class="is-4">
                Next statuses
            </h4>
        </div>
    </div>
    <div class="columns">
        <div class="column" v-if="!fullView">
            <ul class="statuses-working">
                <li>
                    <a 
                        @click="selectStatus(status)"
                        :class="[{ 'selected': storeWorkflow.selectedStatus.id == status.id }]"
                        v-for="status in storeWorkflow.workflow.statuses">
                        <span class="icon-text">
                            <span>{{ status.name }} </span>
                            <span class="icon">
                                <span class="material-icons">
                                    done
                                </span>
                            </span>
                        </span>
                    </a>
                </li>
            </ul>
        </div>
        <div class="column is-flex-grow-1">
            <mermaid-chart 
                type="stateDiagram-v2" 
                v-if="storeWorkflow.workflow.statuses"
                :markers="storeWorkflow.workflow.statuses"
                @change="() => { changed = true }">
            </mermaid-chart>
        </div>
        <div class="column" v-if="!fullView">
            <ul class="statuses-available">
                <li>
                    <a
                        @click="addRemoveStatus(status)"
                        :class="[{ 'selected': storeWorkflow.selectedStatus?.next_statuses?.includes(status.id) }]"
                        v-for="status in storeWorkflow.workflow.statuses">
                        <span class="icon-text">
                            <span class="icon">
                                <span class="material-icons">
                                    done
                                </span>
                            </span>
                            <span>{{ status.name }} </span>
                        </span>
                    </a>
                </li> 
            </ul>
        </div>
    </div>
    <div v-if="changed">
        <button class="button is-primary is-fullwidth" @click="storeWorkflow.putWorkflow()">
            <span class="icon">
                <span class="material-icons">
                    save
                </span>
            </span>
            <span>
                <b>save workflow changes</b>
            </span>
        </button>
    </div>
</template>
<style>
    .column li a{
        display: block;
        padding: .6rem 1rem;
        margin-bottom: 1rem;
        border-radius: 5px;
        border: 1px solid transparent;
        box-shadow: rgba(9, 30, 66, 0.25) 0px 4px 8px -2px, rgba(9, 30, 66, 0.08) 0px 0px 0px 1px;
    }
    .column li a span.icon-text {
        justify-content: space-between;
        width: 100%;
    }
    .column li a span.material-icons{
        font-size: 0px;
    }
    .column li a.selected {
        border-color: blue;
    }
    .column li a.selected span.material-icons{
        font-size: 1.1rem;
        color: blue;
    }
    .statuses-available li a {
        text-align: right;
    }
</style>
