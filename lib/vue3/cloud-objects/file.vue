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

// · import stores
import { useCloudObjectFileStore } from "LesliVue/stores/cloud-objects/file"
import { useLayout } from "LesliVue/stores/layout"

// · import components
import filesList from "LesliVue/cloud-objects/file/list.vue" 

// · implement store
const storeFiles = useCloudObjectFileStore()
const storeLayout = useLayout()

// · defining translations
const translations = {
    core: {
        shared: I18n.t("core.shared"),
    }
}

// · defining props
const props = defineProps({
    // · prop that indicates if the will be shown the new file button, by default it is true.
    showNewFileButton: {
        type: Boolean,
        required: false,
        default: true,
    },
    // · prop that filter by file type, by default it is empty. (image, document, screenshots, plaintext)
    // · this filter will be applied to the data table that shows the files
    fileType: {
        type: String,
        required: false,
        default: '',
    },
    // · prop that indicates the cloud module that will be used for interacting with the backend.
    cloudModule: {
        type: String,
        required: true,
    },
    // · prop that indicates the resource that you need to interact with.
    cloudObject: {
        type: String,
        required: true,
    },
    // · prop that indicates the object id of the resource that you need to interact with.
    cloudObjectId: {
        type: Number,
        required: true,
    },
    // · prop the indicates the maximun size of each file that can be uploaded,
    // · by default it is 1MB but the value is in bytes. That means that 
    // · if you want to upload a file with a size of 5MB you need to set the value to 5000000.
    maxSizeFile: {
        type: Number,
        required: false,
        default: 1000000,
    },
    // · prop that indicates the maximun number of files that can be uploaded, by default it is 10.
    maxFiles: {
        type: Number,
        required: false,
        default: 10,
    },
    // · prop that indicates the accepted file types, by default it is images.
    // · that means that the user can only upload images but you can change it to
    // · if you send an array with the accepted extensions.
    // · images includes: "jpg", "jpeg", "png", "gif", "svg"
    // · plaintext includes: "txt", "md", "log", "csv"
    // · documents includes: "doc", "docx", "xls", "xlsx", "pdf"
    acceptedFiles: {
        type: Array,
        required: false,
        default: () => [ 'images' ],
        validator: (val) => {
            return val.every((fileType) => {
                return ['images', 'plaintext', 'documents'].includes(fileType)
            })
        }
    }
})

// set cloudModule to store
storeFiles.cloudModule = props.cloudModule
// set cloudId to store
storeFiles.cloudObject = props.cloudObject
// set cloudObjectId to store
storeFiles.cloudObjectId = props.cloudObjectId
// set maxFile to store
storeFiles.maxFiles = props.maxFiles
// set maxSizeFile to store
storeFiles.maxSizeFile = props.maxSizeFile
// set type to store
storeFiles.fileType = props.fileType
// set acceptedFiles to store
storeFiles.acceptedFiles = props.acceptedFiles


/**
 * @description function that is called when the user click on the new file button.
 */
const onClickNewFile = () => {
    storeLayout.showFiles = !storeLayout.showFiles
}

</script>

<template>
    <div class="is-flex is-justify-content-end mb-4">
        <button v-if="props.showNewFileButton" class="button is-primary" @click="onClickNewFile">
            <span >
                {{ translations.core.shared.view_title_new_file }}
            </span>
            <span class="icon is-small">
                <span class="material-icons">add</span>
            </span>
        </button>
    </div>
    <div class="files">
        <files-list></files-list>
    </div>
</template>
