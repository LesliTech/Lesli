<script setup>
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


// · import vue tools
import { onMounted, watch } from "vue"

// · import lesli stores
import { useAccountSettings } from "LesliApp/administration/stores/accountSettings"

// · implement stores
const storeAccountSettings = useAccountSettings()

// · translations
const translations = {
    core: {
        accounts: I18n.t("core.accounts"),
        shared: I18n.t('core.shared'),
        account: {
            settings: I18n.t("core.account/settings"),
            files: I18n.t('core.account/files')
        }
    },
}

watch(() => storeAccountSettings.settings.lesli_theme_color_primary, () => {
    document.querySelector(':root').style.setProperty('--lesli-color-primary', storeAccountSettings.settings.lesli_theme_color_primary)
})

watch(() => storeAccountSettings.settings.lesli_theme_header_color, () => {
    document.querySelector(':root').style.setProperty('--lesli-header-color', storeAccountSettings.settings.lesli_theme_header_color)
})

watch(() => storeAccountSettings.settings.lesli_theme_sidebar_color, () => {
    document.querySelector(':root').style.setProperty('--lesli-sidebar-color', storeAccountSettings.settings.lesli_theme_sidebar_color)
})

watch(() => storeAccountSettings.settings.lesli_theme_color_background, () => {
    document.querySelector(':root').style.setProperty('--lesli-color-background', storeAccountSettings.settings.lesli_theme_color_background)
})

watch(() => storeAccountSettings.settings.lesli_theme_font_color, () => {
    document.querySelector(':root').style.setProperty('--lesli-theme-font-color', storeAccountSettings.settings.lesli_theme_font_color)
})

watch(() => storeAccountSettings.settings.lesli_theme_font_size, () => {
    document.querySelector(':root').style.setProperty('--lesli-theme-font-size', storeAccountSettings.settings.lesli_theme_font_size + 'px')
})

onMounted(() => {
    storeAccountSettings.getSettings()
})


</script>
<template>
    <section class="application-component">
        <lesli-header 
            :title="translations.core.account.settings.view_tab_title_theme">
        </lesli-header>
        <form @submit.prevent="storeAccountSettings.postSettings">
            <div class="columns">
                <div class="column is-3">
                    <label class="label">
                        {{ translations.core.account.settings.column_theme_color_primary }}
                    </label>
                </div>
                <div class="column is-2">
                    <input class="input" type="color" v-model="storeAccountSettings.settings.lesli_theme_color_primary">
                </div>

                <div class="column is-1">
                    <lesli-button @click="storeAccountSettings.clearSetting('lesli_theme_color_primary')" icon="settings_backup_restore">
                    </lesli-button>
                </div>

                <div class="column is-3">
                    <label class="label">
                        {{ translations.core.account.settings.column_theme_color_layout_header }}
                    </label>
                </div>

                <div class="column is-2">
                    <input class="input" type="color" v-model="storeAccountSettings.settings.lesli_theme_header_color">
                </div>
                <div class="column is-1">
                    <lesli-button @click="storeAccountSettings.clearSetting('lesli_theme_header_color')" icon="settings_backup_restore">
                    </lesli-button>
                </div>
            </div>

            <div class="columns">
                <div class="column is-3">
                    <label class="label">
                        {{ translations.core.account.settings.column_theme_color_layout_sidebar}}
                    </label>
                </div>
                <div class="column is-2">
                        <input class="input" type="color" v-model="storeAccountSettings.settings.lesli_theme_sidebar_color">
                </div>
                <div class="column is-1">
                    <lesli-button @click="storeAccountSettings.clearSetting('lesli_theme_sidebar_color')" icon="settings_backup_restore">
                    </lesli-button>
                </div>
                
                <div class="column is-3">
                    <label class="label">
                        {{ translations.core.account.settings.column_theme_color_layout_background}}
                    </label>
                </div>
                <div class="column is-2">
                    <input class="input" type="color" v-model="storeAccountSettings.settings.lesli_theme_color_background">
                </div>
                <div class="column is-1">
                    <lesli-button @click="storeAccountSettings.clearSetting('lesli_theme_color_background')" icon="settings_backup_restore">
                    </lesli-button>
                </div>
            </div>

            <div class="columns">
                <div class="column is-3 is-grouped-centered">
                    <label class="label">
                        {{ translations.core.account.settings.column_theme_font_color}}
                    </label>
                </div>
                <div class="column is-2">
                    <input class="input" type="color" v-model="storeAccountSettings.settings.lesli_theme_font_color">
                </div>
                <div class="column is-1">
                    <lesli-button @click="storeAccountSettings.clearSetting('lesli_theme_font_color')" icon="settings_backup_restore">
                    </lesli-button>
                </div>
                
                <div class="column is-3">
                    <label class="label">
                        {{ translations.core.account.settings.column_theme_font_size}}
                    </label>
                </div>
                <div class="column is-2">
                    <input class="input" type="number" v-model="storeAccountSettings.settings.lesli_theme_font_size">
                </div>
                <div class="column is-1">
                    <lesli-button @click="storeAccountSettings.clearSetting('lesli_theme_font_size')" icon="settings_backup_restore">
                    </lesli-button>
                </div>
            </div>

            <div class="field is-grouped is-grouped-centered">
                <div class="control">
                    <lesli-button icon="save">
                        <span v-if="storeAccountSettings.submitting_form">
                            {{translations.core.shared.view_btn_saving}}
                        </span>
                        <span v-else>
                            {{translations.core.shared.view_btn_save}}
                        </span>
                    </lesli-button>
                </div>
            </div>
        </form>
    </section>
</template>

