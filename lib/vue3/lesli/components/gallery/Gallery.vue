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
import { ref, watch, computed } from "vue"


const emit = defineEmits(["delete"])

// · defining props
const props = defineProps({
    images: {
        type: Array,
        required: true,
    },
})

const onRemoveImage = (image) => {
    emit("delete", image)
}
</script>

<template>
    <div class="lesli-gallery">
        <div v-if="images.length > 0" class="preview mt-5 mb-4">
            <div v-for="(image, i) in images" :key="i" class="preview-item">
                <img :src="image.url" :alt="image?.name">
                <span class="material-icons" @click="onRemoveImage(image)">cancel</span>
            </div>
        </div>
    </div>
</template>
