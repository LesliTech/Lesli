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
    disabled: {
        type: Boolean,
        default: false,
    },
    toggleText: {
        type: Object,
        default: {
            disabled: I18n.t("mitwerken.profiles.view_text_no"),
            enabled: I18n.t("mitwerken.profiles.view_text_yes")
        }
    }
})
</script>

<template>
    <label class="lesli-toggle">
        <input  
            v-bind="$attrs" 
            @input="emit('update:modelValue', !props.modelValue)" 
            type="checkbox" :checked="props.modelValue"
            :disabled="props.disabled"
        >
        <span class="slider">
            <p v-if="props.modelValue" class="enabled-text">{{props.toggleText.enabled}}</p>
            <p v-else class="disabled-text">{{props.toggleText.disabled}}</p>
        </span>
    </label>
</template>
