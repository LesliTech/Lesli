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
import { ref, reactive, onMounted, watch, computed, useSlots, provide } from "vue"


// · gettings slots
const slots = useSlots().default()


// · defining props
const props = defineProps({
    modelValue: {
        type: [String, Number],
        required: false,
        default: 0,
    }
})


// · defining emitters
const emit = defineEmits(['update:modelValue'])


// here we are going to store the tab that the user clicked to be activated
const active = ref(0)


// array of self-registered tab items, every tab item is going to register itself through
// provide/inject parameters, through provide we are going to send the tabs array to every 
// tab item, so every item is going to push his own instance to the array
const tabItems = ref([])


// change the visible tab item 
function selectTab(i) {
    emit("update:modelValue", active.value);
    active.value = i
}


// build a css class for the active tabs
function activeTabCssClass(current) {

    if (current == active.value) {
        return "is-active"
    }

    return;

}


// provide through the "tabs" key the currently active tab and all the tabs registered
provide('tabs', { active, tabItems })


//
onMounted(() => {
    active.value = props.modelValue
})

</script>
<template>
    <div class="lesli-tab">
        <div class="tabs">
            <ul>
                <li :class="activeTabCssClass(index)"
                    v-for="(item, index) in slots" :key="index">
                    <a 
                        v-if="!!item.props"
                        @click="selectTab(index)">
                        <span v-if="!!item.props.icon" class="icon is-small">
                            <span class="material-icons">
                                {{ item.props.icon }}
                            </span>
                        </span>
                        <span>{{ item.props.title }}</span>
                    </a>
                </li>
            </ul>
        </div>
        <div class="tab-items">
            <slot></slot>
        </div>
    </div>
</template>
