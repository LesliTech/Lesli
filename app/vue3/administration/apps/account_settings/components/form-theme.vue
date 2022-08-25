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
import { onMounted } from "vue"

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

onMounted(() => {
    storeAccountSettings.getSettings()
});

</script>
<template>
    <form @submit.prevent="storeAccountSettings.postSettings">
        <div class="field is-horizontal">
            <div class="field-label is-normal">
                <label class="label">
                    {{ translations.core.account.settings.column_theme_color_primary }}
                </label>
            </div>
            <div class="field-body">
                <div class="field has-addons">
                    <div class="control is-fullwidth">
                        <input class="input" type="color" v-model="storeAccountSettings.settings.lesli_theme_color_primary">
                    </div>
                    <div class="control">
                        <lesli-button @click="storeAccountSettings.clearSetting('lesli_theme_color_primary')" icon="settings_backup_restore">
                            {{translations.core.account.settings.view_text_return_to_initial_value}}
                        </lesli-button>
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
                        <input class="input" type="color" v-model="storeAccountSettings.settings.lesli_theme_color_secondary">
                    </div>
                    <div class="control">
                        <lesli-button @click="storeAccountSettings.clearSetting('lesli_theme_color_secondary')" icon="settings_backup_restore">
                            {{translations.core.account.settings.view_text_return_to_initial_value}}
                        </lesli-button>
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
                        <input class="input" type="color" v-model="storeAccountSettings.settings.lesli_theme_color_header">
                    </div>
                    <div class="control">
                        <lesli-button @click="storeAccountSettings.clearSetting('lesli_theme_color_header')" icon="settings_backup_restore">
                            {{translations.core.account.settings.view_text_return_to_initial_value}}
                        </lesli-button>
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
                        <input class="input" type="color" v-model="storeAccountSettings.settings.lesli_theme_color_sidebar">
                    </div>
                    <div class="control">
                        <lesli-button @click="storeAccountSettings.clearSetting('lesli_theme_color_sidebar')" icon="settings_backup_restore">
                            {{translations.core.account.settings.view_text_return_to_initial_value}}
                        </lesli-button>
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
                        <input class="input" type="color" v-model="storeAccountSettings.settings.lesli_theme_color_background">
                    </div>
                    <div class="control">
                        <lesli-button @click="storeAccountSettings.clearSetting('lesli_theme_color_background')" icon="settings_backup_restore">
                            {{translations.core.account.settings.view_text_return_to_initial_value}}
                        </lesli-button>
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
                        <input class="input" type="color" v-model="storeAccountSettings.settings.lesli_theme_font_color">
                    </div>
                    <div class="control">
                        <lesli-button @click="storeAccountSettings.clearSetting('lesli_theme_font_color')" icon="settings_backup_restore">
                            {{translations.core.account.settings.view_text_return_to_initial_value}}
                        </lesli-button>
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
                        <input class="input" type="number" v-model="storeAccountSettings.settings.lesli_theme_font_size">
                    </div>
                    <div class="control">
                        <lesli-button @click="storeAccountSettings.clearSetting('lesli_theme_font_size')" icon="settings_backup_restore">
                            {{translations.core.account.settings.view_text_return_to_initial_value}}
                        </lesli-button>
                    </div>
                </div>
            </div>
        </div>

        <div class="control">
            <lesli-button>
                <span v-if="storeAccountSettings.submitting_form">
                    {{translations.core.shared.view_btn_saving}}
                </span>
                <span v-else>
                    {{translations.core.shared.view_btn_save}}
                </span>
            </lesli-button>
        </div>
    </form>
</template>
