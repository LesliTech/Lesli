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
            options: {
                countries: [],
                regions: []
            }
        }
    },

    mounted() {
        this.getOptions()
    },

    methods: {
        getOptions(){
            this.http.get(this.url.admin("account/options")).then(result => {
                if (result.successful) {
                    this.options = result.data;
                } else {
                    this.msg.error(result.error.message)
                }
            }).catch(error => {
                console.log(error)
            })
        },
    }

}
</script>
<template>
    <div class="card">
        <div class="card-header">
            <h3>{{ translations.core.onboardings.view_title_contact_information }}</h3>
        </div>
        <div class="card-content">
            <div class="columns is-marginless has-border-bottom">
                <div class="column is-3">
                    <label class="label">
                        {{ translations.core.accounts.column_country }}
                    </label>
                </div>
                <div class="column">
                    <b-select
                        v-if="options.countries"
                        name="country"
                        v-model="data.account.country"
                        expanded
                    >
                        <option
                            v-for="country in options.countries"
                            :value="country.id"
                            :key="country.name"
                        >
                            {{ country.name }}
                        </option>
                    </b-select>
                </div>
            </div>

            <div class="columns is-marginless has-border-bottom">
                <div class="column is-3">
                    <label class="label">
                        {{ translations.core.accounts.column_address }}
                    </label>
                </div>
                <div class="column">
                    <b-input name="address" v-model="data.account.address"></b-input>
                </div>
            </div>

            <div class="columns is-marginless has-border-bottom">
                <div class="column is-3">
                    <label class="label">
                        {{ translations.core.accounts.column_region }}
                    </label>
                </div>
                <div class="column">
                    <b-select
                        v-if="options.regions"
                        name="region"
                        v-model="data.account.region"
                        expanded
                    >
                        <option
                            v-for="region in options.regions"
                            :value="region.value"
                            :key="region.key"
                        >
                            {{ region.value }}
                        </option>
                    </b-select>
                </div>
            </div>

            <div class="columns is-marginless has-border-bottom">
                <div class="column is-3">
                    <label class="label">
                        {{ translations.core.accounts.column_phone_number_1 }}
                    </label>
                </div>
                <div class="column">
                    <b-input name="phone-number-1" v-model="data.account.phone_number_1"></b-input>
                </div>
            </div>

            <!--
            <div class="columns is-marginless has-border-bottom">
                <div class="column is-3">
                    <label class="label">
                        {{ translations.core.accounts.column_phone_number_2 }}
                    </label>
                </div>
                <div class="column">
                    <b-input name="phone-number-2" v-model="data.account.phone_number_2"></b-input>
                </div>
            </div>

            <div class="columns is-marginless has-border-bottom">
                <div class="column is-3">
                    <label class="label">
                        {{ translations.core.accounts.column_phone_number_3 }}
                    </label>
                </div>
                <div class="column">
                    <b-input name="phone-number-3" v-model="data.account.phone_number_3"></b-input>
                </div>
            </div>

            <div class="columns is-marginless has-border-bottom">
                <div class="column is-3">
                    <label class="label">
                        {{ translations.core.accounts.column_phone_number_4 }}
                    </label>
                </div>
                <div class="column">
                    <b-input name="phone-number-4" v-model="data.account.phone_number_4"></b-input>
                </div>
            </div>
            -->

        </div>
    </div>
</template>
