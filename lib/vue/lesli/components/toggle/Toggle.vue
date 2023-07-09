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
