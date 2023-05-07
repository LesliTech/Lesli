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
import { ref, computed, onMounted } from "vue"


// · import stores
import { useDashboard } from "Lesli/shared/stores/dashboard"


// · implement store
const storeDashboard = useDashboard()


// · defining props
const props = defineProps({
    engine: {
        type: String,
        required: true,
    }
})



// · defining translations
const translations = {
    main: I18n.t(`${props.engine}.dashboards`),
    dashboards: I18n.t('core.dashboards'),
    core: I18n.t('core.shared')
}


// · columns of the table
const columns = [{
    field: "name",
    label: translations.dashboards.column_name,
}, {
    field: "default",
    label: translations.dashboards.column_default,
}, {
    field: "created_at",
    label: translations.dashboards.column_created_at,
}, {
    field: "updated_at",
    label: translations.dashboards.column_updated_at,
}]

onMounted(() => {
    storeDashboard.engine = props.engine
    storeDashboard.fetchDashboards()
})

</script>
<template>
    <section class="application-component">
        
        <lesli-header :title="translations.dashboards.view_title_main">
            <lesli-button
                outlined
                icon="refresh"
                :loading="storeDashboard.loading"
                @click="storeDashboard.getDashboards(props.engine)">
                {{ translations.core.view_text_btn_reload }}
            </lesli-button>
            
            <lesli-button  icon="add" :to="url[props.engine]('dashboards/new')">
                add
            </lesli-button>
        </lesli-header>

        <lesli-toolbar @search="storeDashboard.searchDashboards" :search-placeholder="translations.dashboards.view_placeholder_filter_text" class="mt-4">
        </lesli-toolbar>

        <lesli-table 
            :columns="columns" 
            :records="storeDashboard.dashboards"
            :link="(dashboard) => url[props.engine](`dashboards/${dashboard.id}/edit`)">
        </lesli-table>

    </section>
</template>