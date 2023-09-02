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
import { onMounted, ref } from "vue"

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
        }
    },
}

onMounted(() => {
    storeAccountSettings.getSettings()
    storeAccountSettings.getRoles()

})

</script>
<template>



<section class="application-component">
    <lesli-header 
        :title="translations.core.account.settings.view_tab_title_security_settings">
    </lesli-header>
    <div class="box">
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
                                value: 'Enabled',
                            },
                            {
                                label: translations.core.account.settings.view_text_password_enforcement_disabled,
                                value: 'Disabled',
                            },
                        ]"
                        v-model="storeAccountSettings.settings.password_enforce_complexity"
                    >
                    </lesli-select>
                    <p class="has-text-info">
                        {{ translations.core.account.settings.view_text_password_complex_description }}
                    </p>
                </div>
            </div>

            <div class="columns">
                <div class="column is-4">
                    <label class="label">
                        {{ translations.core.account.settings.column_default_role }}
                    </label>
                </div>
                <div class="column is-6">
                    <lesli-select
                            v-model="storeAccountSettings.settings.default_role_id"
                            :placeholder="translations.core.view_placeholder_select_option"
                            :options="storeAccountSettings.roles"
                            ></lesli-select>
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
                        <input class="input" type="number" v-model="storeAccountSettings.settings.password_lowercase_count">
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
                        <input class="input" type="number" v-model="storeAccountSettings.settings.password_uppercase_count">
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
                        <input class="input" type="number" v-model="storeAccountSettings.settings.password_digit_count">
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
                        <input class="input" type="number" v-model="storeAccountSettings.settings.password_special_char_count">
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
                        <input class="input" type="number" v-model="storeAccountSettings.settings.password_minimum_length">
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
                        <input class="input" type="number" v-model="storeAccountSettings.settings.password_expiration_time_days">
                    </div>
                </div>
            </div>

            <div class="field is-grouped is-grouped-centered">
                <div class="control">
                    <lesli-button class="button is-primary" icon="save">
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
    </div>
        </section>
</template>
