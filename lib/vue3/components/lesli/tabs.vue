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
import { ref, reactive, onMounted, watch, computed, useSlots, provide } from "vue"


// · gettings slots
const slots = useSlots().default()


// · defining props
const props = defineProps({
    modelValue: {
        type: [String, Number]
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
                    <a @click="selectTab(index)">
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
