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
import { useRouter, useRoute } from "vue-router"


// · import stores
import { useDashboard } from "Lesli/shared/stores/dashboard"


// · import components
import dashboardForm from "../components/form.vue"
import dashboardPreview from "../components/preview.vue"


// ·
const router = useRouter()
const url = inject("url")


// · defining props
const props = defineProps({
    engine: {
        type: String,
        required: true,
    },
    components: {
        type: Object,
        required: true,
    }
})


// · implement stores
const storeDashboard = useDashboard()


// · translations
const translations = {
    main: I18n.t(`${props.engine}.dashboards`),
    dashboards: I18n.t('core.dashboards'),
    core: I18n.t('core.shared')
}


const onDeleteDashboard = () => {
    storeDashboard.deleteDashboard().then(()=> {
        router.push(url[props.engine]('dashboards').s)
    })
}


onMounted(() => {
    storeDashboard.engine = props.engine
    storeDashboard.getDashboardOptions()
})

</script>
<template>
    <section class="application-component">
        <lesli-header :title="storeDashboard.dashboard.name">
            <lesli-button icon="list" :to="url[props.engine]('dashboards')">
                {{ translations.core.view_btn_list }}
            </lesli-button>
        </lesli-header>

        <dashboard-form :engine="props.engine" is-editable></dashboard-form>
        <dashboard-preview :engine="props.engine" :components="props.components"></dashboard-preview>
    </section>
</template>
