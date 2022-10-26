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

import { ref } from "vue"

const emit = defineEmits(["update:modelValue"])
const props = defineProps({
    modelValue: {
        type: Array,
        default: () => [],
    },
    placeholder: {
        type: String,
        required: false,
        default: "Select...",
    },
    options: {
        type: Array,
        required: true,
    },
    filterFields: {
        type: Array,
        required: true,
    },
    showField: {
        type: String,
        required: true,
    },
})

// · Input from user searching an option
const inputValue = ref("")

// · Use to show a list of options
const showOptions = ref(false)

// · List of filtered options
const filteredOptions = ref([])

// · Accepted options - these are shown as tags
const tags = ref(props.modelValue)

const clearAndEmit = () => {
    inputValue.value = ""
    showOptions.value = false
    emit("update:modelValue", tags.value)
}

const onEnter = () => {
    // · Verify if the inputValue is valid
    if (!inputValue.value.length) return
    
    // · Verify if the option is already selected
    if (tags.value.find( tag => tag[props.showField].toLowerCase() === inputValue.value.toLowerCase())) {
        clearAndEmit()
        return
    }

    // · get the option from the array of filtered options that matches the inputValue
    const filteredOption = filteredOptions.value.find( option => {
        
        if (typeof option[props.showField] === "string") {
            return option[props.showField].toLowerCase() === inputValue.value.toLowerCase()
        }

        return option[props.showField] === inputValue.value
    })

    if (!filteredOption) {
        tags.value.push({ [props.showField]: inputValue.value })
        clearAndEmit()
        return 
    }

    tags.value.push(filteredOption)    
    clearAndEmit()
}

const onClickOption = (option) => {
    // · Check if the option was added already
    if (tags.value.find(tag => tag.id === option.id)) {
        showOptions.value = false
        return
    }

    // · Add the option to the tags
    tags.value.push(option)
    emit("update:modelValue", tags.value)
    inputValue.value = ""
    showOptions.value = false
}

const onDelete = () => {
    // · Remove the last tag added
    if (inputValue.value.length === 0) {
        tags.value.pop()
        emit("update:modelValue", tags.value)
        return
    }

    inputValue.value = ""
}

const filterOptions = () => {
    if (inputValue.value.length === 0) {
        showOptions.value = false
        return
    }

    // · Checking for matches with the fields
    filteredOptions.value = props.options.filter(option => {
        const matches = props.filterFields.map(field => {
            return (option[field]||'').toString().toLowerCase().indexOf(inputValue.value.toLowerCase()) >= 0
        })

        // · One or more of the field match with the search
        return matches.includes(true)
    })

    showOptions.value = true

}
</script>

<template>
    <div
        class="lesli-input-tag p-2 has-background-white is-flex is-flex-wrap-wrap is-align-items-center is-fullwidth"
    >
        <span
            class="tag is-success is-small is-rounded mr-1"
            v-for="tag in tags"
            :key="tag.id"
        >
            {{ tag[showField] }}
        </span>
        <div class="container-input">
            <input
                @keypress.enter.prevent="onEnter"
                @keypress.tab.prevent="showOptions = false"
                @keydown.delete.prevent="onDelete"
                @keyup.prevent="filterOptions"
                @keyup.esc.prevent="showOptions = false"
                class="custom-input"
                v-model="inputValue"
                type="text"
                :placeholder="placeholder"
                ref="inputTag"
            />
        </div>

        <div class="options" v-show="showOptions && options">
            <div
                class="options-element"
                v-for="option in filteredOptions"
                :key="option.id"
                @click="onClickOption(option)"
            >
                <span>{{ option[showField] }}</span>
            </div>
        </div>
    </div>
</template>
