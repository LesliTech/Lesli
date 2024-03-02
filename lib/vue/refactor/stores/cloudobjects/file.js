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


// · This store is needed to make http requests, manage the reactivity 
// · of certain global properties available to child components of the 
// · cloud object, such as the form to upload files and the table to display them.

import { defineStore } from "pinia"

export const useCloudObjectFileStore = defineStore("cloud.object.file", {
    state: () => {
        return {
            files: [],
            filesToUpload: [],
            fileTypes: [],
            acceptedFiles: [],
            clearDropZone: false,
            loading: false,
            cloudModule: null,
            cloudObject: null,
            cloudObjectId: null,
            fileType: null,
            maxFiles: null,
            maxSizeFile: null,
            showFilesUpload: false,
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
                promises.push(this.http.post(url, files[i], {
                    headers: {
                        "Content-Type": "multipart/form-data",
                    }
                }))
            }

            // · execute all promises asynchronously
            Promise.all(promises).then(() => {
                this.msg.success(I18n.t("core.shared").messages_success_files_uploaded)
                this.fetchFiles()
            }).catch(error => {
                this.msg.danger(error.message)
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
                { cloudObjectId: this.cloudObjectId, }
            )

            // · If file type is not null, add the query param "f" to the url
            if (this.fileType) url.filter({ file_type: [this.fileType] })
            

            this.http.get(url).then(response => {
                if (response.length === 0) this.files = []
                else this.files = response
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
