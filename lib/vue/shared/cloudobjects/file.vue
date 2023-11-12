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


// · import stores
import { useCloudObjectFileStore } from "Lesli/cloudobjects/stores/file.js"
import { useLayout } from "Lesli/shared/stores/layout"

// · import components
import filesList from "Lesli/cloudobjects/components/file/list.vue" 
import filesGrid from "Lesli/cloudobjects/components/file/grid.vue" 

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
        required: false,
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
    },
    // · prop that indicates the mode for showing files
    mode: {
        type: String,
        required: false,
        default: "list"
    },
})

// set cloudModule to store
storeFiles.cloudModule = props.cloudModule
// set cloudObject to store
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

</script>

<template>
    <div class="files">
        <files-grid v-if="props.mode=='grid'"></files-grid>
        <files-list v-else></files-list>
    </div>
</template>
