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
function sizeIncrease(component) {
    if (component.layout >= 12) {
        return 
    }
    component.layout++
}


// · 
function sizeDecrease(component) {
    if (component.layout <= 3) {
        return 
    }
    component.layout--
}

</script>
<template>
    <div class="columns is-multiline is-variable is-4 dashboard-components">
        <div 
            :class="['column', 'is-' + component?.layout]"
            v-for="(component, index) in storeDashboard.dashboard.components" :key="index">

            <component :component.sync="component" :is="props.renderComponents[component.component_id]">
            </component>

            <div class="mt-4 mb-2">
                <div class="field has-addons is-justify-content-center">
                    <p class="control">
                        <button class="button is-small" @click="sizeDecrease(component)">
                            <span class="icon is-small">
                                <span class="material-icons">
                                    remove
                                </span>
                            </span>
                        </button>
                    </p>
                    <p class="control control-label has-text-centered px-4">
                        size    
                    </p>
                    <p class="control">
                        <button class="button is-small" @click="sizeIncrease(component)">
                            <span class="icon is-small">
                                <span class="material-icons">
                                    add
                                </span>
                            </span>
                        </button>
                    </p>
                </div>

                <div class="field has-addons is-justify-content-center">
                    <p class="control">
                        <button class="button is-small" @click="sizeDecrease(component)">
                            <span class="icon is-small">
                                <span class="material-icons">
                                    chevron_left
                                </span>
                            </span>
                        </button>
                    </p>
                    <p class="control control-label has-text-centered px-4">
                        position
                    </p>
                    <p class="control">
                        <button class="button is-small" @click="sizeIncrease(component)">
                            <span class="icon is-small">
                                <span class="material-icons">
                                    chevron_right
                                </span>
                            </span>
                        </button>
                    </p>
                </div>
            </div>
        </div>
    </div>
</template>
