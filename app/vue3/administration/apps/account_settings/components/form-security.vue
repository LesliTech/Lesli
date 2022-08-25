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
import { onMounted, computed, ref } from "vue"

// · import lesli stores
import { useAccountSettings } from "Lesli/vue3/administration/stores/accountSettings"

// · implement stores
const storeAccountSettings = useAccountSettings()

// . declare variables 
const enforcementPassword = ref("")

function updateEnforcement() {
    settings.value.password_enforce_complexity = enforcementPassword.value.value
}

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

onMounted(() => {
    storeAccountSettings.getSettings()
});

// . get reactive info from onboarding store
const settings = computed(() => storeAccountSettings.settings)

</script>
<template>
    <form @submit.prevent="storeAccountSettings.postSettings">
        <div class="columns">
            <div class="column is-4">
                <label class="label">
                    {{ translations.core.account.settings.column_password_complex_enable }}
                </label>
            </div>
            <div class="column is-6">
                <lesli-select
                    :options="[
                        {
                            label: translations.core.account.settings.view_text_password_enforcement_enabled,
                            value: '1',
                        },
                        {
                            label: translations.core.account.settings.view_text_password_enforcement_disabled,
                            value: '0',
                        },
                    ]"
                    v-model="enforcementPassword"
                    @change="updateEnforcement"
                >
                </lesli-select>
            </div>
        </div>

        <div class="columns">
            <div class="column is-4">
                <label class="label">
                    {{ translations.core.account.settings.column_password_lowercase_count }}
                </label>
            </div>
            <div class="column is-6">
                <div class="control">
                    <input class="input" type="number" v-model="settings.password_lowercase_count">
                </div>
            </div>
        </div>

        <div class="columns">
            <div class="column is-4">
                <label class="label">
                    {{ translations.core.account.settings.column_password_uppercase_count }}
                </label>
            </div>
            <div class="column is-6">
                <div class="control">
                    <input class="input" type="number" v-model="settings.password_uppercase_count">
                </div>
            </div>
        </div>

        <div class="columns">
            <div class="column is-4">
                <label class="label">
                    {{ translations.core.account.settings.column_password_numeric_count }}
                </label>
            </div>
            <div class="column is-6">
                <div class="control">
                    <input class="input" type="number" v-model="settings.password_digit_count">
                </div>
            </div>
        </div>

        <div class="columns">
            <div class="column is-4">
                <label class="label">
                    {{ translations.core.account.settings.column_password_special_char_count }}
                </label>
            </div>
            <div class="column is-6">
                <div class="control">
                    <input class="input" type="number" v-model="settings.password_special_char_count">
                </div>
            </div>
        </div>

        <div class="columns">
            <div class="column is-4">
                <label class="label">
                    {{ translations.core.account.settings.column_password_minimum_length }}
                </label>
            </div>
            <div class="column is-6">
                <div class="control">
                    <input class="input" type="number" v-model="settings.password_minimum_length">
                </div>
            </div>
        </div>

        <div class="columns">
            <div class="column is-4">
                <label class="label">
                    {{ translations.core.account.settings.column_password_expiration_time_days }}
                </label>
            </div>
            <div class="column is-6">
                <div class="control">
                    <input class="input" type="number" v-model="settings.password_expiration_time_days">
                </div>
            </div>
        </div>

        <div class="control">
            <lesli-button class="button is-primary">
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
