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
const emit = defineEmits(['update:modelValue', 'onInput', 'onFocus', 'onBlur', 'select']);


// · defining props
const props = defineProps({
    modelValue: {
        type: [Number, String, Object],
        required: false
    },
    placeholder: {
        type: String,
        default: '',
    },
    options: {
        type: Array,
        required: true,
    },
    selectBy: {
        type: Function,
        default(option) {
            return option;
        },
    },
    minInputLength: {
        type: Number,
        default: 2,
        validator: (prop) => {
            return prop >= 0;
        },
    },
})


// 
const inputId = `lesli_autocomplete_${(Math.random() * 100).toFixed()}`;
const inputText = ref('');
const isInputFocused = ref(false);
const currentSelectionIndex = ref(0)


// 
function onInput() {
    if (isListVisible && currentSelectionIndex.value >= filteredOptions.value.length) {
        currentSelectionIndex.value = (filteredOptions.value.length || 1) - 1;
    }
    emit('onInput', { input: inputText, options: filteredOptions });
}


// 
function onFocus() {
    isInputFocused.value = true;
    emit('onFocus', { input: inputText, options: filteredOptions });
}


// 
function onBlur() {
    isInputFocused.value = false;
    emit('onBlur', { input: inputText, options: filteredOptions });
}


// 
function onArrowDown($event) {
    if (isListVisible.value && currentSelectionIndex.value < filteredOptions.value.length - 1) {
        currentSelectionIndex.value++;
    }
    scrollSelectionIntoView();
}


// 
function onArrowUp($event) {
    if (isListVisible.value && currentSelectionIndex.value > 0) {
        currentSelectionIndex.value--;
    }
    scrollSelectionIntoView();
}


// 
function scrollSelectionIntoView() {
    setTimeout(() => {
        const list_node = document.querySelector(`#${wrapperId.value} .lesli-autocomplete-list`);
        const active_node = document.querySelector(`#${wrapperId.value} .lesli-autocomplete-list-option.lesli-autocomplete-list-option-active`);

        if (!(active_node.offsetTop >= list_node.scrollTop && active_node.offsetTop + active_node.offsetHeight < list_node.scrollTop + list_node.offsetHeight)) {
            let scroll_to = 0;
            if (active_node.offsetTop > list_node.scrollTop) {
                scroll_to = active_node.offsetTop + active_node.offsetHeight - list_node.offsetHeight;
            } else if (active_node.offsetTop < list_node.scrollTop) {
                scroll_to = active_node.offsetTop;
            }
            list_node.scrollTo(0, scroll_to);
        }
    });
}


// 
function selectCurrentSelection() {
    if (currentSelection.value) {
        select(currentSelection.value);
    }
}


// 
function select(option) {
    inputText.value = props.selectBy(option);
    currentSelectionIndex.value = 0;
    document.getElementById(inputId).blur();
    emit('select', option);
    emit('update:modelValue', option)
}


// 
function escapeRegExp(string) {
    return string.value.replace(/[.*+?^${}()|[\]\\]/g, '\\$&');
}


// 
function boldMatchText(text) {
    const regexp = new RegExp(`(${escapeRegExp(inputText)})`, 'ig');
    return text.replace(regexp, '<strong>$1</strong>');
}


// 
const wrapperId = computed(() => {
    return `${inputId}_wrapper`;
})


// 
const filteredOptions = computed(() => {
    const regexp = new RegExp(escapeRegExp(inputText), 'i');
    return props.options.filter((option) => props.selectBy(option).match(regexp));
})


// 
const isListVisible = computed(() => {
    return isInputFocused.value && inputText.value.length >= props.minInputLength && filteredOptions.value.length;
})


// 
const currentSelection = computed(() => {
    return isListVisible.value && currentSelectionIndex.value < filteredOptions.value.length ? filteredOptions.value[currentSelectionIndex.value] : undefined;
})


watch(() => props.modelValue, (newVal) => {  
    select(newVal)
})


</script>
<template>
	<div :id="wrapperId" class="lesli-autocomplete">
		<input
			:id="inputId"
			class="input lesli-autocomplete-input"
			type="text"
			:placeholder="props.placeholder"
			v-model="inputText"
			@input="onInput"
			@focus="onFocus"
			@blur="onBlur"
			@keydown.down.prevent="onArrowDown"
			@keydown.up.prevent="onArrowUp"
			@keydown.enter.tab.prevent="selectCurrentSelection"
			autocomplete="off"
		/>
		<div v-if="isListVisible" class="lesli-autocomplete-list">
			<div
				class="lesli-autocomplete-list-option"
				:class="{ 'lesli-autocomplete-list-option-active': currentSelectionIndex == index }"
				v-for="(option, index) in filteredOptions"
				:key="index"
				@mousedown.prevent
				@click="select(option)"
				@mouseenter="currentSelectionIndex = index">
				<span 
                    class="lesli-autocomplete-list-option-text" 
                    :data-text="props.selectBy(option)" 
                    v-html="boldMatchText(selectBy(option))">
                </span>
			</div>
		</div>
	</div>
</template>
