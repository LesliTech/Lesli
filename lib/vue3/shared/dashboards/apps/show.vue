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


// · 
import { defineAsyncComponent } from "vue";

import helloWorld from "LesliVue/shared/dashboards/dashcomponents/helloWorld.vue"

const dashcomponents = {
    "core-hello-world": helloWorld 
}

const components = [{
    id: "core-hello-world",
    size: "10"
}]

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
