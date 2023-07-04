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
import { onMounted, ref } from "vue";

// · import store
import { useCloudObjectFileStore } from "Lesli/cloudobjects/stores/file.js";
import { useLayout } from "Lesli/shared/stores/layout";

// · implement store
const store = useCloudObjectFileStore();
const storeLayout = useLayout();

// · defining translations
const translations = {
    core: {
        shared: I18n.t("core.shared"),
    },
};

// . Controls whether the modal is displayed
const showModal = ref(false);
// . Stores the currently displayed file
const currentFile = ref(null);
// . Stores the index of the currently displayed file
const currentIndex = ref(0)

/**
 * @description function that is called when the user click on the new file button.
 */
const onClickNewFile = () => {
    storeLayout.showFiles = !storeLayout.showFiles;
};

/**
 * @description open the modal and set the current file and its index
 */
const openModal = (file) => {
    currentFile.value = file
    currentIndex.value = store.files.indexOf(file)
    showModal.value = true
};

/**
 * @description display the previous image in the array of files
 */
const prevImage = () => {
    if (currentIndex.value > 0) {
        currentIndex.value -= 1
        currentFile.value = store.files[currentIndex.value]
      }
}

/**
 * @description display the next image in the array of files
 */
const nextImage = () => {
    if (currentIndex.value < store.files.length - 1) {
        currentIndex.value += 1
        currentFile.value = store.files[currentIndex.value]
    }
}

/**
 * @description delete image and close modal
 */
const deleteImage = () => {
    store.deleteFile(currentFile.value.id)
    currentFile.value = null
    currentIndex.value = 0
    showModal.value = false
}

onMounted(() => {
    // · fetch the files from server
    store.fetchFiles();
});
</script>

<template>
    <div class="grid-container">
        <div class="file-container" v-for="file in store.files" :key="file">
            <img
                @click="openModal(file)"
                :src="store.getUrl(file.id)"
                :alt="file.name"
                v-if="file.file_type == 'image'"
            />
            <video controls v-else-if="file.file_type == 'video'">
                <source :src="store.getUrl(file.id)" type="video/mp4" />
            </video>
            <iframe
                v-else-if="file.file_type == 'document'"
                id="preview-document"
                :src="store.getUrl(file.id)"
                frameborder="0"
            ></iframe>

            <button
                class="delete-button"
                @click="store.deleteFile(file.id)"
                type="button"
            >
                <span class="icon">
                    <span class="material-icons">delete</span>
                </span>
            </button>
        </div>
        <div class="add-button">
            <button
                type="button"
                class="add-file button"
                @click="onClickNewFile"
            >
                <span class="icon">
                    <span class="material-icons">add_box</span>
                </span>
                <span>
                    {{ translations.core.shared.view_title_new_file }}
                </span>
            </button>
        </div>

        <Teleport to="body">
            <div v-if="showModal" @click="showModal = false" class="file-backdrop"></div>
            <div v-if="showModal" class="file-modal">
                <img
                    :src="store.getUrl(currentFile.id)"
                    :alt="currentFile.name"
                    v-if="currentFile.file_type == 'image'"
                />

                <video controls v-else-if="currentFile.file_type == 'video'">
                    <source :src="store.getUrl(currentFile.id)" type="video/mp4" />
                </video>

                <iframe
                    v-else-if="currentFile.file_type == 'document'"
                    id="preview-document"
                    :src="store.getUrl(currentFile.id)"
                    frameborder="0"
                ></iframe>
                <div class="buttons">
                    <button @click="deleteImage" class="button is-primary is-danger">
                        <span class="icon">
                            <span class="material-icons">
                                delete
                            </span>
                        </span>
                        <span>Delete</span>
                    </button>
                    <div class="nav-buttons">

                        <button @click="prevImage" class="button is-primary">
                            <span class="icon">
                                <span class="material-icons">
                                    arrow_back
                                </span>
                            </span>
                            <span>Previous image</span>
                        </button>
                        <button @click="nextImage" class="button is-primary">
                            <span>Next image</span>
                            <span class="icon">
                                <span class="material-icons">
                                    arrow_forward
                                </span>
                            </span>
                            
                        </button>
                    </div>
                </div>
                <button  @click="showModal = false" class="button is-primary btn-close">
                    <span class="icon">
                        <span class="material-icons">
                            close
                        </span>
                    </span>
                </button>
            </div>
        </Teleport>
    </div>
</template>
