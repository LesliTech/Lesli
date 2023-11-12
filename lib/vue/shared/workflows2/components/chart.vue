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
import { onMounted, inject, watch } from "vue"
import { useRouter } from 'vue-router'


// · import stores
import { useWorkflow } from "Lesli/stores/shared/workflow"


// · import components
import mermaidChart from "Leslicomponents/diagrams/mermaid.vue"


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


// set props to store


// · translations
const translations = {
    workflows: I18n.t('core.workflows'),
    core: I18n.t('core.shared')
}


watch(()=> storeWorkflow.workflow, (workflow) => {
    workflow.statuses.forEach(status => {
        console.log(JSON.parse(JSON.stringify(status)))
    })
})


</script>

<template>
    <mermaid-chart type="graph" :markers="storeWorkflow.workflow.statuses" v-if="storeWorkflow.workflow.statuses">
    </mermaid-chart>
</template>
