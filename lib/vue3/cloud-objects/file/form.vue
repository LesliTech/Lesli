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
import { ref, computed, onMounted } from "vue"

// · import store
import { useCloudObjectFileStore } from "LesliVue/stores/cloud-objects/file"

// · implement store
const store = useCloudObjectFileStore()

// · get translations from store
const translations = store.translations

// · get in a reactive way the files to upload
const filesToUpload = computed(() => store.filesToUpload)

// · get in a reactive way the files to upload
const fileTypes = computed(() => store.fileTypes)

// · get in a reactive way the loading value
const loading = computed(() => store.loading)

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
    if (files.length === 0) return false
    
    // · validate the number of files that are allowed
    if (files.length > store.maxFiles) return false 
    
    // · this variable is used to check if some file is invalid
    // · if this variable is true, the files aren't valid
    const hasOutOfSizeFiles = files.some(file => {
        return parseInt(file.size) > store.maxSizeFile
    })

    // · validate if some file is out of size
    if (hasOutOfSizeFiles) return false

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
    
    const arefilesValid = validateFiles(filesToUpload.value)
    
    // · If files aren't valid, stop the function
    if (!arefilesValid) return

    // · If file type select isn't valid, stop the function
    if (!fileType.value) return
    
    // · filesBase64 array is used to store the base64 strings of the files
    const filesBase64 = []
    
    // · convert the files to base64 and push it to the filesBase64 array
    for (let i = 0; i < filesToUpload.value.length; i++) {
        const base64File = await convertToBase64(filesToUpload.value[i])
        filesBase64.push({
            project_file: {
                // · file name without the extension
                name: filesToUpload.value[i].name.split('.')[0],
                
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
    clearFileUploader.value = true
}

onMounted(() => {
    // · fetch file types for the current module
    store.fetchFileTypes()
})
</script>

<template>
    <div class="card">
        <header>
            <p class="card-header-title subtitle">{{ translations.core.shared.view_text_files }}</p>
        </header>
        <div class="card-content">
            <div class="columns">
                <div class="column is-4">
                    <label class="label">
                        {{ translations.core.shared.column_files_file_type }}
                        <sup class="has-text-danger">*</sup>
                    </label>
                </div>
                <div class="column">
                    <lesli-select
                        v-model="fileType"
                        :placeholder="translations.core.view_placeholder_select_option"
                        :options="fileTypes"
                        v-if="!loading"
                    >
                    </lesli-select>
                </div>
            </div>
            <div class="columns">
                <div class="column is-4">
                    <label class="label">
                        {{ translations.core.shared.column_files_attachment }}
                        <sup class="has-text-danger">*</sup>
                    </label>
                </div>
                <div class="column">
                    <lesli-file-uploader 
                        @files="onDropFiles"
                        @events-after-clear="clearFileUploader = false"
                        :clear-files="clearFileUploader"
                    >
                    </lesli-file-uploader>
                </div>
            </div>
            <button @click="onUploadFiles" class="button is-fullwidth has-text-centered is-primary">
                {{ translations.core.shared.view_btn_save }}
            </button>
        </div>
    </div>
</template>
