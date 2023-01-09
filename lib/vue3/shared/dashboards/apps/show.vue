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
    storeDashboard.getDashboard(cloudModule)
})

</script>
<template>
    <section class="application-component">
        <lesli-header title="My dashboard"></lesli-header>
        <div class="columns is-multiline">
            <div 
                v-for="(component, index) in components" :key="index"
                :class="['column', 'is-' + component?.size]">
                <component :component.sync="component" :is="dashcomponents[component.id]"></component>
            </div>
        </div>
    </section>
</template>
