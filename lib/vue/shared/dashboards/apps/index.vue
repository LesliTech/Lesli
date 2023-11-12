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
