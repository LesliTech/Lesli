<script setup>
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

// · import vue tools
import { onMounted, watch } from "vue"

// · import lesli stores
import { useAccountSettings } from "Lesli/vue3/administration/stores/accountSettings"

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
    document.querySelector(':root').style.setProperty('--lesli-theme-color-primary', storeAccountSettings.settings.lesli_theme_color_primary)
})

watch(() => storeAccountSettings.settings.lesli_theme_header_color, () => {
    document.querySelector(':root').style.setProperty('--lesli-theme-header-color', storeAccountSettings.settings.lesli_theme_header_color)
})

watch(() => storeAccountSettings.settings.lesli_theme_sidebar_color, () => {
    document.querySelector(':root').style.setProperty('--lesli-theme-sidebar-color', storeAccountSettings.settings.lesli_theme_sidebar_color)
})

watch(() => storeAccountSettings.settings.lesli_theme_color_background, () => {
    document.querySelector(':root').style.setProperty('--lesli-theme-color-background', storeAccountSettings.settings.lesli_theme_color_background)
})

watch(() => storeAccountSettings.settings.lesli_theme_font_color, () => {
    document.querySelector(':root').style.setProperty('--lesli-theme-font-color', storeAccountSettings.settings.lesli_theme_font_color)
})

watch(() => storeAccountSettings.settings.lesli_theme_font_size, () => {
    document.querySelector(':root').style.setProperty('--lesli-theme-font-size', storeAccountSettings.settings.lesli_theme_font_size)
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

