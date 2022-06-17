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


// · defining props
const props = defineProps({
    label: {
        type: String,
        required: false
    },
    icon: {
        type: String,
        required: false
    },
    rmi: {
        type: String,
        required: false
    }
})


// · 
const open = ref(false)


</script>
<template>
    <li :class="['lesli-navigation-list', {'active': open}]">
        <a @click.stop="open = !open" class="lesli-navigation-list-label">
            <span v-if="props.rmi" :class="[props.rmi, 'icono']"></span>
            <lesli-icon v-if="props.icon" :id="props.icon" class="icono"></lesli-icon>
            <span class="text">{{ props.label }}</span>
            <span class="chevron">
                <span v-if="!open" class="material-icons md-24">
                    chevron_right
                </span>
                <span v-if="open" class="material-icons md-24">
                    expand_more
                </span>
            </span>
        </a>
        <ul>
            <slot></slot>
        </ul>
    </li>
</template>
