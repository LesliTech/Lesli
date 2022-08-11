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
import { ref, onMounted, inject } from "vue"

// · import store
import { useCloudObjectFileStore } from "LesliVue/stores/cloud-objects/file"

// · implement store
const store = useCloudObjectFileStore()

// · implement composable
const msg = inject("msg")

// · defining translations
const translations = {
    core: {
        shared: I18n.t("core.shared"),
    }
}

// · file type to upload, this is the v-model of the select
const fileType = ref(null)

// · this indicates if the file uploader needs to clear the files or not
const clearFileUploader = ref(false)


/**
 * @param {File[]} files this files will be validated
 * @returns {boolean} true if the files are valid and false if not
 * @description this function validate the files
 */
const validateFiles = (files = []) => {
    
    // · validate the length of the files array
    if (files.length === 0) {
        msg.danger(translations.core.shared.messages_danger_files_empty)
        return false
    }
    
    // · validate the number of files that are allowed
    if (files.length > store.maxFiles) {
        msg.danger(translations.core.shared.messages_danger_files_exceeded)
        return false 
    }
    
    // · this variable is used to check if some file is invalid
    // · if this variable is true, the files aren't valid
    const hasOutOfSizeFiles = files.some(file => {
        return parseInt(file.size) > store.maxSizeFile
    })

    // · validate if some file is out of size
    if (hasOutOfSizeFiles) {
        msg.danger(translations.core.shared.messages_danger_files_out_of_size)
        return false
    }

    // · if validations are ok, return true
    return true
}

/**
 * 
 * @param {File} file this is the file that will be converted to base64
 * @description this function will convert a file to base64
 * @returns {Promise<string>} this function will return a promise with the base64 string
 */
const convertToBase64 = (file) => {
    return new Promise((resolve, reject) => {
        // · create a new file reader object
        const reader = new FileReader()
        
        // · when the file is loaded, convert it to base64
        reader.readAsDataURL(file)
        
        // · when the file is loaded, resolve the promise
        reader.onload = () => {
            resolve(reader.result)
        }

        // · when the file is not loaded, reject the promise
        reader.onerror = (error) => {
            reject(error)
        }
    })
}

/**
 * @param {File[]} files this files are received from the file uploader
 * @description this function is called when the user drops or select files in the file uploader
 */
const onDropFiles = (files) => {
    // set files to upload to the store
    store.filesToUpload = files
}

/**
 * @description This function is called when the user click on the upload button.
 */
const onUploadFiles = async () => {
    
    const arefilesValid = validateFiles(store.filesToUpload)
    
    // · If files aren't valid, stop the function
    if (!arefilesValid) return

    // · If file type select isn't valid, stop the function
    if (!fileType.value) {
        msg.danger(translations.core.shared.messages_danger_file_type_required)
        return
    }
    
    // · filesBase64 array is used to store the base64 strings of the files
    const filesBase64 = []
    
    // · convert the files to base64 and push it to the filesBase64 array
    for (let i = 0; i < store.filesToUpload.length; i++) {
        const base64File = await convertToBase64(store.filesToUpload[i])
        filesBase64.push({
            project_file: {
                // · file name without the extension
                name: store.filesToUpload[i].name.split('.')[0],
                
                // · file extension that user selected
                file_type: fileType.value.value,

                // · file in base64
                attachment: base64File.split(',')[1]
            }
        })
    }         
    
    // · send the files to the server
    store.uploadFiles(filesBase64)

    // · change the reactive variable to true for clear the file uploader
    // clearFileUploader.value = true
    store.showFilesUpload = false
}

onMounted(() => {
    // · fetch file types for the current module
    store.fetchFileTypes()
})
</script>

<template>
    <div @click="store.showFilesUpload = false" class="files-upload" :class="store.showFilesUpload ? 'files-upload__active'">
        <div @click.stop class="content p-6">
            <lesli-header title="Add new files">
                <button @click="store.showFilesUpload = !store.showFilesUpload" class="button is-transparent">
                    <span class="icon is-small">
                        <span class="material-icons">close</span>
                    </span>
                </button>
            </lesli-header>
            <div>
                <p>
                    {{ translations.core.shared.column_files_file_type }}
                    <sup class="has-text-danger">*</sup>
                </p>
                <lesli-select
                    v-model="fileType"
                    :placeholder="translations.core.shared.view_placeholder_select_option"
                    :options="store.fileTypes"
                    v-if="!store.loading"
                />
    
    
                <p class="mt-6">
                    {{ translations.core.shared.column_files_attachment }}
                    <sup class="has-text-danger">*</sup>
                </p>
                <lesli-file-uploader 
                    @files="onDropFiles"
                />
    
    
                <button @click="onUploadFiles" class="button is-fullwidth has-text-centered is-primary mt-4">
                    {{ translations.core.shared.view_btn_save }}
                </button>
            </div>

        </div>
    </div>
</template>

<style>
.files-upload {
    position: fixed;
    top: 0;
    right: 0;
    bottom: 0;
    left: 0;
    z-index: 9999;
    display: flex;
    justify-content: flex-end;
    background: transparent;
    transition: all 0.3s ease-in-out;
    transform: translateX(100%);
}

.files-upload.is-active {
    transform: translateX(0);
    transition: all 0.3s ease-in-out;
}

.content {
    width: 484px;
    background-color: white;
    border-left: 1px solid #ebebeb;
}

</style>
