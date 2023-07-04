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
import { ref, reactive, onMounted, watch, computed, useSlots } from "vue"

// · 
const slots = useSlots()

// · defining emits
const emit = defineEmits(['click']);


// · defining props
const props = defineProps({
    to: {
        type: Object,
        required: false
    },
    icon: {
        type: String,
        required: false
    },
    loading: {
        type: Boolean,
        default: false,
        required: false
    },
    primary: {
        type: Boolean,
        default: true,
        required: false
    },
    danger: {
        type: Boolean,
        default: false,
        required: false
    },
    warning: {
        type: Boolean,
        default: false,
        required: false
    },
    info: {
        type: Boolean,
        default: false,
        required: false
    },
    solid: {
        type: Boolean,
        default: false,
        required: false
    },
    small: {
        type: Boolean,
        default: false,
        required: false
    },
    iconOnly: {
        type: Boolean,
        default: false,
        required: false
    }
})


const buttonColor = computed(() => {

    if (props.warning) return "is-warning"

    if (props.danger) return "is-danger"

    if (props.info) return "is-info"

    return "is-primary"

})

</script>
<template>
    <router-link 
        v-if="props.to" 
        :to="to.toString()"
        :class="[
            'button', 
            'is-link',
            'is-light',
            buttonColor, 
            { 'is-outlined': !solid }, 
            { 'is-loading': loading }, 
            { 'is-small': small }]">
        <span v-if="icon" :class="['icon', { 'is-small': small }]">
            <span class="material-icons">{{ icon }}</span>
        </span>
        <span v-if="!iconOnly">
            <slot></slot>
        </span>
    </router-link>
    <button 
        v-if="!props.to" 
        @click="emit('click')" 
        :class="[
            'button', 
            'is-link',
            'is-light',
            buttonColor, 
            { 'is-outlined': !solid }, 
            { 'is-loading': loading }, 
            { 'is-small': small }]">
        <span v-if="icon" :class="['icon', { 'is-small': small }]">
            <span class="material-icons">{{ icon }}</span>
        </span>
        <span v-if="!iconOnly">
            <slot></slot>
        </span>
    </button>
</template>
