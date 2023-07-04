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
import { onMounted, computed } from "vue"


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
                    <component :component.sync="component" :is="props.components[component.component_id]">
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
