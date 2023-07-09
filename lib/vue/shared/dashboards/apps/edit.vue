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
