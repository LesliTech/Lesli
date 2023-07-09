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


import { computed, ref } from "vue"

const emit = defineEmits(["update:modelValue", "onError"])

const props = defineProps({
    // · model value is the value of the input
    modelValue: {
        type: String,
        default: "",
    },
    // · placeholder that will be shown when the input is empty
    placeholder: {
        type: String,
        required: false,
        default: "",
    },
    // · disabled state of the input
    disabled: {
        type: Boolean,
        required: false,
        default: false,
    },
    // · type of the input, works better with text
    type: {
        type: String,
        required: false,
        default: "text",
    },
    // · required state of the input
    required: {
        type: Boolean,
        required: false,
        default: false,
    },
    // · autocomplete will display a list of options provided by the browser
    autocomplete: {
        type: String,
        required: false,
        default: "off",
    },
    // · name of the input
    name: {
        type: String,
        required: false,
        default: "",
    },
    // · label of the input
    label: {
        type: String,
        required: false,
        default: "",
    },
    // · rules that will be applied to the input
    rules: {
        type: Array,
        required: false,
        default: () => [], 
    },
})


// · array of strings with the errors
const inputErrors = ref([])

/**
 * @description verify the rules that are passed as props
 * each rule is a function that returns a string with the error or true if the condition is met
 * each rule looks like: (val) => val !== null && val !== "" || "This field not pass the rule"
 */
const verifyRules = (textToEvaluate) => {
    // · reset errors
    inputErrors.value = []

    // · verify rules
    if (props.rules.length <= 0) return
    
    // · iterate over each rule
    props.rules.forEach((rule) => {
        // · rule is a function that returns a string or a boolean
        const result = rule(textToEvaluate)
        
        // · if result is a string, then it's an error
        if (typeof result === "string") inputErrors.value.push(result)
        
        // · do nothing if result is a boolean, then it's a success
    })
}

// · get the first error
const errorToShow = computed(() => inputErrors.value[0])

// · this function is called when the input value changes
const onInput = (e) => {
    verifyRules(e.target.value)
    emit("update:modelValue", e.target.value)
    
    // · this could be used to emit errors to the parent component
    // · like lesli-form
    emit("onError", inputErrors.value)
}

</script>

<template>
    <div class="control is-clearfix">
        <label v-if="props.label.length" class="label" :for="props.name">
            {{ props.label }}
            <sup v-if="props.required" class="has-text-danger">*</sup>
        </label>
        <input 
            :placeholder="props.placeholder" 
            :value="props.modelValue"
            :disabled="props.disabled" 
            :type="props.type" 
            :required="props.required"
            :name="props.name"
            @input="onInput"
            class="input is-fullwidth"
            :autocomplete="props.autocomplete"
        />
        <!-- Show alert if input has errors -->
        <p v-if="inputErrors.length" class="subtitle is-6 has-text-danger mt-1">
            {{ errorToShow }}
        </p>
    </div>
</template>
