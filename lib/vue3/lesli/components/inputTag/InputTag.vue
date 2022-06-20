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
    options: {
        type: Array,
        required: false,
    },
    placeholder: {
        type: String,
        required: false,
        default: "Select...",
    },
})

const inputValue = ref("")
const showOptions = ref(false)
const currentOptionsToShow = ref({})
const tags = ref(props.modelValue)

const onEnter = () => {
    if (inputValue.value.length > 0) {
        if (tags.value.find((tag) => tag.id === inputValue.value)) {
            showOptions.value = false
            return
        }
        
        if (props.options) {
            const option = props.options.find(
                (option) => option.name === inputValue.value
            )

            if (option) {
                tags.value.push(option)
                inputValue.value = ""
                showOptions.value = false
                emit("update:modelValue", tags.value)
            }
        }
    }
    emit("update:modelValue", tags.value)
}

const onClickOption = (option) => {

    if (tags.value.find((tag) => tag.id === option.id)) {
        showOptions.value = false
        return
    }

    tags.value.push(option)
    emit("update:modelValue", tags.value)
    inputValue.value = ""
    showOptions.value = false
}

const onDelete = () => {
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

    const optionsFiltered = props.options.filter((option) => {
        return option.name
            .toLowerCase()
            .includes(inputValue.value.toLowerCase())
    })

    currentOptionsToShow.value = optionsFiltered.filter((option) => {
        return !tags.value.find((tag) => tag.id === option.id)
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
            {{ tag.name }}
        </span>
        <div class="container-input">
            <input
                @keypress.enter.prevent="onEnter"
                @keydown.delete.prevent="onDelete"
                @keyup.prevent="filterOptions"
                @keyup.esc.prevent="showOptions = false"
                class="custom-input"
                v-model="inputValue"
                type="text"
                :placeholder="placeholder"
            />
        </div>

        <div class="options" v-show="showOptions && options">
            <div
                class="options-element"
                v-for="option in currentOptionsToShow"
                :key="option.id"
                @click="onClickOption(option)"
            >
                <span>{{ option.name }}</span>
            </div>
        </div>
    </div>
</template>
