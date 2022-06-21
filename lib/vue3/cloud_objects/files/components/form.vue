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
import { ref, defineAsyncComponent, computed } from "vue"
import { useFileStore } from "LesliVue/stores/file"

const dropZone = defineAsyncComponent(() => import("./drop-zone.vue"))

const store = useFileStore()
const filesToUpload = computed(() => store.filesToUpload)
const fileType = ref(null)

const validateFiles = (files = []) => {
    
    if (files.length === 0) {
        // TODO: Show error to user
        return false
    }
    
    if (files.length > store.maxFiles) {
        // TODO: Show error to user
        return false 
    }
    
    
    const hasOutOfSizeFiles = files.some(file => {
        return parseInt(file.size) > store.maxSizeFile
    })

    if (hasOutOfSizeFiles) {
        // TODO: Show error to user
        return false
    }

    return true
}

const convertToBase64 = (file) => {
    return new Promise((resolve, reject) => {
        const reader = new FileReader()
        reader.readAsDataURL(file)
        reader.onload = () => {
            resolve(reader.result)
        }
        reader.onerror = (error) => {
            reject(error)
        }
    })
}

const onDropFiles = (files) => {
    store.filesToUpload = files
}

const onUploadFiles = async () => {
    
    const arefilesValid = validateFiles(filesToUpload.value)
    
    if (!arefilesValid) return
    if (!fileType.value) return
    
    const filesBase64 = []
    
    for (let i = 0; i < filesToUpload.value.length; i++) {
        const base64 = await convertToBase64(filesToUpload.value[i])
        filesBase64.push({
            project_file: {
                name: filesToUpload.value[i].name.split('.')[0],
                file_type: fileType.value.value,
                attachment: base64.split(',')[1]
            }
        })
    }         
    
    store.uploadFiles(filesBase64)
    store.clearDropZone = true
}

</script>

<template>
    <div class="card">
        <header>
            <p class="card-header-title subtitle">Files</p>
        </header>
        <div class="card-content">
            <div class="columns">
                <div class="column is-4">
                    <label class="label">
                        File Type
                        <sup class="has-text-danger">*</sup>
                    </label>
                </div>
                <div class="column">
                    <lesli-select
                        style="width: 100%;"
                        v-model="fileType"
                        placeholder="Select..."
                        :options="[
                            {
                                label: 'Image',
                                value: 'image',
                            }
                        ]"
                    >
                    </lesli-select>
                </div>
            </div>
            <div class="columns">
                <div class="column is-4">
                    <label class="label">
                        Document upload
                        <sup class="has-text-danger">*</sup>
                    </label>
                </div>
                <div class="column">
                    <drop-zone @files="onDropFiles"></drop-zone>
                </div>
            </div>
            <button @click="onUploadFiles" class="button is-fullwidth has-text-centered is-primary">
                Save
            </button>
        </div>
    </div>
</template>
