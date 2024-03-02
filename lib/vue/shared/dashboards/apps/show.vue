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

Lesli · Ruby on Rails SaaS Development Framework.

Made with ♥ by https://www.lesli.tech
Building a better future, one line of code at a time.

@contact  hello@lesli.tech
@website  https://www.lesli.tech
@license  GPLv3 http://www.gnu.org/licenses/gpl-3.0.en.html

// · ~·~     ~·~     ~·~     ~·~     ~·~     ~·~     ~·~     ~·~     ~·~
// · 
*/


// · import vue tools
import { onMounted } from "vue"


// · import lesli stores
import { useDashboard } from "Lesli/vue/shared/stores/dashboard"


// · implement stores
const storeDashboard = useDashboard()


// · 
const props = defineProps({
    components: {
        type: Object,
        require: false,
        default: {}
    }
})


// · 
onMounted(() => {
    storeDashboard.setEngine(lesli.engine)
    storeDashboard.getDashboard()
})

</script>
<template>
    <lesli-application-container>

        <lesli-header :title="storeDashboard.dashboard.name">
            <lesli-button icon="edit"></lesli-button>
        </lesli-header>

        <template v-if="storeDashboard.dashboard.components">
            <div class="columns is-multiline is-variable is-4 dashboard-components">
                <template v-for="(component, index) in storeDashboard.dashboard.components" :key="index">
                    <div :class="['column', 'is-' + component?.layout]">
                        <component 
                            :component.sync="component" 
                            :is="props.components[component.component_id]">
                        </component>
                    </div>
                </template>
            </div>
        </template>

        <lesli-empty 
            v-if="!storeDashboard.dashboard.components || storeDashboard.dashboard.components.length <= 0" 
            text="Empty dashboard">
        </lesli-empty>
    </lesli-application-container>
</template>
