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


// · List of Imported Components
// · ~·~     ~·~     ~·~     ~·~     ~·~     ~·~     ~·~     ~·~     ~·~     ~·~     ~·~     ~·~


// · 
// · ~·~     ~·~     ~·~     ~·~     ~·~     ~·~     ~·~     ~·~     ~·~     ~·~     ~·~     ~·~
export default {
    components: {},

    props: {
      account_currency: {
          required: true
      }
    },

    data() {
        return {
            translations: {
                core: {
                    shared: I18n.t('core.shared'),
                    account: {
                        currencies: I18n.t("core.account/currencies"),
                        exchange_rates: I18n.t("core.account/exchange_rates"),
                    }
                }
            },
        }
    },
    mounted() {},

    methods: {}
}
</script>
<template>
    <div class="card" v-if="account_currency">
        <div class="card-content subtabs">
            <div class="columns is-multiline">
                <div class="column is-12">
                    <b-field :label="translations.core.account.currencies.column_name">
                        <p>{{account_currency.name}}</p>
                    </b-field>
                </div>
                <div class="column is-4">
                    <b-field :label="translations.core.account.currencies.column_symbol">
                       <p>{{account_currency.symbol}} &nbsp;</p>
                    </b-field>
                </div>
                <div class="column is-4">
                    <b-field :label="translations.core.account.currencies.column_country_alpha_3">
                        <p>{{account_currency.country_alpha_3}} &nbsp;</p>
                    </b-field>
                </div>
            </div>
        </div>
    </div>
</template>