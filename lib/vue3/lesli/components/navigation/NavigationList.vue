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
    name: String
})


// · 
const open = ref(false)


</script>
<template>
<Transition>
    <ul :class="{ 'active': open }">
        <p class="menu-label" @click="open = !open">
            <span>{{ props.name }}</span>
            <span class="icon">
                <span v-if="!open" class="material-icons md-24">
                    chevron_right
                </span>
                <span v-if="open" class="material-icons md-24">
                    expand_more
                </span>
            </span>
        </p>
        <slot></slot>
    </ul>
</Transition>
</template>
