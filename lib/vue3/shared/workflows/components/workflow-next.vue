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
import { ref, reactive, onMounted, watch, computed, inject } from "vue"


// · import stores
import { useWorkflow } from "LesliVue/stores/shared/workflow"


// · implement stores
const storeWorkflow = useWorkflow()


// · Declaring translations paths
const translations = {
    main: I18n.t('shared.resources'),
}


// · 
function addStatus(status) {
    let i = storeWorkflow.workflow.statuses.findIndex(s => s.id == storeWorkflow.selectedStatus.id)
    storeWorkflow.workflow.statuses[i].next.push(status.id)
}

</script>
<template>
    <lesli-panel
        :title="'Connect statuses to ' + storeWorkflow.selectedStatus.name"
        v-model:open="storeWorkflow.panelNext">
        <template #default>
            <ul class="statuses-available2 p-5">
                <li
                    :class="[{ 'selected': storeWorkflow.selectedStatus?.next?.includes(status.id) }]"
                    v-for="status in storeWorkflow.workflow.statuses">
                    <a @click="addStatus(status)">
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
            <div class="px-5">
                <button class="button is-primary">
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
    </lesli-panel>
</template>
<style>
    .statuses-available2 li a{
        display: block;
        padding: .6rem 1rem;
        margin-bottom: 1rem;
        border-radius: 5px;
        border: 1px solid transparent;
        box-shadow: rgba(9, 30, 66, 0.25) 0px 4px 8px -2px, rgba(9, 30, 66, 0.08) 0px 0px 0px 1px;
    }
    .statuses-available2 li.selected a {
        border-color: blue;
        color: blue;
    }
    .statuses-available2 li.selected a span.material-icons{
        font-size: 1.1rem;
        color: blue;
    }
</style>
