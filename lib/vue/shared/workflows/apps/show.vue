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
import { onMounted, inject, ref } from "vue"
import { useRouter, useRoute } from 'vue-router'


// · import stores
import { useWorkflow } from "Lesli/stores/shared/workflow"


// · import components
import workflowForm from "../components/workflow-form.vue"
import componentWorkflowStatuses from "../components/workflow-statuses.vue"
import componentWorkflowAssociations from "../components/workflow-associations.vue"
import componentWorkflowConnections from "../components/workflow-connections.vue"
import componentWorkflowActions from "../components/workflow-actions.vue"
import componentWorkflowChecks from "../components/workflow-checks.vue"
import componentWorkflowDelete from "../components/workflow-delete.vue"
import componentWorkflowNext from "../components/workflow-next.vue"


// · defining props
const props = defineProps({
    appMountPath: {
        type: String,
        required: false,
        default: "",
    },
    // · prop that indicates the cloud module that will be used for interacting with the backend.
    cloudModule: {
        type: String,
        required: true,
    },
    // · prop that indicates the resource that you need to interact with.
    cloudObject: {
        type: String,
        required: true,
    },
})


// · implement stores
const storeWorkflow = useWorkflow()


// · initialize/inject plugins
const router = useRouter()
const route = useRoute()
const url = inject("url")


// set props to store
storeWorkflow.cloudModule = props.cloudModule
storeWorkflow.cloudObject = props.cloudObject


// · translations
const translations = {
    workflows: I18n.t('core.workflows'),
    core: I18n.t('core.shared')
}


// · 
onMounted(() => {
    storeWorkflow.fetchWorkflow(route.params?.id)
})
</script>
<template>
    <section class="application-component">
        <lesli-header :title="storeWorkflow.workflow.name">
            <lesli-button icon="list" :to="url.root(props.appMountPath)">
                {{ translations.core.view_btn_list }}
            </lesli-button>
            <lesli-button icon="settings" icon-only>
            </lesli-button>
        </lesli-header>

        <lesli-tabs v-model="storeWorkflow.tab">
            <lesli-tab-item icon="done" title="Statuses">
                <component-workflow-statuses :app-mount-path="props.appMountPath" is-editable></component-workflow-statuses>
            </lesli-tab-item>

            <lesli-tab-item icon="cable" title="Connections">
                <component-workflow-connections></component-workflow-connections>
            </lesli-tab-item>

            <lesli-tab-item icon="auto_awesome" title="Automation" paddingless>
                <component-workflow-actions></component-workflow-actions>
            </lesli-tab-item>

            <lesli-tab-item icon="security" title="Validations" paddingless>
                <component-workflow-checks></component-workflow-checks>
            </lesli-tab-item>

            <lesli-tab-item icon="share" title="Associations">
                <component-workflow-associations></component-workflow-associations>
            </lesli-tab-item>

            <lesli-tab-item icon="delete_outline" title="Delete">
                <component-workflow-delete></component-workflow-delete>
            </lesli-tab-item>
        </lesli-tabs>
    </section>
    <component-workflow-next></component-workflow-next>
</template>
