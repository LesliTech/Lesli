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
import { useRouter } from 'vue-router'


// · import stores
import { useWorkflow } from "LesliVue/stores/shared/workflow"

// · import components
import workflowForm from "../components/workflow-form.vue"
import checksList from "./checks/index.vue"
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
        type: Object,
        required: true,
    },
})

// · implement stores
const storeWorkflow = useWorkflow()

// · initialize/inject plugins
const router = useRouter()
const url = inject("url")


// set props to store
storeWorkflow.cloudModule = props.cloudModule
storeWorkflow.cloudObject = props.cloudObject

// · translations
const translations = {
    workflows: I18n.t('core.workflows'),
    core: I18n.t('core.shared')
}

/**
 * @description This function is used to delete a workflow
 */
 const deleteWorkflow = () => {
    storeWorkflow.deleteWorkflow().then(()=> {
        router.push(url.root(`${props.appMountPath}`).s)
    })
}

</script>

<template>
    <section class="application-component">
        <lesli-header :title="translations.workflows.view_title_main">
            <lesli-button icon="list" :to="url.help('workflows')">
                {{ translations.core.view_btn_list }}
            </lesli-button>
        </lesli-header>

        <lesli-tabs v-model="tab">
            <lesli-tab-item title="Edition mode">
                <workflow-form :app-mount-path="props.appMountPath" is-editable></workflow-form>
            </lesli-tab-item>

            <lesli-tab-item title="Chart mode">

            </lesli-tab-item>
            
            <lesli-tab-item title="Actions">
            </lesli-tab-item>

            <lesli-tab-item title="Checks">
                <checks-list :app-mount-path="props.appMountPath"></checks-list>
            </lesli-tab-item>

            <lesli-tab-item title="Associations">
                <association-form></association-form>
            </lesli-tab-item>

            <lesli-tab-item title="Delete">
                <div class="card">
                    <div class="card-content">
                        <h5 class="title is-5">{{translations.workflows.view_title_delete_workflow}}</h5>
                        <span class="has-text-danger">
                            {{translations.workflows.messages_danger_delete_workflow_description}}
                        </span>
                        <br>
                        <br>
                        <lesli-button @click="deleteWorkflow">Delete</lesli-button>
                    </div>
                </div>
                
            </lesli-tab-item>

        </lesli-tabs>
    </section>
</template>
