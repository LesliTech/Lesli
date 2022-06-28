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
import componentSettingsForm from "Lesli/vue2/users/components/form-settings.vue"
import componentSecurityForm from "Lesli/vue2/users/components/form-security.vue"
import componentSubscriptions from "Lesli/vue2/users/components/subscriptions.vue"
import componentInformationCard from "Lesli/vue2/users/components/card-information.vue"
import componentInformationForm from "Lesli/vue2/users/components/form-information.vue"
import componentManagementSessions from "Lesli/vue2/users/components/management-sessions.vue"
import componentManagementNotifications from "Lesli/vue2/profiles/components/management-notifications.vue"
import componentInternetAccounts from "Lesli/vue2/users/components/internet-accounts.vue"



// ·
export default {
    components: {
        'component-settings-form': componentSettingsForm,
        'component-security-form': componentSecurityForm,
        'component-subscriptions': componentSubscriptions,
        'component-information-card': componentInformationCard,
        'component-information-form': componentInformationForm,
        'component-management-sessions': componentManagementSessions,
        'component-management-notifications': componentManagementNotifications,
        'component-internet-accounts': componentInternetAccounts
    },
    data() {
        return {
            user_id: null,
            user: {
                detail_attributes: {}
            },
            options: {
                engines: null
            },
            ready: false,
            active_tab: 0,
            translations: {
                core: {
                    users: I18n.t('core.users'),
                    shared: I18n.t('core.shared'),
                    profiles: I18n.t('core.profiles'),
                }
            },
        }
    },
    mounted() {
        this.user_id = this.lesli.current_user.id
        this.getUser()
        this.getOptions()
        if (this.$route.hash == "#force-password-reset") {
            this.active_tab = 2
        }
    },
    methods: {

        getUser() {
            this.http.get("/administration/profile.json").then(result => {
                if (!result.successful) {
                    this.msg.error(result.error.message)
                    return
                }
                this.data.user = result.data
            })
        },

        getOptions(){
            this.http.get("/administration/users/options.json").then(result => {
                if (result.successful) {
                    this.data.options = result.data
                }
            }).catch(error => {
                console.log(error)
            })
        }

    }
}
</script>

<template>
    <section class="application-component">
        <component-information-card :app-mount-path="''" :actions="false"></component-information-card>
        <b-tabs v-model="active_tab">
            <b-tab-item :label="translations.core.users.view_tab_title_information">
                <component-information-form></component-information-form>
            </b-tab-item>
            <b-tab-item :label="translations.core.users.view_tab_title_subscriptions">
                <component-subscriptions v-if="user_id"></component-subscriptions>
            </b-tab-item>
            <b-tab-item :label="translations.core.users.view_tab_title_security">
                <component-security-form></component-security-form>
            </b-tab-item>
            <b-tab-item :label="translations.core.users.view_tab_title_session_management">
                <component-management-sessions v-if="user_id" :user_id="user_id"></component-management-sessions>
            </b-tab-item>
            <b-tab-item :label="translations.core.profiles.view_tab_title_internet_accounts">
                <component-internet-accounts></component-internet-accounts>
            </b-tab-item>
            <b-tab-item :label="translations.core.users.view_tab_title_settings">
                <component-settings-form v-if="user_id" :user_id="user_id"></component-settings-form>
            </b-tab-item>
        </b-tabs>
    </section>
</template>
