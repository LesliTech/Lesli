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
      exchange_rate: {
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
                        exchange_rates: I18n.t("core.account/currency/exchange_rates"),
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
    <div class="card" v-if="exchange_rate">
        <div class="card-content subtabs">
            <div class="columns is-multiline">
                <div class="column is-12">
                    <b-field :label="translations.core.account.exchange_rates.column_exchange_rate">
                        <p>{{exchange_rate.exchange_rate}}</p>
                    </b-field>
                </div>
                <div class="column is-4">
                    <b-field :label="translations.core.account.exchange_rates.column_valid_from">
                       <p>{{exchange_rate.valid_from_string}} &nbsp;</p>
                    </b-field>
                </div>
                <div class="column is-4">
                    <b-field :label="translations.core.account.exchange_rates.column_valid_to">
                        <p>{{exchange_rate.valid_to_string}} &nbsp;</p>
                    </b-field>
                </div>
            </div>
        </div>
    </div>
</template>