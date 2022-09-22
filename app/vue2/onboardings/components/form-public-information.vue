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
            <h3>{{ translations.core.onboardings.view_title_public_information }}</h3>
        </div>
        <div class="card-content">
            <div class="columns is-marginless has-border-bottom">
                <div class="column is-3">
                    <label class="label">
                        {{ translations.core.accounts.column_website }}
                    </label>
                </div>
                <div class="column">
                    <b-input name="website" v-model="data.account.website"></b-input>
                </div>
            </div>

            <div class="columns is-marginless has-border-bottom">
                <div class="column is-3">
                    <label class="label">
                        {{ translations.core.accounts.column_public_email }}
                    </label>
                </div>
                <div class="column">
                    <b-input name="public-email" v-model="data.account.public_email"></b-input>
                </div>
            </div>

            <div class="columns is-marginless has-border-bottom">
                <div class="column is-3">
                    <label class="label">
                        {{ translations.core.accounts.column_github }}
                    </label>
                </div>
                <div class="column">
                    <b-input name="github" v-model="data.account.github"></b-input>
                </div>
            </div>

            <div class="columns is-marginless has-border-bottom">
                <div class="column is-3">
                    <label class="label">
                        {{ translations.core.accounts.column_twitter}}
                    </label>
                </div>
                <div class="column">
                    <b-input name="twitter" v-model="data.account.twitter"></b-input>
                </div>
            </div>

            <div class="columns is-marginless has-border-bottom">
                <div class="column is-3">
                    <label class="label">
                        {{ translations.core.accounts.column_youtube }}
                    </label>
                </div>
                <div class="column">
                    <b-input name="youtube" v-model="data.account.youtube"></b-input>
                </div>
            </div>

            <div class="columns is-marginless has-border-bottom">
                <div class="column is-3">
                    <label class="label">
                        {{ translations.core.accounts.column_linkedin}}
                    </label>
                </div>
                <div class="column">
                    <b-input name="linkedin" v-model="data.account.linkedin"></b-input>
                </div>
            </div>

            <div class="columns is-marginless has-border-bottom">
                <div class="column is-3">
                    <label class="label">
                        {{ translations.core.accounts.column_facebook }}
                    </label>
                </div>
                <div class="column">
                    <b-input name="facebook" v-model="data.account.facebook"></b-input>
                </div>
            </div>

        </div>
    </div>
</template>
