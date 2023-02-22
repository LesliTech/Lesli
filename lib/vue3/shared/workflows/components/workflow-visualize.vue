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


function selectStatus(status){
    storeWorkflow.selected_status = status
}

function addStatus(status) {
    let i = storeWorkflow.workflow.statuses.findIndex(s => s.id == storeWorkflow.selected_status.id)
    storeWorkflow.workflow.statuses[i].next.push(status.id)
}

function enterFullView() {
    fullView.value = !fullView.value
}

</script>

<template>

    <div class="columns">
        <div class="column" v-if="!fullView">
            <ul>
                <li 
                    @click="selectStatus(status)"
                    :class="[{ 'selected': storeWorkflow.selected_status.id == status.id }]"
                    v-for="status in storeWorkflow.workflow.statuses">
                    <span class="icon-text">
                        <span>{{ status.name }} </span>
                        <span class="icon">
                            <span class="material-icons">
                                done
                            </span>
                        </span>
                    </span>
                </li>
            </ul>
            <button class="button" @click="storeWorkflow.updateWorkflow()">save</button>
        </div>
        <div class="column is-flex-grow-1">
            <button class="button" @click="enterFullView()">
                <span class="icon-text">
                    <span>full view</span>
                    <span class="icon">
                        <span class="material-icons">
                            open_in_full
                        </span>
                    </span>
                </span>
            </button>
            <mermaid-chart type="stateDiagram-v2" :markers="storeWorkflow.workflow.statuses" v-if="storeWorkflow.workflow.statuses">
            </mermaid-chart>
        </div>
        <div class="column" v-if="!fullView">
            <ul>
                <li
                    @click="addStatus(status)"
                    :class="[{ 'selected': storeWorkflow.selected_status?.next?.includes(status.id) }]"
                    v-for="status in storeWorkflow.workflow.statuses">
                    <span class="icon-text">
                        <span>{{ status.name }} </span>
                        <span class="icon">
                            <span class="material-icons">
                                check_circle
                            </span>
                        </span>
                    </span>
                </li> 
            </ul>
        </div>
    </div>
</template>
<style>
    .column li {
        padding: .6rem 1rem;
        margin-bottom: .4rem;
        border-radius: 5px;
        border: 1px solid transparent;
    }
    .column li span.icon-text {
        justify-content: space-between;
        width: 100%;
    }
    .column li span.material-icons{
        font-size: 0px;
    }
    .column li.selected {
        border-color: blue;
    }
    .column li.selected span.material-icons{
        font-size: 1.1rem;
        color: blue;
    }
</style>
