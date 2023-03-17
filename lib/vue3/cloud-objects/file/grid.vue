<script setup>
/*
Copyright (c) 2023, all rights reserved.

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
import { onMounted, ref } from "vue"

// · import store
import { useCloudObjectFileStore } from "LesliVue/stores/cloud-objects/file"
import { useLayout } from "LesliVue/stores/layout"


// · implement store
const store = useCloudObjectFileStore()
const storeLayout = useLayout()


// · defining translations
const translations = {
    core: {
        shared: I18n.t("core.shared"),
    }
}

/**
 * @description function that is called when the user click on the new file button.
 */
 const onClickNewFile = () => {
    storeLayout.showFiles = !storeLayout.showFiles
}


onMounted(() => {
    // · fetch the files from server
    store.fetchFiles()
})

</script>

<template>
    <div class="grid-container">
        <div class="file-container"
            v-for="file in store.files"
            :key="file"
        >
            <img :src="store.getUrl(file.id)" :alt="file.name" v-if="file.file_type=='image'">
            <video controls v-else-if="file.file_type=='video'">
                <source :src="store.getUrl(file.id)" type="video/mp4">
            </video>
            <iframe v-else-if="file.file_type == 'document'" id="preview-document" :src="store.getUrl(file.id)" frameborder="0"></iframe>

            <button class="delete-button" @click="store.deleteFile(file.id)" type="button">
                <span class="icon">
                    <span class="material-icons">delete</span>
                </span>
            </button>
        </div>
        <div class="add-button">
            <button type="button" class="add-file button" @click="onClickNewFile">
                <span class="icon">
                    <span class="material-icons">add_box</span>
                </span>
                <span >
                    {{ translations.core.shared.view_title_new_file }}
                </span>
            </button>
        </div>
    </div>
</template>
