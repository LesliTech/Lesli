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
import { onMounted, inject, ref } from "vue"
import { useRouter, useRoute } from 'vue-router'


// · import stores
import { useWorkflow } from "LesliVue/stores/shared/workflow"


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

            <lesli-tab-item icon="share" title="Associations" paddingless>
                <component-workflow-associations></component-workflow-associations>
            </lesli-tab-item>

            <lesli-tab-item icon="delete_outline" title="Delete">
                <component-workflow-delete></component-workflow-delete>
            </lesli-tab-item>
        </lesli-tabs>
    </section>
    <component-workflow-next></component-workflow-next>
</template>
