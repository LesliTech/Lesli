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
    <section class="application-component">
        <div class="columns is-multiline is-variable is-4 dashboard-components">
            <div 
                v-for="(component, index) in storeDashboard.dashboard.components" :key="index"
                :class="['column', 'is-' + component?.layout]">
                <component :component.sync="component" :is="components[component.component_id]"></component>
            </div>
        </div>
    </section>
</template>