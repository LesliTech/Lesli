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

Lesli · Ruby on Rails Development Platform.

Made with ♥ by https://www.lesli.tech
Building a better future, one line of code at a time.

@contact  hello@lesli.tech
@website  https://www.lesli.tech
@license  GPLv3 http://www.gnu.org/licenses/gpl-3.0.en.html

// · ~·~     ~·~     ~·~     ~·~     ~·~     ~·~     ~·~     ~·~     ~·~     ~·~     ~·~     ~·~
// · 
*/

// ·
import { defineStore } from "pinia";
import axios from "axios";

// ·
export const useAccountSettings = defineStore("account_settings", {
    state: () => {
        return {
            view: 0,
            submitting_form : false,
            settings: {
                datetime_format_date: null,
                datetime_format_time: null,
                datetime_format_date_words: null,
                datetime_format_date_time: null,
                datetime_format_date_time_words: null,
                datetime_time_zone: null,
                password_enforce_complexity: null,
                password_minimum_length: null,
                password_expiration_time_days: null,
                password_special_char_count: null,
                password_uppercase_count: null,
                password_lowercase_count: null,
                password_digit_count: null,
                lesli_theme_color_primary: null,
                lesli_theme_color_secondary: null,
                lesli_theme_header_color: null,
                lesli_theme_sidebar_color: null,
                lesli_theme_color_background: null,
                lesli_theme_font_color: null,
                lesli_theme_font_size: null,
                default_role_id: null,
            },
            old_settings: {
                lesli_theme_color_primary: null,
                lesli_theme_color_secondary: null,
                lesli_theme_header_color: null,
                lesli_theme_sidebar_color: null,
                lesli_theme_color_background: null,
                lesli_theme_font_color: null,
                lesli_theme_font_size: null
            },
            options: {
                time_zones: []
            },
            roles: {},
            branding_logos: {},
            record_files: [],
            new_file: {
                url: null
            },
            loading: false,
        }
    },
    actions: {
        /**
         * @description This action is used to fetch the list of options for time zone.
         */
        getOptions (){
            this.loading = true
            this.http.get(this.url.admin("account/options")).then(result => {
                this.options.time_zones = result.time_zones.map((time_zone)=> {
                    return {
                        label: time_zone.text,
                        value: time_zone.value
                    }
                } )
            }).catch(error => {
                this.msg.danger(I18n.t("core.shared").messages_danger_internal_error)
            }).finally(() => {
                this.loading = false
            })
        },

        /**
         * @description This action is used to post the selected settings
         */
        postSettings() {
            this.submitting_form = true
            this.http.post(this.url.admin("account/settings"), {
                settings: this.settings
            }).then(result => {
                this.msg.success(I18n.t("core.account/settings").messages_success_settings_saved_successfully)
            }).catch(error => {
                console.log(error)
                this.msg.danger(I18n.t("core.shared").messages_danger_internal_error)
            }).finally(() => {
                this.submitting_form = false
                this.getSettings()
            })
        },

        /**
         * @description This action is used to fetch the user's roles
         */
        getRoles(){
            this.loading = true
            this.http.get(this.url.admin("roles/list")).then(result => {
                this.roles = result.map(record =>{
                    return {
                        label: record.name,
                        value: record.id,
                    };
                })
            }).catch(error => {
                this.msg.danger(I18n.t("core.shared").messages_danger_internal_error)
            }).finally(() => {
                this.loading = false
            })
        },  

        /**
         * @description This action is used to fetch the currently configured settings
         */
        getSettings (){
            this.loading = true
            this.http.get(this.url.admin("account/settings")).then(result => {
                result.forEach(setting => {
                    if (setting.name in this.settings){
                        this.settings[setting.name] = setting.value
                    }
                })
            }).catch(error => {
                this.msg.danger(I18n.t("core.shared").messages_danger_internal_error)
            }).finally(() => {
                this.loading = false
            })
        },
        
        /**
         * @description This action is used to replace the new settings with the old settings
         * @param {Object} setting_name The setting that is going to be replaced
         */
        clearSetting(setting_name){
            this.settings[setting_name] = this.old_settings[setting_name]
        },

        /**
         * @description Initializing branding logos properties
         */
        initializeBrandingLogos(){
            this.branding_logos = {
                app_icon: {
                    identifier: 'app_icon',
                    name: I18n.t('core.account/files').column_enum_file_type_app_icon,
                    description: I18n.t('core.account/files').view_text_app_icon_description,
                    format: I18n.t('core.account/files').view_text_svg_png_formats,
                    accept: ".svg, .png",
                    submitting: false,
                    file: null
                },
                app_logo: {
                    identifier: 'app_logo',
                    name: I18n.t('core.account/files').column_enum_file_type_app_logo,
                    description: I18n.t('core.account/files').view_text_file_type_app_logo_description,
                    format: I18n.t('core.account/files').view_text_svg_png_formats,
                    accept: ".svg, .png",
                    submitting: false,
                    file: null
                },
                favicon: {
                    identifier: 'favicon',
                    name: I18n.t('core.account/files').column_enum_file_type_favicon,
                    description: I18n.t('core.account/files').view_text_file_favicon_svg_description,
                    format: I18n.t('core.account/files').view_text_svg_png_ico_formats,
                    accept: ".svg, .png, .ico",
                    submitting: false,
                    file: null
                }
            }
            this.record_files = []
        },

        /**
         * @description Get account logos files
         */
        getAccountLogos(){
            this.loading = true
            this.http.get(this.url.admin('account/files')).then(result => {
                this.parseLogos(result)
            }).catch(error => {
                console.log(error)
                this.msg.danger(I18n.t("core.shared").messages_danger_internal_error)
            }).finally(() => {
                this.loading = false
            })
        },

        /**
         * @description Parse logos to display the records in a table
         */
        parseLogos(files){
            for(let i = 0; i < files.length; i++){
                let file = files[i]
                let branding_logo = this.branding_logos[file.file_type]
                if(branding_logo){
                    this.branding_logos[file.file_type].file = file
                }
            }
            this.record_files = this.branding_logos
        },

        /**
         * 
         * @param {string} id 
         * @description This method is used to get the url of a file
         * @returns {string} file url
         */
        getUrl(id) {            
            // · url to fetch file types that are allowed to upload
            const url = this.url.admin('account/files/:id', id)
            return url.toString()
        },

        /**
         * 
         * @param {string} logo the logo to be deleted
         * @description this action is used to delete a file from a cloud object.
         */
        deleteFile(logo) {
            this.loading = true

            // · url to delete file
            const url = this.url.admin('account/files/:id', logo.id)
            this.http.delete(url).then(() => {
                // · fetch files after delete a file
                this.getAccountLogos()
                this.initializeBrandingLogos()
                this.msg.success(I18n.t("core.shared").messages_success_files_deleted)
            }).catch(error => {
                console.log(error)
                this.msg.danger(I18n.t("core.shared").messages_danger_files_deleted)
            }).finally(() => {
                this.loading = false
            })
        },

        /**
         * 
         * @param {string} logo the logo that is being uploaded 
         * @param {string} event
         * @description this action is used to process a file that is going to be uploaded
         */
        processFile(event, logo) {

            /*
            const formData = new FormData();
            formData.append('account_file[name]', "test")
            formData.append('account_file[file_type]', "app_logo")
            formData.append('account_file[attachment]', event.target.files[0]);
            var headers = { 'Content-Type': 'multipart/form-data' };

            this.http.post(this.url.admin('account/files'), formData, { headers }).then((res) => {
                res.data.files; // binary representation of the file
                res.status; // HTTP status
            });

            return 
            */
            this.new_file = event.target.files[0]
            //this.new_file.url = URL.createObjectURL(this.new_file)
            this.postFile(logo)
        },

        /**
         * 
         * @param {string} logo the logo to be deleted
         * @description this action is used to post a file into account files
         */
        postFile(logo) {

            const formData = new FormData()
            formData.append('account_file[name]', logo.identifier)
            formData.append('account_file[category]', logo.identifier)
            formData.append('account_file[attachment]', this.new_file)
            var headers = { 'Content-Type': 'multipart/form-data' };

            this.http.postFile(this.url.admin('account/files'), formData).then((res) => {
            //this.http.post(this.url.admin('account/files'), formData, { headers }).then((res) => {
                this.msg.success(I18n.t("core.account/settings").messages_success_image_uploaded_successfully)
            }).catch(error => {
                console.log(error)
                this.msg.danger(I18n.t("core.shared").messages_danger_files_deleted)
            }).finally(()=>{
                this.initializeBrandingLogos()
                this.getAccountLogos()
            })

        },
        /**
         * 
         * @param {string} logo the logo to be deleted
         * @description this action is used to show a dialog message to confirm the deletion
         */
        confirmFileDeletion(logo){
            this.dialog
            .confirmation({
                title: `${I18n.t('core.account/files').messages_danger_delete_confirmation_title}: ${logo.name}`,
                text: I18n.t('core.account/files').messages_danger_delete_confirmation_body,
                confirmText: I18n.t("core.shared").view_btn_accept,
                cancelText: I18n.t("core.shared").view_btn_cancel
            })
            .then(({ isConfirmed }) => {
                if (isConfirmed) {
                    this.deleteFile(logo)
                }
            })
        }

    },
});
