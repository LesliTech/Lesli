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

export default {

    data() {
        return {
            translations: {
                core: {
                    users: I18n.t("core.users"),
                    roles: I18n.t("core.roles"),
                    shared: I18n.t("core.shared"),
                    accounts: I18n.t("core.accounts"),
                    onboardings: I18n.t("core.onboardings"),
                }
            },
        }
    },

}
</script>
<template>
    <div class="card">
        <div class="card-header">
            <h3>{{ translations.core.onboardings.view_title_welcome_configuration_wizard }}</h3>
            <p>{{ translations.core.onboardings.view_text_basic_information}}</p>
        </div>
        <div class="card-content">

            <form>

                <div class="field">
                    <label class="label">{{ translations.core.accounts.column_company_name }}</label>
                    <div class="control">
                        <input class="input" v-model="data.account.company_name" required />
                    </div>
                </div>

                <div class="field">
                    <label class="label">{{ translations.core.accounts.column_company_legal_name }}</label>
                    <div class="control">
                        <input class="input" name="company-name-legal" v-model="data.account.company_name_legal" />
                    </div>
                </div>

                <div class="field">
                    <label class="label">{{ translations.core.accounts.column_tag_line }}</label>
                    <div class="control">
                        <input class="input" name="company-tag-line" v-model="data.account.company_tag_line" />
                    </div>
                </div>

            </form>
            
        </div>
    </div>
</template>
