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


// · import vue tools
import { watch } from "vue"


// · defining emits
const emit = defineEmits(['update:modelValue', 'change']);


// · 
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
    disabledText:{
        type: String,
        default: I18n.t("core.shared.view_text_no")
    },
    enabledText:{
        type: String,
        default: I18n.t("core.shared.view_text_yes")
    },
    showText: {
        type: Boolean,
        default: false,
    }
})


// · 
watch(() => props.modelValue, (val1, val2) => {
    emit('change', props.modelValue)
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
            <div v-if="props.showText">
                <p v-if="props.modelValue" class="enabled-text">{{props.enabledText}}</p>
                <p v-else class="disabled-text">{{props.disabledText}}</p>
            </div>
        </span>
    </label>
</template>
