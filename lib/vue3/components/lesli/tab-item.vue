<script setup>
/*
Copyright (c) 2022, all rights reserved.

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
    <div v-if="isActive">
        <slot></slot>
    </div>
</template>
