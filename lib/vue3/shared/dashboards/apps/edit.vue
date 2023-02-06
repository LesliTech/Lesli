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
import { useDashboard } from "LesliVue/stores/shared/dashboard"

// · import components
import dashboardForm from "../dashcomponents/dashboard-form.vue"
import render from "../dashcomponents/render.vue"


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
    }
})

// · implement stores
const storeDashboard = useDashboard()

// · translations
const translations = {
    main: I18n.t(`${props.cloudModule}.dashboards`),
    dashboards: I18n.t('core.dashboards'),
    core: I18n.t('core.shared')
}

// set props to store
storeDashboard.cloudModule = props.cloudModule

onMounted(() => {
    storeDashboard.getDashboardOptions()
})

</script>

<template>
    <section class="application-component">
        <lesli-header :title="translations.dashboards.view_title_main">
            <lesli-button icon="list" :to="url.root(props.appMountPath)">
                {{ translations.core.view_btn_list }}
            </lesli-button>
        </lesli-header>


        <lesli-tabs v-model="tab">
            <lesli-tab-item title="Edition mode">
                <dashboard-form :app-mount-path="props.appMountPath" is-editable></dashboard-form>
            </lesli-tab-item>

            <lesli-tab-item title="Render view">
                <render :cloud-module="'help'"></render>
            </lesli-tab-item>

            <lesli-tab-item :title="translations.dashboards.view_tab_title_delete">
                <div class="card">
                    <div class="card-content">
                        <span class="has-text-danger">
                            {{translations.dashboards.messages_danger_delete_confirmation}}
                        </span>
                        <br>
                        <br>
                        <lesli-button @click="storeDashboard.deleteDashboard">Delete</lesli-button>
                    </div>
                </div>
            </lesli-tab-item>

        </lesli-tabs>

    </section>
</template>
