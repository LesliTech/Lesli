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

// ·
import { defineStore } from "pinia";

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
                lesli_theme_font_size: null
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
            branding_logos: {},
            record_files: [],
            new_file: {
                url: null
            },
            loading: false,
            timezone_select: {},
            password_complex: {}

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
                console.log(error)
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
         * @description This action is used to fetch the currently configured settings
         */
        getSettings (){
            this.loading = true
            this.http.get(this.url.admin("account/settings")).then(result => {
                this.parseSettings(result)
                document.querySelector(':root').style.setProperty('--lesli-theme-color-primary', this.settings.lesli_theme_color_primary)
                document.querySelector(':root').style.setProperty('--lesli-theme-header-color', this.settings.lesli_theme_header_color)
                document.querySelector(':root').style.setProperty('--lesli-theme-sidebar-color', this.settings.lesli_theme_sidebar_color)
                document.querySelector(':root').style.setProperty('--lesli-theme-color-background', this.settings.lesli_theme_color_background)
                document.querySelector(':root').style.setProperty('--lesli-theme-font-color', this.settings.lesli_theme_font_color)
                document.querySelector(':root').style.setProperty('--lesli-theme-font-size', this.settings.lesli_theme_font_size)
            }).catch(error => {
                console.log(error)
                this.msg.danger(I18n.t("core.shared").messages_danger_internal_error)
            })
        },
        
        /**
         * @description This action is used to parse the settings fetched
         * @param {Object} settings_raw The records fetched from settings
         */
        parseSettings(settings_raw){
            settings_raw.forEach(setting_raw => {
                if (setting_raw.name in this.settings){
                    this.settings[setting_raw.name] = setting_raw.value
                    this.old_settings[setting_raw.name] = setting_raw.value
                }
            })
            this.password_complex = {label:this.settings.password_enforce_complexity ='0' ? 'Disabled' : 'Enabled', value:this.settings.password_enforce_complexity}
            this.timezone_select = {label: this.settings.datetime_time_zone, value: this.settings.datetime_time_zone}
            this.loading = false
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
            this.new_file = event.target.files[0]
            this.new_file.url = URL.createObjectURL(this.new_file)
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
            formData.append('account_file[file_type]', logo.identifier)
            formData.append('account_file[attachment]', this.new_file)

            this.http.post(this.url.admin('account/files'), formData).then((result) => {
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
