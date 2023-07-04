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
import { ref, inject, watch } from "vue"

// · import store
import { useCloudObjectFileStore } from "Lesli/cloudobjects/stores/file.js"
import { useLayout } from "Lesli/shared/stores/layout"

// · implement stores
const storeFiles = useCloudObjectFileStore()
const storeLayout = useLayout()

// · implement composable
const msg = inject("msg")

// · defining translations
const translations = {
    core: {
        shared: I18n.t("core.shared"),
    }
}

// · file type to upload, this is the v-model of the select
const fileType = ref('')

// · this indicates if the file uploader needs to clear the files or not
const clearFileUploader = ref(false)

// · extensions that could be used to upload files
const acceptedFiles = {
    images: {
        extensions: ["jpg", "jpeg", "png", "gif", "svg"],
        accept: ".jpg,.jpeg,.png,.gif,.svg",
    },
    plaintext: {
        extensions: ["txt", "md", "log", "csv"],
        accept: ".txt,.md,.log,.csv",
    },
    documents: {
        extensions: ["pdf", "doc", "docx", "xls", "xlsx"],
        accept: ".pdf,.doc,.docx,.xls,.xlsx",
    },
}


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
    if (files.length > storeFiles.maxFiles) {
        msg.danger(translations.core.shared.messages_danger_files_exceeded)
        return false 
    }
    
    // · this variable is used to check if some file is invalid
    // · if this variable is true, the files aren't valid
    const hasOutOfSizeFiles = files.some(file => {
        return parseInt(file.size) > storeFiles.maxSizeFile
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
 * 
 * @param {*} name of the file
 * @param {*} attachment this is the file that will be uploaded
 * @param {*} type can be "formData" or "base64"
 * @description this function returns an object with a correct format accepted by the backend
 * @returns {object} this function returns an object with the correct format
 */
const formatFile = (name, attachment, type = 'formData') => {
    // · this variable contains something like cloudObject_file, for example: project_file
    // · is necessary to get the singular form of the word

    let cloudObjectModel = `${storeFiles.utils.singularize(storeFiles.cloudObject)}_file`

    if (type === 'base64') {
        return {
            [cloudObjectModel]: {
                // · name of the file
                name: name + '-' + new Date().getTime(),
    
                // · file extension that user selected
                file_type: fileType.value,
    
                // · file in base64
                attachment
            }
        }
    }

    // · if type is formData, return the file in formData format
    const formData = new FormData()
    formData.append(`${cloudObjectModel}[file_type]`, fileType.value)
    formData.append(`${cloudObjectModel}[attachment]`, attachment)
    formData.append(`${cloudObjectModel}[name]`, name + '-' + new Date().getTime())
    return formData
}

/**
 * @description this function compares the accepted files that were passed by props and form a string
 * @returns {string} a string with the accepted files extensions
 * @example
 * if the accepted files are: images
 * the function will return: ".jpg,.jpeg,.png,.gif,.svg"
 */
const getAcceptedFiles = () => {
    const accepted =  storeFiles.acceptedFiles.reduce((acc, fileType) => {
        return acc + acceptedFiles[fileType].accept
    }, '')
    return accepted
}

/**
 * @param {File[]} files this files are received from the file uploader
 * @description this function is called when the user drops or select files in the file uploader
 */
const onDropFiles = (files) => {
    // set files to upload to the store
    storeFiles.filesToUpload = files
}

/**
 * @description This function is called when the user click on the upload button.
 */
const onUploadFiles = async () => {
    
    const arefilesValid = validateFiles(storeFiles.filesToUpload)
    
    // · If files aren't valid, stop the function
    if (!arefilesValid) {
        // · set file type to empty
        fileType.value = ''
        return
    }

    // · If file type select isn't valid, stop the function
    if (!fileType.value) {
        msg.danger(translations.core.shared.messages_danger_file_type_required)
        // · set file type to empty
        fileType.value = ''
        return
    }
    
    // · files that will be sent to the server
    const filesToUpload = storeFiles.filesToUpload.map((file) => formatFile(file.name.split('.')[0], file))

    // · send the files to the server
    storeFiles.uploadFiles(filesToUpload)

    // · change the reactive variable to true for clear the file uploader
    clearFileUploader.value = true

    // · set file type to empty
    fileType.value = ''

    // · Hide the file uploader panel
    storeLayout.showFiles = false
}

watch(() => storeFiles.cloudModule, () => {
    if (storeFiles.cloudModule) {
        storeFiles.fetchFileTypes()
    }
})
</script>

<template>
    <lesli-panel v-model:open="storeLayout.showFiles">
        <template #header>
            {{ translations.core.shared.view_text_add_new_files }}
        </template>
        <template #default>
            <div class="p-6">
                <p class="mb-1">
                    {{ translations.core.shared.column_files_file_type }}
                </p>
                <lesli-select
                    v-model="fileType"
                    :placeholder="translations.core.shared.view_placeholder_select_option"
                    :options="storeFiles.fileTypes"
                    v-if="!storeFiles.loading"
                />
    
    
                <p class="mt-6">
                    {{ translations.core.shared.column_files_attachment }}
                </p>
                <lesli-file-uploader
                    :file-type="fileType?.label"
                    @files-change="onDropFiles"
                    :clear-files="clearFileUploader"
                    @events-after-clear="clearFileUploader = false"
                    :accepted-files="getAcceptedFiles()"
                />
    
                <button @click="onUploadFiles" class="button is-fullwidth has-text-centered is-primary mt-4">
                    {{ translations.core.shared.view_btn_save_changes }}
                </button>
            </div>
        </template>
    </lesli-panel>
</template>
