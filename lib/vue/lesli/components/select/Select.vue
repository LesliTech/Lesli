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
const emit = defineEmits(['update:modelValue']);


// · defining props
const props = defineProps({
    modelValue: {
        type: [Number, String, Boolean],
        required: false
    },
    options: {
        type: Array,
        required: true
    },
    placeholder: {
        type: String,
        required: false,
        default: "Select..."
    },
    icon: {
        type: String,
        required: false
    },
    reset: {
        type: String,
        required: false
    },
    required: {
        type: Boolean,
        required: false,
        default: false
    },
    disabled: {
        type: Boolean,
        required: false,
        default: false
    }
})


// · create a reactive variable to store the selected value of the select element
const selected = ref("");


// · function that handles change event of select element
function onChange(event) {
    // · if the selected value is the default option, set selected to empty string
    if (event.target.value === "") {
        selected.value = "";
    // · otherwise, set selected to the selected value
    } else {
        selected.value = event.target.value;
    }
}


// · 
function setInitialValue(value) {
    // · if the new value is null or empty string, set selected to empty string
    if (value === null || value === "") {
        selected.value = "";
    // · otherwise, set selected to the new value
    } else {
        selected.value = value;
    }
}


// · 
onMounted(() => {
    setInitialValue(props.modelValue)
})


// · watch for changes to the modelValue prop
watch(() => props.modelValue, value => {
    setInitialValue(value)
});


// · watch for changes to the selected value
watch(() => selected.value, newValue => {

        // · if the new value is null or empty string, emit an event with empty string as value 
        // . to notify parent component that the value has changed
        if (newValue === null || newValue === "") {
            emit("update:modelValue", "");
        // · otherwise, emit an event with the selected value as the value 
        // . to notify parent component that the value has changed
        } else {
            emit("update:modelValue", newValue);
        }
    }
);

</script>
<template>
    <div :class="['control', { 'has-icons-left': props.icon }]">
        <div class="select is-fullwidth">
            <select
                @change="onChange"
                v-model="selected"
                :required="props.required"
                :disabled="props.disabled">
                <option value="" disabled>{{ props.placeholder }}</option>
                <option
                    v-if="props.reset"
                    :value="{ value: 'reset', label: 'reset' }">
                    {{ props.reset }}
                </option>
                <option
                    v-for="(option, index) in props.options"
                    :value="option.value"
                    :key="index">
                    {{ option.label }}
                </option>
            </select>
        </div>
        <div v-if="props.icon" class="icon is-small is-left">
            <span class="material-icons">
                {{ props.icon }}
            </span>
        </div>
    </div>
</template>
