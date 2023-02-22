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

</script>
<template>
    <div class="columns">
        <div class="column">
            <div class="menu">
                <ul class="menu-list">
                    <li v-for="status in storeWorkflow.workflow.statuses">
                        <a class="list-item">
                            {{ status.name }}
                        </a>
                    </li>
                </ul>
            </div>
        </div>
        <div class="column is-flex-grow-1">
            <mermaid-chart type="graph" :markers="storeWorkflow.workflow.statuses" v-if="storeWorkflow.workflow.statuses">
            </mermaid-chart>
        </div>
        <div class="column">
            <div class="menu">
                <ul class="menu-list">
                    <li v-for="status in storeWorkflow.workflow.statuses">
                        <a class="list-item has-text-right">
                            {{ status.name }}
                        </a>
                    </li>
                </ul>
            </div>
        </div>
    </div>
</template>
<style>
    .columns {
        padding: 0.6rem
    }
    .column {
        padding: 0.6rem
    }
    .column p {
        width: 290px;
        border: 1px solid transparent;
        border-radius: 5px;
        padding: .8rem 1rem;
        box-shadow: rgba(9, 30, 66, 0.25) 0px 4px 8px -2px, rgba(9, 30, 66, 0.08) 0px 0px 0px 1px;
    }
    .column.selected p {
        border-color: blue;
    }
    .column p span.icon-text {
        justify-content: space-between;
        width: 100%;
    }
    .column p span.material-icons {
        font-size: 0;
    }
    .column.selected p span.material-icons {
        font-size: 1.1rem;
        color: blue;
    }
    section.lesli-panel div.lesli-panel-content {
        width: 640px;
    }
</style>
