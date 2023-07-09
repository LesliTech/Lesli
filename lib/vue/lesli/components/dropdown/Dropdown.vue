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
import { computed, ref } from "vue"

// · import components
import DropdownItem from "./DropdownItem.vue"

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

/**
 * @param {*} string to generate unique id
 * @description generate unique id for the dropdown
 * @returns {string} unique id
 */
const generateId = (string) => string + '-' + Math.random().toString(36).slice(3, 9)

// · variable used to show the dropdown menu
const showDropdown = ref(false)

// · unique id for the dropdown
const dropdownMenuId = ref(generateId('dropdown-menu'))
const dropdownClickeableClass = ref(generateId('dropdown-clickeable'))

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
    if (!e.target.classList.contains(dropdownClickeableClass.value)) showDropdown.value = false
})
</script>

<template>
    <div @click="onDropdown" :class="['dropdown', isActiveDropdown ]">
        <div class="dropdown-trigger">
            <button
                :class="['button', 'is-primary', dropdownClickeableClass]"
                aria-haspopup="true"
                :aria-controls="dropdownMenuId"
            >
                <span :class="dropdownClickeableClass">{{ props.label }}</span>
                <span class="icon is-small">
                    <span :class="['material-icons', dropdownClickeableClass]">arrow_drop_down</span>
                </span>
            </button>
        </div>
        <div class="dropdown-menu" :id="dropdownMenuId" role="menu">
            <div class="dropdown-content">
                <dropdown-item v-for="(option, i) in props.options" :key="i" :option="option" @click="onSelectOption"></dropdown-item>
            </div>
        </div>
    </div>
</template>
