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

// · This store is needed to make http requests, manage the reactivity 
// · of certain global properties available to child components of the 
// · cloud object, such as the form to upload files and the table to display them.

import { defineStore } from "pinia"

export const useCloudObjectFileStore = defineStore("cloudObjectFile", {
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
            maxFiles: null,
            maxSizeFile: null,
        }
    },
    actions: {


        /**
         * @param {Object[]} files with an accepted format
         * @description This action is used to add files to the server.
         */
        uploadFiles(files) {
            // · array of promises
            const promises = []
            
            // · url to upload files
            const url = this.url[this.cloudModule](
                `${this.cloudObject}/:cloudObjectId/files`,
                {
                    cloudObjectId: this.cloudObjectId,
                }
            )

            // · interate all files, create a promise and save it in the array
            for (let i = 0; i < files.length; i++) {
                promises.push(this.http.post(url, files[i]))
            }

            // · execute all promises asynchronously
            Promise.all(promises).then(() => {
                this.msg.success(I18n.t("core.shared").messages_success_files_uploaded)
            }).catch(error => {
                console.log(error)
                this.msg.danger(I18n.t("core.shared").messages_danger_file_uploaded)
            }).finally(() => {
                this.loading = false
            })
        },


        /**
         * @description This action is used to fetch the files of a cloud object.
         */
        fetchFiles() {
            this.loading = true

            // · url to fetch files
            const url = this.url[this.cloudModule](
                `${this.cloudObject}/:cloudObjectId/files`,
                {
                    cloudObjectId: this.cloudObjectId,
                }
            )

            this.http.get(url).then(response => {
                this.files = response
            }).catch(error => {
                console.log(error)
                this.msg.danger(I18n.t("core.shared").messages_danger_getting_files)
            }).finally(() => {
                this.loading = false
            })
        },


        /**
         * 
         * @param {string} id 
         * @description this action is used to delete a file from a cloud object.
         */
        deleteFile(id) {
            this.loading = true

            // · url to delete file
            const url = this.url[this.cloudModule](
                `${this.cloudObject}/:cloudObjectId/files/:fileId`,
                {
                    cloudObjectId: this.cloudObjectId,
                    fileId: id
                }
            )

            this.http.delete(url).then(() => {
                // · fetch files after delete a file
                this.fetchFiles()
                this.msg.success(I18n.t("core.shared").messages_success_files_deleted)
            }).catch(error => {
                console.log(error)
                this.msg.danger(I18n.t("core.shared").messages_danger_files_deleted)
            }).finally(() => {
                this.loading = false
                this.filesToUpload = []
            })
        },


        /**
         * @description This method is used to fetch the files type to show in a select element.
         */
        fetchFileTypes() {
            this.loading = true
            
            // · url to fetch file types that are allowed to upload
            const url = this.url[this.cloudModule](
                `${this.cloudObject}/files/options`,
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
                    this.msg.danger(I18n.t("core.shared").messages_danger_getting_file_types)
                }).finally(() => {
                    this.loading = false
                })
        },

        /**
         * 
         * @param {string} id 
         * @description This method is used to get the url of a file
         * @returns {string} file url
         */
        getUrl(id) {            
            // · url to fetch file types that are allowed to upload
            const url = this.url[this.cloudModule](
                `${this.cloudObject}/:cloudObjectId/files/:fileId`,
                {
                    cloudObjectId: this.cloudObjectId,
                    fileId: id
                }
            )

            return url.toString()
        }
    }
})
