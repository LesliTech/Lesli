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


import { defineStore } from "pinia"

export const useFileStore = defineStore("file", {
    state: () => {
        return {
            files: [],
            filesToUpload: [],
            clearDropZone: false,
            loading: false,
            cloudModule: null,
            cloudId: null,
            maxFiles: null,
            maxSizeFile: null,
        }
    },
    actions: {
        uploadFiles(files) {
            const promises = []

            for (let i = 0; i < files.length; i++) {
                promises.push(
                    this.http.post(`/${this.cloudModule}/${this.cloudId}/files`, files[i])
                )
            }

            Promise.all(promises).then(() => {
                // TODO: show success msg to user
            }).catch(error => {
                // TODO: show error msg to user
            }).finally(() => {
                this.loading = false
            })         
        },

        fetchFiles() {
            this.loading = true
            const url = `/${this.cloudModule}/${this.cloudId}/files.json`
            this.http.get(url)
            .then(response => {
                this.files = response
            }).catch(error => {

            }).finally(() => {
                this.loading = false
            })
        },

        deleteFile(id) {
            this.loading = true
            const url = `/${this.cloudModule}/${this.cloudId}/files/${id}`
            this.http.delete(url).then(() => {
                // TODO: show success msg to user
                this.fetchFiles()
            }).catch(error => {
                // TODO: show error msg to user
            }).finally(() => {
                this.loading = false
                this.filesToUpload = []
            })
        }
    }
})
