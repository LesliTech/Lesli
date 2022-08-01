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
import { computed } from "vue"

const props = defineProps({
    // · url image to render as avatar
    urlImage: {
        type: String,
        default: null
    },
    // · letter to render as avatar
    letter: {
        type: String,
        required: true,
    },
    // · size of the avatar and it is in pixels
    size: {
        type: Number,
        required: false,
        default: 50
    },
    // · font size of the letter
    fontSize: {
        type: Number,
        required: false,
        default: 4
    },
})

// · boolean to show avatar as image or letter
const showImage = computed(() => props.urlImage !== null)

// · size of the font to render the letter
const fontSize = computed(() => `is-size-${props.fontSize}`)

// · size of the avatar its injected in the style attribute
const avatarSize = computed(() => `height: ${props.size}px; width: ${props.size}px;`)

</script>

<template>
    <figure class="lesli-avatar" :style="avatarSize">
        <img v-if="showImage" :src="urlImage">
        <span v-else class="has-text-weight-bold" :class="fontSize">{{ letter }}</span>
    </figure>
</template>
