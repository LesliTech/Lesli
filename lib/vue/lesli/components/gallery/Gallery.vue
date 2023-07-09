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
import { ref, computed } from "vue"


const emit = defineEmits(["delete"])

// · defining props
const props = defineProps({
    images: {
        type: Array,
        required: true,
    },
    showRemoveButton: {
        type: Boolean,
        default: true,
    },
    mode: {
        type: String,
        required: false,
        default: "grid",
        validator: (value) => {
            return ["grid", "slider"].includes(value)
        }
    }
})

// · Current position of the slider
const currentPosition = ref(0)

/**
 * @description called when the user clicks on the remove button, emits the delete event
 */
const onRemoveImage = (image) => {
    emit("delete", image)
}

/**
 * @description called when the user clicks on the next button if the mode is slider
 */
const onNextImage = () => {
    if (props.mode !== "slider") return

    if (currentPosition.value < props.images.length - 1) currentPosition.value++
    else currentPosition.value = 0
}

/**
 * @description called when the user clicks on the previous button if the mode is slider
 */
const onPreviousImage = () => {
    if (props.mode !== "slider") return

    if (currentPosition.value > 0) currentPosition.value--
    else currentPosition.value = props.images.length - 1
}

// · Current image of the slider
const sliderImage = computed(() => {
    return props.images[currentPosition.value]
})

// · String with slider info like "1 / 3"
const sliderInfo = computed(() => `${currentPosition.value + 1} / ${props.images.length}`)
</script>

<template>
    <div class="lesli-gallery">
        <!-- Grid -->
        <div v-if="props.mode === 'grid'" class="grid mt-5 mb-4">
            <div v-for="(image, i) in images" :key="i" class="item">
                <img :src="image.url" :alt="image?.name">
                <span v-if="props.showRemoveButton" class="material-icons" @click="onRemoveImage(image)">cancel</span>
            </div>
        </div>

        <!-- Slider -->
        <div v-else-if="props.mode === 'slider'" class="slider">
            <img :src="sliderImage.url" :alt="sliderImage.name">
            <div v-if=" props.images.length > 1" class="slider-controls">
                <div class="actions">
                    <lesli-button @click="onPreviousImage" solid icon="arrow_back"></lesli-button>
                    <lesli-button @click="onNextImage"  solid icon="arrow_forward"></lesli-button>
                </div>
                <h3 class="info">{{ sliderInfo }}</h3>
        </div>
        </div>
    </div>
</template>
