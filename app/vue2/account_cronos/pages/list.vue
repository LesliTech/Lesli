<script>
/**
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



// ·
export default {
    data() {
        return {
            translations: {
                core: {
                    cronos: I18n.t("core.account/cronos"),
                    shared: I18n.t('core.shared'),
                    users: I18n.t('core.users'),
                }
            }
        }
    }
}
</script>

<template>
    <section class="application-component">
        <component-header title="Scheduled tasks">
            <router-link to="/new" class="button is-primary">
                {{ translations.core.cronos.view_btn_new }}
            </router-link>
        </component-header>
        <component-toolbar></component-toolbar>
        <div class="box">
            <div class="table"></div>
        </div>
    </section>
</template>
