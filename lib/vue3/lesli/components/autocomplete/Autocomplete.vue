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
const emit = defineEmits(['update:modelValue', 'onInput', 'onFocus', 'onBlur', 'select']);


// · defining props
const props = defineProps({
    modelValue: {
        type: [Number, String, Object],
        required: true
    },
    placeholder: {
        type: String,
        default: '',
    },
    items: {
        type: Array,
        required: true,
    },
    defaultItem: {
        default: null,
    },
    selectBy: {
        type: Function,
        default(item) {
            return item;
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
    if (isListVisible && currentSelectionIndex.value >= filteredItems.value.length) {
        currentSelectionIndex.value = (filteredItems.value.length || 1) - 1;
    }
    emit('onInput', { input: inputText, items: filteredItems });
}


// 
function onFocus() {
    isInputFocused.value = true;
    emit('onFocus', { input: inputText, items: filteredItems });
}


// 
function onBlur() {
    isInputFocused.value = false;
    emit('onBlur', { input: inputText, items: filteredItems });
}


// 
function onArrowDown($event) {
    if (isListVisible && currentSelectionIndex.value < filteredItems.value.length - 1) {
        currentSelectionIndex.value++;
    }
    scrollSelectionIntoView();
}


// 
function onArrowUp($event) {
    if (isListVisible && currentSelectionIndex.value > 0) {
        currentSelectionIndex.value--;
    }
    scrollSelectionIntoView();
}


// 
function scrollSelectionIntoView() {
    setTimeout(() => {
        const list_node = document.querySelector(`#${wrapperId.value} .lesli-autocomplete-list`);
        const active_node = document.querySelector(`#${wrapperId.value} .lesli-autocomplete-list-item.lesli-autocomplete-list-item-active`);

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
function select(item) {
    inputText.value = props.selectBy(item);
    currentSelectionIndex.value = 0;
    document.getElementById(inputId).blur();
    emit('select', item);
    emit('update:modelValue', item)
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
onMounted(() => {
    if (props.defaultItem !== undefined && props.defaultItem !== null) {
        select(props.defaultItem);
    }
})


// 
const wrapperId = computed(() => {
    return `${inputId}_wrapper`;
})


// 
const filteredItems = computed(() => {
    const regexp = new RegExp(escapeRegExp(inputText), 'i');
    return props.items.filter((item) => props.selectBy(item).match(regexp));
})


// 
const isListVisible = computed(() => {
    return isInputFocused.value && inputText.value.length >= props.minInputLength && filteredItems.value.length;
})


// 
const currentSelection = computed(() => {
    return isListVisible && currentSelectionIndex.value < filteredItems.value.length ? filteredItems.value[currentSelectionIndex.value] : undefined;
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
				class="lesli-autocomplete-list-item"
				:class="{ 'lesli-autocomplete-list-item-active': currentSelectionIndex == index }"
				v-for="(item, index) in filteredItems"
				:key="index"
				@mousedown.prevent
				@click="select(item)"
				@mouseenter="currentSelectionIndex = index">
				<span 
                    class="lesli-autocomplete-list-item-text" 
                    :data-text="props.selectBy(item)" 
                    v-html="boldMatchText(selectBy(item))">
                </span>
			</div>
		</div>
	</div>
</template>

<style scoped>
	.lesli-autocomplete {
		position: relative;
		width: 100%;
	}
	.lesli-autocomplete > input {
		margin-bottom: 0;
	}
	.lesli-autocomplete .lesli-autocomplete-list {
		position: absolute;
		width: 100%;
		border: none;
		max-height: 400px;
		overflow-y: auto;
		border-bottom: 0.1rem solid #d1d1d1;
		z-index: 9;
	}
	.lesli-autocomplete .lesli-autocomplete-list .lesli-autocomplete-list-header {
		background-color: #fafafa;
		padding: 0.6rem 1rem;
		border-bottom: 0.1rem solid #d1d1d1;
		border-left: 0.1rem solid #d1d1d1;
		border-right: 0.1rem solid #d1d1d1;
	}
	.lesli-autocomplete .lesli-autocomplete-list .lesli-autocomplete-list-footer {
		background-color: #fafafa;
		padding: 0.6rem 1rem;
		border-left: 0.1rem solid #d1d1d1;
		border-right: 0.1rem solid #d1d1d1;
	}
	.lesli-autocomplete .lesli-autocomplete-list .lesli-autocomplete-list-item {
		cursor: pointer;
		background-color: #fafafa;
		padding: 0.6rem 1rem;
		border-bottom: 0.1rem solid #d1d1d1;
		border-left: 0.1rem solid #d1d1d1;
		border-right: 0.1rem solid #d1d1d1;
	}

	.lesli-autocomplete .lesli-autocomplete-list .lesli-autocomplete-list-item:last-child {
		border-bottom: none;
	}

	.lesli-autocomplete .lesli-autocomplete-list .lesli-autocomplete-list-item.lesli-autocomplete-list-item-active {
		background-color: #e1e1e1;
	}
</style>
