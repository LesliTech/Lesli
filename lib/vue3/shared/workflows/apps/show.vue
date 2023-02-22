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
import componentWorkflowStatuses from "../components/workflow-statuses.vue"
import componentWorkflowVisualize from "../components/workflow-visualize.vue"
//import componentWorkflowNext from "../components/workflow-next.vue"


import workflowForm from "../components/workflow-form.vue"
import checksList from "./checks/index.vue"
import actionsList from "./actions/index.vue"
import associationForm from "../components/associations.vue"



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


//
const tab = ref(1)


// · translations
const translations = {
    workflows: I18n.t('core.workflows'),
    core: I18n.t('core.shared')
}


// · This function is used to delete a workflow
const deleteWorkflow = () => {
    storeWorkflow.deleteWorkflow().then(()=> {
        router.push(url.root(`${props.appMountPath}`).s)
    })
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
        </lesli-header>

<!--
<lesli-tab-item title="Edition mode">
<workflow-form :app-mount-path="props.appMountPath" is-editable></workflow-form>
</lesli-tab-item>
-->

        <lesli-tabs v-model="tab">
            <lesli-tab-item title="Statuses">
                <component-workflow-statuses :app-mount-path="props.appMountPath" is-editable></component-workflow-statuses>
            </lesli-tab-item>

            <lesli-tab-item title="Visualize">
                <component-workflow-visualize></component-workflow-visualize>
            </lesli-tab-item>
        </lesli-tabs>
    </section>
    <!--component-workflow-next></component-workflow-next-->
</template>
