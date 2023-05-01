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

// · defining props
const props = defineProps({
    option: {
        type: Object,
        required: true,
    },
})  

// · defining emits 
const emit = defineEmits(['click']);
</script>

<template>
    <a @click="emit('click', props.option)" class="dropdown-item is-flex is-justify-content-space-between is-align-items-center py-2 px-4" >
        {{ props.option.label }}
        <span v-if="props.option?.icon" class="icon">
            <span class="material-icons">{{ props.option.icon }}</span>
        </span>
    </a>
</template>
