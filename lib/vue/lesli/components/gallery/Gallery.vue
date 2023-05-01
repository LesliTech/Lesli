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
