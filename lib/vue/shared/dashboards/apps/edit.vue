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
import { useRouter, useRoute } from 'vue-router'


// · import stores
import { useDashboard } from "Lesli/stores/shared/dashboard"


// · import components
import dashboardForm from "../components/form.vue"
import dashboardPreview from "../components/preview.vue"


// ·
const router = useRouter()
const url = inject("url")


// · defining props
const props = defineProps({
    // · prop that indicates the cloud module that will be used for interacting with the backend.
    cloudModule: {
        type: String,
        required: true,
    },
    renderComponents: {
        type: Object,
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

/**
 * @description This function is used to delete a dashboard
 */
 const onDeleteDashboard = () => {
    storeDashboard.deleteDashboard().then(()=> {
        router.push(url[props.cloudModule]('dashboards').s)
    })
}


onMounted(() => {
    storeDashboard.getDashboardOptions()
})

</script>

<template>
    <section class="application-component">
        <lesli-header :title="storeDashboard.dashboard.name">
            <lesli-button icon="list" :to="url[props.cloudModule]('dashboards')">
                {{ translations.core.view_btn_list }}
            </lesli-button>
        </lesli-header>
        <dashboard-form :cloud-module="props.cloudModule" is-editable></dashboard-form>
        <dashboard-preview :cloud-module="props.cloudModule" :render-components="props.renderComponents"></dashboard-preview>
    </section>
</template>
