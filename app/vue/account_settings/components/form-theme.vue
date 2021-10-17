<script>

export default {
    data(){
        return {
            loading: true,
            submitting_form: false,
            translations: {
                core: {
                    shared: I18n.t('core.shared'),
                    account: {
                        settings: I18n.t('core.account/settings'),
                    }
                }
            },
            old_settings: {
                'theme_color_primary': null,
                'theme_color_secondary': null,
                'theme_color_layout_header': null,
                'theme_color_layout_sidebar': null,
                'theme_color_layout_background': null,
                'theme_font_size': null,
                'theme_font_color': null
            },
            settings: {
                'theme_color_primary': null,
                'theme_color_secondary': null,
                'theme_color_layout_header': null,
                'theme_color_layout_sidebar': null,
                'theme_color_layout_background': null,
                'theme_font_size': null,
                'theme_font_color': null
            }
        }
    },
    mounted() {
        window.settings = this.translations.core.account.settings
        this.getSettings();
    },
    methods: {
        parseSettings(settings_raw){
            settings_raw.forEach(setting_raw => {
                if (setting_raw.name in this.settings){
                    this.settings[setting_raw.name] = setting_raw.value
                    this.old_settings[setting_raw.name] = setting_raw.value
                }
            });
        },
        getSettings(){
            let filters = {
                theme: true
            }
            let url = this.url.admin('account/settings').filters(filters)

            this.http.get(url).then(result => {
                if (result.successful) {
                    this.parseSettings(result.data);
                }else{
                    this.msg.error(result.error.message)
                }
            }).catch(error => {
                console.log(error)
            }).finally(() => {
                this.loading = false
            })
        },
        postSettings() {
            this.submitting_form = true
            this.http.post(this.url.admin('account/settings'), {
                settings: this.settings
            }).then(result => {
                if (result.successful) {
                    this.old_settings = JSON.parse(JSON.stringify(this.settings))
                    this.msg.success(this.translations.core.account.settings.messages_success_settings_saved_successfully)
                }else{
                    this.msg.error(result.error.message)
                }
            }).catch(error => {
                console.log(error)
            }).finally(() => {
                this.submitting_form = false
            })
        },
        clearSetting(setting_name){
            this.settings[setting_name] = this.old_settings[setting_name]
        }
    },

    watch: {
        'settings.theme_color_layout_header'(){
            document.querySelector(':root').style.setProperty('--app-theme-color-layout-header', this.settings.theme_color_layout_header);
        },

        'settings.theme_color_primary'(){
            document.querySelector(':root').style.setProperty('--app-theme-color-primary', this.settings.theme_color_primary);
        },

        'settings.theme_color_secondary'(){
            document.querySelector(':root').style.setProperty('--app-theme-color-secondary', this.settings.theme_color_secondary);
        },

        'settings.theme_color_layout_sidebar'(){
            document.querySelector(':root').style.setProperty('--app-theme-color-layout-sidebar', this.settings.theme_color_layout_sidebar);
        },

        'settings.theme_color_layout_background'(){
            document.querySelector(':root').style.setProperty('--app-theme-color-layout-background', this.settings.theme_color_layout_background);
        },

        'settings.theme_font_size'(){
            document.querySelector(':root').style.setProperty('--app-theme-font-size', this.settings.theme_font_size);
        },

        'settings.theme_font_color'(){
            document.querySelector(':root').style.setProperty('--app-theme-font-color', this.settings.theme_font_color);
        }
    }
}
</script>
<template>
    <div class="box pr-6 settings-general">
        <form class="pr-6 mr-6" @submit.prevent="postSettings()">
            <fieldset class="py-5 pl-2 pr-6 mr-6">
                
                <div class="field is-horizontal">
                    <div class="field-label is-normal">
                        <label class="label">
                            {{ translations.core.account.settings.column_theme_color_primary }}
                        </label>
                    </div>
                    <div class="field-body">
                        <div class="field has-addons">
                            <div class="control is-fullwidth">
                                <input class="input" type="color" v-model="settings.theme_color_primary">
                            </div>
                            <div class="control">
                                <button class="button" type="button" @click="clearSetting('theme_color_primary')">
                                    <b-icon size="is-small" icon="undo"></b-icon>
                                    <span>{{translations.core.account.settings.view_text_return_to_initial_value}}</span>
                                </button>
                            </div>
                        </div>
                    </div>
                </div>

                <div class="field is-horizontal">
                    <div class="field-label is-normal">
                        <label class="label">
                            {{ translations.core.account.settings.column_theme_color_secondary }}
                        </label>
                    </div>
                    <div class="field-body">
                        <div class="field has-addons">
                            <div class="control is-fullwidth">
                                <input class="input" type="color" v-model="settings.theme_color_secondary">
                            </div>
                            <div class="control">
                                <button class="button" type="button" @click="clearSetting('theme_color_secondary')">
                                    <b-icon size="is-small" icon="undo"></b-icon>
                                    <span>{{translations.core.account.settings.view_text_return_to_initial_value}}</span>
                                </button>
                            </div>
                        </div>
                    </div>
                </div>

                <div class="field is-horizontal">
                    <div class="field-label is-normal">
                        <label class="label">
                            {{ translations.core.account.settings.column_theme_color_layout_header }}
                        </label>
                    </div>
                    <div class="field-body">
                        <div class="field has-addons">
                            <div class="control is-fullwidth">
                                <input class="input" type="color" v-model="settings.theme_color_layout_header">
                            </div>
                            <div class="control">
                                <button class="button" type="button" @click="clearSetting('theme_color_layout_header')">
                                    <b-icon size="is-small" icon="undo"></b-icon>
                                    <span>{{translations.core.account.settings.view_text_return_to_initial_value}}</span>
                                </button>
                            </div>
                        </div>
                    </div>
                </div>

                <div class="field is-horizontal">
                    <div class="field-label is-normal">
                        <label class="label">
                            {{ translations.core.account.settings.column_theme_color_layout_sidebar}}
                        </label>
                    </div>
                    <div class="field-body">
                        <div class="field has-addons">
                            <div class="control is-fullwidth">
                                <input class="input" type="color" v-model="settings.theme_color_layout_sidebar">
                            </div>
                            <div class="control">
                                <button class="button" type="button" @click="clearSetting('theme_color_layout_sidebar')">
                                    <b-icon size="is-small" icon="undo"></b-icon>
                                    <span>{{translations.core.account.settings.view_text_return_to_initial_value}}</span>
                                </button>
                            </div>
                        </div>
                    </div>
                </div>

                <div class="field is-horizontal">
                    <div class="field-label is-normal">
                        <label class="label">
                            {{ translations.core.account.settings.column_theme_color_layout_background}}
                        </label>
                    </div>
                    <div class="field-body">
                        <div class="field has-addons">
                            <div class="control is-fullwidth">
                                <input class="input" type="color" v-model="settings.theme_color_layout_background">
                            </div>
                            <div class="control">
                                <button class="button" type="button" @click="clearSetting('theme_color_layout_background')">
                                    <b-icon size="is-small" icon="undo"></b-icon>
                                    <span>{{translations.core.account.settings.view_text_return_to_initial_value}}</span>
                                </button>
                            </div>
                        </div>
                    </div>
                </div>

                <div class="field is-horizontal">
                    <div class="field-label is-normal">
                        <label class="label">
                            {{ translations.core.account.settings.column_theme_font_color}}
                        </label>
                    </div>
                    <div class="field-body">
                        <div class="field has-addons">
                            <div class="control is-fullwidth">
                                <input class="input" type="color" v-model="settings.theme_font_color">
                            </div>
                            <div class="control">
                                <button class="button" type="button" @click="clearSetting('theme_font_color')">
                                    <b-icon size="is-small" icon="undo"></b-icon>
                                    <span>{{translations.core.account.settings.view_text_return_to_initial_value}}</span>
                                </button>
                            </div>
                        </div>
                    </div>
                </div>

                <div class="field is-horizontal">
                    <div class="field-label is-normal">
                        <label class="label">
                            {{ translations.core.account.settings.column_theme_font_size}}
                        </label>
                    </div>
                    <div class="field-body">
                        <div class="field has-addons">
                            <div class="control is-fullwidth">
                                <input class="input" type="text" v-model="settings.theme_font_size">
                            </div>
                            <div class="control">
                                <button class="button" type="button" @click="clearSetting('theme_font_size')">
                                    <b-icon size="is-small" icon="undo"></b-icon>
                                    <span>{{translations.core.account.settings.view_text_return_to_initial_value}}</span>
                                </button>
                            </div>
                        </div>
                    </div>
                </div>

                <div class="field is-grouped is-grouped-right">
                    <div class="control">
                        <button class="button is-primary">
                            <span v-if="submitting_form">
                                <b-icon icon="circle-notch" custom-class="fa-spin" size="is-small" />
                                &nbsp;
                                {{translations.core.shared.view_btn_saving}}
                            </span>
                            <span v-else>
                                <b-icon icon="save" size="is-small" />
                                &nbsp;
                                {{translations.core.shared.view_btn_save}}
                            </span>
                        </button>
                    </div>
                </div>
            </fieldset>
        </form>
    </div>
</template>
