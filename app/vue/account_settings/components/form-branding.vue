<script>
/*

Copyright (c) 2021, all rights reserved.

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
export default {
    data() {
        return {
            translations: {
                core: {
                    shared: I18n.t('core.shared'),
                    account: {
                        settings: I18n.t('core.account/settings'),
                        files: I18n.t('core.account/files')
                    }
                }
            },
            new_file: {
                url: null
            },
            branding_logos: {},
            file: {}
        }
    },
    mounted() {
        this.initializeBrandingLogos()
        this.getAccountLogos()
    },
    methods: {
        initializeBrandingLogos(){
            this.branding_logos = {
                app_icon_svg: {
                    identifier: 'app_icon_svg',
                    name: this.translations.core.account.files.view_text_file_app_icon_svg_name,
                    description: this.translations.core.account.files.view_text_file_app_icon_svg_description,
                    format: this.translations.core.account.files.view_text_file_format_svg,
                    file: null
                },
                app_logo_svg: {
                    identifier: 'app_logo_svg',
                    name: this.translations.core.account.files.view_text_file_app_logo_svg_name,
                    description: this.translations.core.account.files.view_text_file_app_logo_svg_description,
                    format: this.translations.core.account.files.view_text_file_format_svg,
                    file: null
                },
                app_logo_png: {
                    identifier: 'app_logo_png',
                    name: this.translations.core.account.files.view_text_file_app_logo_png_name,
                    description: this.translations.core.account.files.view_text_file_app_logo_png_description,
                    format: this.translations.core.account.files.view_text_file_format_png,
                    file: null
                },
                app_logo_desktop_svg: {
                    identifier: 'app_logo_desktop_svg',
                    name: this.translations.core.account.files.view_text_file_app_logo_desktop_svg_name,
                    description: this.translations.core.account.files.view_text_file_app_logo_desktop_svg_description,
                    format: this.translations.core.account.files.view_text_file_format_svg,
                    file: null
                },
                favicon_svg: {
                    identifier: 'favicon_svg',
                    name: this.translations.core.account.files.view_text_file_favicon_svg_name,
                    description: this.translations.core.account.files.view_text_file_favicon_svg_description,
                    format: this.translations.core.account.files.view_text_file_format_ico,
                    file: null
                }
            }
        },
        getAccountLogos(){
            let url = this.url.admin('account/files').filters({only: "logos"})
            this.loading = true

            this.http.get(url).then(result => {
                if (result.successful) {
                    this.parseLogos(result.data)
                }else{
                    this.msg.error(result.error.message)
                }
            }).catch(error => {
                console.log(error)
            }).finally(() => {
                this.loading = false
            })

        },
        parseLogos(files){
            for(let i = 0; i < files.length; i++){
                let file = files[i]

                let branding_logo = this.branding_logos[file.file_type]
                if(branding_logo){
                    branding_logo.file = file
                }
            }
        },
        processFile(event, logo) {
            this.file = event.target.files[0]
            this.new_file.url = URL.createObjectURL(this.file)

            this.postFile(logo)
        },
        setAltImg(event) {
            event.target.classList.add('error')
            event.target.src = '/images/icons/image.svg'
        },
        postFile(logo) {

            const formData = new FormData();
            formData.append('account_file[name]', logo.identifier)
            formData.append('account_file[file_type]', logo.identifier)
            formData.append('account_file[attachment]', this.file)

            this.http.post(this.url.admin('account/files'), formData).then((result) => {
                if(result.successful){
                    this.msg.success(this.translations.core.account.settings.messages_success_image_uploaded_successfully)
                }else{
                    this.msg.error(result.error.message)
                }
            })

        },
        deleteFile() {
            this.http.delete(this.url.admin('account/resources/company_logo')).then(result => {
                this.msg.info(this.translations.core.account.settings.messages_info_image_removed_successfully)
            })
        }

    }

}
</script>
<template>
    <div class="box pr-6 settings-general">
        <div class="py-5 pl-2 pr-2">
            <div class="table-container">
                <table class="table is-fullwidth is-narrow is-striped">
                    <thead>
                        <tr>
                            <th>{{translations.core.account.files.view_table_header_logo}}</th>
                            <th>{{translations.core.account.files.view_table_header_description}}</th>
                            <th>{{translations.core.account.files.view_table_header_format}}</th>
                            <th></th>
                            <th></th>
                            <th></th>
                        </tr>
                    </thead>
                    <tbody>
                        <tr v-for="(logo, key) in branding_logos" :key="key" class="mb-2">
                            <td><b>{{logo.name}}</b></td>
                            <td class="td-description"><small>{{logo.description}}</small></td>
                            <td>{{logo.format}}</td>
                            <td>
                                <div v-if="! logo.file || ! logo.file.id" class="field file">
                                    <label class="upload control is-expanded">
                                        <a class="button is-small is-outlined is-primary is-fullwidth is-justify-content-center">
                                            <span class="file-icon">
                                                <i class="fas fa-upload"></i>
                                            </span>
                                            <span>{{ translations.core.account.files.view_btn_browse_files }}</span>
                                        </a>
                                        <input class="file-input" type="file" @change="processFile($event, logo)">
                                    </label>
                                </div>
                            </td>
                            <td>
                                <a  
                                    v-if="logo.file && logo.file.id"
                                    class="button is-outlined is-fullwidth is-small"
                                    @click="deleteFile(logo)"
                                    href="#"
                                >
                                    <b-icon size="is-small" icon="download">
                                    </b-icon>
                                    <span>{{ translations.core.shared.view_btn_download }}</span>
                                </a>
                            </td>
                            <td>
                                <b-button
                                    v-if="logo.file && logo.file.id" 
                                    size="is-small" type="is-danger"
                                    outlined
                                    expanded
                                    @click="deleteFile(logo)"
                                    native-type="button"
                                >
                                    <b-icon size="is-small" icon="trash-alt">
                                    </b-icon>
                                    <span>{{ translations.core.shared.view_btn_delete }}</span>
                                </b-button>
                            </td>
                        </tr>
                    </tbody>
                </table>
            </div>
        </div>
    </div>
</template>
<style scoped>
    .card .card-content {
        max-width: 450px;
    }

    .td-description {
        width: 45%;
    }
</style>
