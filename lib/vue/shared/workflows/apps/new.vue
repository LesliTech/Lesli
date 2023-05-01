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
import { onMounted } from "vue"
import { useRouter, useRoute } from 'vue-router'


// · import stores
import { useWorkflow } from "Lesli/stores/shared/workflow"

// · import components
import workflowForm from "../components/workflow-form.vue"


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

// · translations
const translations = {
    workflows: I18n.t('core.workflows'),
    core: I18n.t('core.shared')
}

// set props to store
storeWorkflow.cloudModule = props.cloudModule
storeWorkflow.cloudObject = props.cloudObject

</script>

<template>
    <section class="application-component">
        <lesli-header :title="translations.workflows.view_title_main">
            <lesli-button icon="list" :to="url.root(props.appMountPath)">
                {{ translations.core.view_btn_list }}
            </lesli-button>
        </lesli-header>

        <lesli-tabs v-model="tab">
            <lesli-tab-item title="Edition mode">
                <workflow-form :app-mount-path="props.appMountPath"></workflow-form>
            </lesli-tab-item>
        </lesli-tabs>
    </section>
</template>
