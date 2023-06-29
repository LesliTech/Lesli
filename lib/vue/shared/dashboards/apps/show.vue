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

Lesli · Ruby on Rails SaaS development platform.

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
import { useDashboard } from "Lesli/shared/stores/dashboard"


// · implement stores
const storeDashboard = useDashboard()


// · 
const props = defineProps({
    engine: {
        type: String, 
        require: true
    },
    components: {
        type: Object,
        require: true
    }
})


// · 
onMounted(() => {
    storeDashboard.engine = props.engine
    storeDashboard.getDashboard(props.engine)
})

</script>
<template>
    <application-component>
        <div class="columns is-multiline is-variable is-4 dashboard-components">
            <div 
                v-for="(component, index) in storeDashboard.dashboard.components" :key="index"
                :class="['column', 'is-' + component?.layout]">
                <component :component.sync="component" :is="components[component.component_id]"></component>
            </div>
        </div>
    </application-component>
</template>
