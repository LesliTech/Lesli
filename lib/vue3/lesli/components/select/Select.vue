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
        required: true
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
    }
})


// · 
const selected = ref(props.modelValue)


// · 
function onChange() {
    emit('update:modelValue', selected.value)
}


</script>
<template>
    <div>
        <div :class="['control', {'has-icons-left': props.icon}]">
            <div class="select is-fullwidth">
                <select @change="onChange" v-model="selected">
                    <option value="" hidden>{{ props.placeholder }}</option>
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
    </div>
</template>
