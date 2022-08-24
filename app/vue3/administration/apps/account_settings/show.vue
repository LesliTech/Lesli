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
import { ref, reactive, onMounted, watch, computed } from "vue"

// . import components 
import formTime from "./components/form-time.vue"
import formSecurity from "./components/form-security.vue"

// · translations
const translations = {
    core: {
        accounts: I18n.t("core.accounts"),
        shared: I18n.t('core.shared'),
        account: {
            settings: I18n.t("core.account/settings"),
        }
    },
}

// · 
const active = ref(0)

</script>

<template>
    <section class="application-component">
        <lesli-header title="Account Settings"></lesli-header>
        <lesli-tabs v-model="active">
            <lesli-tab-item :title="translations.core.account.settings.view_tab_title_security_settings" icon="lock">
                <div class="box">
                    <formSecurity></formSecurity>
                </div>
            </lesli-tab-item>
            <lesli-tab-item :title="translations.core.account.settings.view_tab_title_time_settings" icon="watch_later">
                <div class="box">
                    <formTime></formTime>
                </div>
            </lesli-tab-item>
            <lesli-tab-item :title="translations.core.account.settings.view_tab_title_branding" icon="collections">

            </lesli-tab-item>
            <lesli-tab-item :title="translations.core.account.settings.view_tab_title_theme" icon="brush">

            </lesli-tab-item>

        </lesli-tabs>
    </section>
</template>
