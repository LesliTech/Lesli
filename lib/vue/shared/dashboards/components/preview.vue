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
import { useDashboard } from "Lesli/shared/stores/dashboard"


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


// · 
function remove(component) {
    
    component._destroy = true
}

</script>
<template>
    <div class="columns is-multiline is-variable is-4 dashboard-components">
        <template v-for="(component, index) in storeDashboard.dashboard.components" :key="index">
            <div :class="['column', 'is-' + component?.layout]" v-if="!component._destroy">

                <!-- Dashboard widget component when in edition mode -->
                <div class="edit">


                    <!-- Dashboard widget preview -->
                    <component :component.sync="component" :is="props.renderComponents[component.component_id]">
                    </component>


                    <!-- Edition controls -->
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
                            <p class="control control-label has-text-centered">
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

                        <div class="has-text-centered">
                            <lesli-button small danger icon="delete" @click="remove(component)">
                                remove
                            </lesli-button>
                        </div>
                    </div>
                </div>
            </div>
        </template>
    </div>
</template>
<style>
.dashboard-components .edit {
    border-radius: 6px;
    padding: 1.2rem 1.4rem;
    border: 1px solid #CCC;
    background-color: #FFF8F8;
}
.dashboard-components .edit .control-label {
    width: 100px;
}
</style>
