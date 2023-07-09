<script setup>
/*

Lesli

Copyright (c) 2023, Lesli Technologies, S. A.

This program is free software: you can redistribute it and/or modify
it under the terms of the GNU General Public License as published by
the Free Software Foundation, either version 3 of the License, or
(at your option) any later version.

This program is distributed in the hope that it will be useful,
but WITHOUT ANY WARRANTY; without even the implied warranty of
MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the
GNU General Public License for more details.

You should have received a copy of the GNU General Public License
along with this program. If not, see http://www.gnu.org/licenses/.

Lesli · Your Smart Business Assistant. 

Made with ♥ by https://www.lesli.tech
Building a better future, one line of code at a time.

@contact  hello@lesli.tech
@website  https://lesli.tech
@license  GPLv3 http://www.gnu.org/licenses/gpl-3.0.en.html

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
