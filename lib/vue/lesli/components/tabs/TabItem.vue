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
import { ref, reactive, onMounted, watch, computed, useAttrs, inject, watchEffect, getCurrentInstance } from "vue"


// · get component context
const instance = getCurrentInstance()


// · defining props
const props = defineProps({
    title: {
        type: String,
        required: true
    },
    icon: {
        type: String,
        required: false
    },
    show: {
        type: Boolean,
        required: false,
        default: false
    },
    paddingless: {
        type: Boolean,
        default: false,
        required: false
    }
})


// receive through the "tabs" key the currently active tab and all the tabs registered
const { tabItems, active } = inject('tabs')

// find the position of the current tab item in the array of registered tab items
const index = computed(() => tabItems.value.findIndex((target) => target.uid === instance.uid));

// we switch the tab item to active when the index (current tab) is equal to the active tab injected from Tab
const isActive = computed(() => index.value === active.value);

// autoregister the current tab item to the collection of tabs
watchEffect(() => {
    if (index.value === -1) {
        tabItems.value.push(instance);
    }
});

</script>
<template>
    <div v-if="isActive" :class="[{ 'p-5': !paddingless }]">
        <slot></slot>
    </div>
</template>
