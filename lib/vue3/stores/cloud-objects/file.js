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
            fileTypes: [],
            clearDropZone: false,
            loading: false,
            cloudModule: null,
            cloudObject: null,
            cloudObjectId: null,
            cloudId: null,
            maxFiles: null,
            maxSizeFile: null,
        }
    },
    actions: {
        uploadFiles(files) {
            // · array of promises
            const promises = []
            
            // · url to upload files
            const url = this.url[this.cloudModule](
                `:cloudObject/:cloudObjectId/files.json`,
                {
                    cloudObject: this.cloudObject,
                    cloudObjectId: this.cloudObjectId,
                }
            )

            // · interate all files, create a promise and save it in the array
            for (let i = 0; i < files.length; i++) {
                promises.push(this.http.post(url, files[i]))
            }

            // · execute all promises asynchronously
            Promise.all(promises).then(() => {
                this.msg.success("Files uploaded successfully")
            }).catch(error => {
                console.log(error)
            }).finally(() => {
                this.loading = false
            })
        },

        fetchFiles() {
            this.loading = true

            // · url to fetch files
            const url = this.url[this.cloudModule](
                `:cloudObject/:cloudObjectId/files.json`,
                {
                    cloudObject: this.cloudObject,
                    cloudObjectId: this.cloudObjectId,
                }
            )

            this.http.get(url).then(response => {
                this.files = response
            }).catch(error => {
                console.log(error)
            }).finally(() => {
                this.loading = false
            })
        },

        deleteFile(id) {
            this.loading = true

            // · url to delete file
            const url = this.url[this.cloudModule](
                `:cloudObject/:cloudObjectId/files/:fileId`,
                {
                    cloudObject: this.cloudObject,
                    cloudObjectId: this.cloudObjectId,
                    fileId: id
                }
            )

            this.http.delete(url).then(() => {
                // · fetch files after delete a file
                this.fetchFiles()
                this.msg.success("File deleted successfully")
            }).catch(error => {
                console.log(error)
            }).finally(() => {
                this.loading = false
                this.filesToUpload = []
            })
        },

        fetchFileTypes() {
            this.loading = true
            
            // · url to fetch file types that are allowed to upload
            const url = this.url[this.cloudModule](
                `:cloudObject/files/options.json`,
                { cloudObject: this.cloudObject }
            )

            this.http.get(url)
                .then(response => {
                    // transform the response to an acceptable array of options for lesli-select
                    this.fileTypes = response.file_types.map(fileType => {
                        return {
                            value: fileType.value,
                            label: fileType.text
                        }
                    })
                }).catch(error => {
                    console.log(error)
                }).finally(() => {
                    this.loading = false
                })
        }
    }
})
