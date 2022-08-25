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
import { ref, reactive, onMounted, watch, computed, getCurrentInstance } from "vue"


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
    solid: {
        type: Boolean,
        default: false,
        required: false
    }
})

</script>
<template>
    <router-link 
        v-if="to"
        :class="['button', { 'is-primary': primary }, { 'is-outlined': !solid }, { 'is-loading': loading }]"
        :to="to.toString()">
        <span>
            <slot></slot>
        </span>
        <span v-if="icon" class="icon">
            <span class="material-icons">{{ icon }}</span>
        </span>
    </router-link>
    <button 
        v-if="!props.to" 
        @click="emit('click')" 
        :class="['button', { 'is-primary': primary }, { 'is-outlined': !solid }, { 'is-loading': loading }]">
        <span>
            <slot></slot>
        </span>
        <span v-if="icon" class="icon">
            <span class="material-icons">{{ icon }}</span>
        </span>
    </button>
</template>
