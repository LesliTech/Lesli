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
    if (props.name) return props.name.charAt(0).toUpperCase()
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
