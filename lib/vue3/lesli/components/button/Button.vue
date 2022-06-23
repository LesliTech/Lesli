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
    label: {
        type: String,
        required: true
    },
    to: {
        type: Object,
        required: false
    },
    mdi: {
        type: String,
        required: false
    },
    rmi: {
        type: String,
        required: false
    },
    loading: {
        type: Boolean,
        default: false,
        required: false
    },
    outlined: {
        type: Boolean,
        default: false,
        required: false
    }
})

</script>
<template>
    <router-link 
        v-if="to" 
        :class="['button', 'is-primary', { 'is-loading': loading, 'is-outlined': outlined }]"
        :to="to.toString()">
        <span v-if="mdi || rmi" class="icon">
            <span class="material-icons">{{ mdi }}</span>
            <span :class="rmi"></span>
        </span>
        <span>{{ label }}</span>
    </router-link>
    <button 
        v-if="!props.to" 
        @click="emit('click')" 
        :class="['button', 'is-primary', { 'is-loading': loading, 'is-outlined': outlined }]">
        <span v-if="mdi || rmi" class="icon">
            <span class="material-icons">{{ mdi }}</span>
            <span :class="rmi"></span>
        </span>
        <span>{{ label }}</span>
    </button>
</template>
