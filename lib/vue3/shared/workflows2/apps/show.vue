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
import { onMounted, inject } from "vue"
import { useRoute } from 'vue-router'


// · import stores
import { useWorkflow } from "LesliVue/stores/shared/workflow"
import componentStatuses from "../components/statuses.vue"

/*
import workflowForm from "../components/workflow-form.vue"
import checksList from "./checks/index.vue"
import actionsList from "./actions/index.vue"
import associationForm from "../components/associations.vue"
import chart from "../components/chart.vue"
*/


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
        type: Object,
        required: true,
    },
})

// · implement stores
const storeWorkflow = useWorkflow()


// · initialize/inject plugins
const route = useRoute()
const url = inject("url")


// · translations
const translations = {
    workflows: I18n.t('core.workflows'),
    core: I18n.t('core.shared')
}


// · 
onMounted(() => {

    // set props to store
    storeWorkflow.cloudModule = props.cloudModule
    storeWorkflow.cloudObject = props.cloudObject

    storeWorkflow.fetchWorkflow(route.params?.id).then(()=>{

        
    })
})

</script>

<template>
    <application-component>
        <lesli-header :title="storeWorkflow.workflow.name">
            <lesli-button icon="settings" solid>
                Settings
            </lesli-button>
            <lesli-button icon="list" :to="url.root(props.appMountPath)">
                {{ translations.core.view_btn_list }}
            </lesli-button>
        </lesli-header>

        <lesli-tabs v-model="tab">
            <lesli-tab-item icon="check" title="Statuses">
                <component-statuses :app-mount-path="props.appMountPath" is-editable>
                </component-statuses>
            </lesli-tab-item>

            <lesli-tab-item title="Chart mode">
            </lesli-tab-item>
            
            <lesli-tab-item title="Actions">
            </lesli-tab-item>

            <lesli-tab-item title="Checks">
            </lesli-tab-item>

            <lesli-tab-item title="Associations">
            </lesli-tab-item>

            <lesli-tab-item title="Delete">
            </lesli-tab-item>
        </lesli-tabs>
    </application-component>
</template>
