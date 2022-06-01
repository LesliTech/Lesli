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
import { ref, reactive, onMounted, watch, computed } from "vue"

// · defining emits
const emit = defineEmits(['open']);

// · defining props
const props = defineProps({
    loading: {
        type: Boolean,
        default: false
    },
    open: {
        type: Boolean,
        default: false
    },
    title: {
        type: String,
        default: 'Collapse Title'
    }
})

</script>
<template>
    <div class="collapse card">
        <div 
            v-on:click="emit('open')"
            class="card-header"
            style="cursor: pointer"
            role="button">
            <p class="card-header-title">
                {{ props.title }}
            </p>
            <a class="card-header-icon">
                <span class="icon">
                    <i :class="'fas fa-lg ' + (props.open ? 'fa-caret-down' : 'fa-caret-right')"/>
                </span>
            </a>
        </div>
        <div v-show="open" class="card-content">
            <slot></slot>
        </div>
    </div>
</template>
