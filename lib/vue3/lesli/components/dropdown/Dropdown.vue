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
import { computed, ref } from "vue"

// · defining translations
const translations = {
    core: {
        shared: I18n.t("core.shared"),
    }
}

// · defining props
const props = defineProps({
    options: {
        type: Array,
        required: true,
    },
    label: {
        type: String,
        required: false,
        default: I18n.t("core.shared").view_text_select,
    },
})  

// · defining emits 
const emit = defineEmits(['update:modelValue']);

// · variable used to show the dropdown menu
const showDropdown = ref(false)

// · unique id for the dropdown
const dropdownMenuId = ref(Math.random().toString(36).slice(3, 9) + '-dropdown-menu')


const isActiveDropdown = computed(() => {
    return showDropdown.value ? "is-active" : ""
})


/**
 * @description This function toggles the dropdown menu
 */
const onDropdown = () => {
    // · toggle dropdown
    showDropdown.value = !showDropdown.value
}

/**
 * @param {String} option
 * @description when dropdown's option is clicked, update modelValue
 */
const onSelectOption = (selectedOption) => {
    emit("update:modelValue", selectedOption.value)
}

// when user click outside the dropdown, close the dropdown
window.addEventListener("click", (e) => {
    if (!e.target.classList.contains("dropdown-clickeable")) showDropdown.value = false
})
</script>

<template>
    <div @click="onDropdown"  class="dropdown" :class="isActiveDropdown">
        <div class="dropdown-trigger">
            <button
                class="button is-primary dropdown-clickeable"
                aria-haspopup="true"
                :aria-controls="dropdownMenuId"
            >
                <span class="dropdown-clickeable">{{ props.label }}</span>
                <span class="icon is-small">
                    <span class="material-icons dropdown-clickeable">arrow_drop_down</span>
                </span>
            </button>
        </div>
        <div class="dropdown-menu" :id="dropdownMenuId" role="menu">
            <div class="dropdown-content">
                <a v-for="option in props.options" @click="onSelectOption(option)" :key="option.value" class="dropdown-item">{{ option.label }}</a>
            </div>
        </div>
    </div>
</template>
