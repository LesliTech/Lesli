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
            branding_logos: {}
        }
    },
    mounted() {
        this.initializeBrandingLogos()
        this.getAccountLogos()
    },
    methods: {
        initializeBrandingLogos(){
            this.branding_logos = {
                app_icon: {
                    identifier: 'app_icon',
                    name: this.translations.core.account.files.column_enum_file_type_app_icon,
                    description: this.translations.core.account.files.view_text_file_type_app_icon_description,
                    format: this.translations.core.account.files.view_text_svg_png_formats,
                    accept: ".svg, .png",
                    submitting: false,
                    file: null
                },
                app_logo: {
                    identifier: 'app_logo',
                    name: this.translations.core.account.files.column_enum_file_type_app_logo,
                    description: this.translations.core.account.files.view_text_file_type_app_logo_description,
                    format: this.translations.core.account.files.view_text_svg_png_formats,
                    accept: ".svg, .png",
                    submitting: false,
                    file: null
                },
                favicon: {
                    identifier: 'favicon',
                    name: this.translations.core.account.files.column_enum_file_type_favicon,
                    description: this.translations.core.account.files.view_text_file_type_favicon_description,
                    format: this.translations.core.account.files.view_text_svg_png_ico_formats,
                    accept: ".svg, .png, .ico",
                    submitting: false,
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
            this.new_file = event.target.files[0]
            this.new_file.url = URL.createObjectURL(this.new_file)

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
            formData.append('account_file[attachment]', this.new_file)

            let url = this.url.admin('account/files')
            logo.submitting = true

            this.http.post(url, formData).then((result) => {
                if(result.successful){
                    this.$set(logo, 'file', result.data)
                    this.msg.success(this.translations.core.account.settings.messages_success_image_uploaded_successfully)
                }else{
                    this.msg.error(result.error.message)
                }
            }).finally(()=>{
                logo.submitting = false
            })

        },
        confirmFileDeletion(logo){
            this.$buefy.dialog.confirm({
                title: `${this.translations.core.account.files.messages_danger_delete_confirmation_title}: ${logo.name}`,
                message: this.translations.core.account.files.messages_danger_delete_confirmation_body,
                cancelText: this.translations.core.shared.view_btn_cancel,
                confirmText: this.translations.core.shared.view_btn_accept,
                type: 'is-danger',
                onConfirm: () => {
                    this.deleteFile(logo)
                }
            })
        },
        deleteFile(logo) {
            if(! logo.file || ! logo.file.id){
                return
            }

            let url = this.url.admin(`account/files/${logo.file.id}`)
            logo.submitting = true

            this.http.delete(url).then(result => {
                if(result.successful){
                    this.$set(logo, 'file', null)
                    this.msg.info(this.translations.core.account.settings.messages_info_image_removed_successfully)
                }else{
                    this.msg.error(result.error.message)
                }
            }).finally(()=>{
                logo.submitting = false
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
                                        <a
                                            :disabled="logo.submitting"
                                            class="button is-small is-outlined is-primary is-fullwidth is-justify-content-center"
                                        >
                                            <b-icon v-if="logo.submitting" size="is-small" icon="circle-notch" custom-class="fa-spin">
                                            </b-icon>
                                            <b-icon v-else icon="upload" size="is-small"></b-icon>
                                            <span>{{ translations.core.account.files.view_btn_browse_files }}</span>
                                        </a>
                                        <input :accept="logo.accept" class="file-input" type="file" @change="processFile($event, logo)">
                                    </label>
                                </div>
                            </td>
                            <td>
                                <a  
                                    v-if="logo.file && logo.file.id"
                                    class="button is-outlined is-fullwidth is-small"
                                    :href="`/administration/account/files/${logo.file.id}`"
                                    target="_blank"
                                    :disabled="logo.submitting"
                                >
                                    <b-icon v-if="logo.submitting" size="is-small" icon="circle-notch" custom-class="fa-spin">
                                    </b-icon>
                                    <b-icon v-else size="is-small" icon="download">
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
                                    :disabled="logo.submitting"
                                    @click="confirmFileDeletion(logo)"
                                    native-type="button"
                                >
                                    <b-icon v-if="logo.submitting" size="is-small" icon="circle-notch" custom-class="fa-spin">
                                    </b-icon>
                                    <b-icon v-else size="is-small" icon="trash-alt">
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
