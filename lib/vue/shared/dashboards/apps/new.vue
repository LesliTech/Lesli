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
import { onMounted } from "vue"
import { useRouter, useRoute } from 'vue-router'


// · import stores
import { useDashboard } from "Lesli/shared/stores/dashboard"


// · import components
import dashboardForm from "../components/form.vue"


// · defining props
const props = defineProps({
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
            <lesli-button icon="list" :to="url[props.cloudModule]('dashboards')">
                {{ translations.core.view_btn_list }}
            </lesli-button>
        </lesli-header>

        <dashboard-form :cloud-module="props.cloudModule"></dashboard-form>

    </section>
</template>
