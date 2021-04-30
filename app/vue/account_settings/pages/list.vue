<script>
/*
Copyright (c) 2020, all rights reserved.

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
import componentFormTheme from "../components/form-theme.vue"
import componentFormGeneral from "../components/form-general.vue"
import componentFormBranding from "../components/form-branding.vue"


// ·
export default {
    components: {
        "component-form-theme": componentFormTheme,
        "component-form-general": componentFormGeneral,
        "component-form-branding": componentFormBranding
    },
    data() {
        return {
            tab: 2,
            translations: {
                core: {
                    shared: I18n.t('core.shared'),
                    account: {
                        settings: I18n.t("core.account/settings"),
                    }
                }
            },
        }
    },
    methods: {

    }
}
</script>
<template>
    <section class="application-component">
        <component-header :title="translations.core.account.settings.view_title_account_settings"></component-header>
        <b-tabs v-model="tab">
            <b-tab-item icon-pack="fas" icon="cog" :label="translations.core.account.settings.view_tab_title_general">
                <component-form-general></component-form-general>
            </b-tab-item>
            <b-tab-item icon-pack="fas" icon="palette" :label="translations.core.account.settings.view_tab_title_branding">
                <component-form-branding></component-form-branding>
            </b-tab-item>
            <b-tab-item icon-pack="fas" icon="paint-brush" :label="translations.core.account.settings.view_tab_title_theme">
                <component-form-theme></component-form-theme>
            </b-tab-item>
        </b-tabs>
    </section>
</template>
