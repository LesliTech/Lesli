<script setup>
/*
Copyright (c) 2022, all rights reserved.

All the information provided by this platform is protected by international laws related to
industrial property, intellectual property, copyright and relative international laws.
All intellectual or industrial property rights of the code, texts, trade mark, design,
pictures and any other information belongs to the owner of this platform.

Without the written permission of the owner, any replication, modification,
transmission, publication is strictly forbidden.

For more information read the license file including with this software.

// · ~·~ ~·~ ~·~ ~·~ ~·~ ~·~ ~·~ ~·~ ~·~ ~·~ ~·~ ~·~
// ·
*/

// · defining emits
const emit = defineEmits(['update:modelValue']);

const props = defineProps({
    // · this value is used to set the value of the input type checkbox.
    modelValue: {
        type: Boolean,
        required: true,
    },
})

</script>

<template>
    <label class="lesli-toggle">
        <input  
            v-bind="$attrs" 
            @input="emit('update:modelValue', !props.modelValue)" 
            type="checkbox" :checked="props.modelValue"
        >
        <span class="slider"></span>
    </label>
</template>
