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
import { computed, ref } from "vue"

const props = defineProps({
    // · url image to render as avatar
    urlImage: {
        type: String,
        default: null
    },
    // · letter to render as avatar
    name: {
        type: String,
        default: null,
    },
    // · letter to render as avatar
    letter: {
        type: String,
        default: null,
    },
    // · size of the avatar and it could be small, medium or large
    size: {
        type: String,
        default: "small",
    },
})

// · boolean to show avatar as image or letter
const showImage = computed(() => props.urlImage !== null)

// · calculate the font size of the letter based on the size of the avatar
const fontSize = ref(null)

// · size of the avatar its injected in the style attribute
const avatarSize = ref(null)


// validate the size of the avatar
if (props.size === "small") {

    fontSize.value = "is-size-5"
    avatarSize.value = "height: 60px; width: 60px;"

} else if (props.size === "medium") {

    fontSize.value = "is-size-3"
    avatarSize.value = "height: 120px; width: 120px;"

} else if (props.size === "large") {

    fontSize.value = "is-size-1"
    avatarSize.value = "height: 180px; width: 180px;"

}


// · Letter to render as avatar
const letter = computed(() => {
    if (props.name) return props.word.charAt(0).toUpperCase()
    else if (props.letter) return props.letter.toUpperCase()
    else return '?'
})

</script>

<template>
    <figure class="lesli-avatar" :style="avatarSize">
        <img v-if="showImage" :src="urlImage">
        <span v-else class="has-text-weight-bold" :class="fontSize">{{ letter }}</span>
    </figure>
</template>
