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
import { onMounted, inject } from "vue"
import { useRouter } from 'vue-router'


// · import stores
import { useWorkflow } from "Lesli/vue/stores/shared/workflow"

// · import components
import workflowForm from "../components/workflow-form.vue"
import checksList from "./checks/index.vue"
import actionsList from "./actions/index.vue"
import associationForm from "../components/associations.vue"
import chart from "../components/chart.vue"

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
            <lesli-button icon="list" :to="url.root(props.appMountPath)">
                {{ translations.core.view_btn_list }}
            </lesli-button>
        </lesli-header>

        <lesli-tabs v-model="tab">
            <lesli-tab-item title="Edition mode">
                <workflow-form :app-mount-path="props.appMountPath" is-editable></workflow-form>
            </lesli-tab-item>

            <lesli-tab-item title="Chart mode">
                <chart></chart>
            </lesli-tab-item>
            
            <lesli-tab-item title="Actions">
                <actions-list></actions-list>
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
