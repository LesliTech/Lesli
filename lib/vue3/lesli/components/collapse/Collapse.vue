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
    class: {
        type: String,
        required: false,
        default: "card"
    },
    animation: {
        type: String,
        required: false,
        default: "slide"
    },
    loading: {
        type: Boolean,
        default: false
    },
    open: {
        type: Boolean,
        default: false
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
            <slot name="lesli-collapse-header"></slot>
        </div>
        <div v-show="open" class="card-content">
            <slot  name="lesli-collapse-body"></slot>
        </div>
    </div>
</template>
