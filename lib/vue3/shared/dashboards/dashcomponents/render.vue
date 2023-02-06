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
import { onMounted, computed } from "vue"


// · import lesli stores
import { useDashboard } from "LesliVue/stores/shared/dashboard"


// · implement stores
const storeDashboard = useDashboard()


// · 
const props = defineProps({
    cloudModule: {
        type: String, 
        require: true
    },
    renderComponents: {
        type: Object,
        require: true
    }
})


// · 
onMounted(() => {
    storeDashboard.getDashboard(props.cloudModule)
})

</script>
<template>
    <section class="application-component">
        <div class="columns is-variable is-2 is-multiline dashboard-components">
            <div 
                v-for="(component, index) in storeDashboard.dashboard.components" :key="index"
                :class="['column', 'is-' + component?.layout]">
                <component :component.sync="component" :is="`component-${component.component_id.replace(/\_/g,'-')}`"></component>
            </div>
        </div>
    </section>
</template>
