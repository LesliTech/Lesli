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
import componentExchangeRate from '../components/exchange_rate.vue'

// ·
// · ~·~     ~·~     ~·~     ~·~     ~·~     ~·~     ~·~     ~·~     ~·~     ~·~     ~·~     ~·~
export default {
    props: {},

    components: {
        'component-exchange_rate': componentExchangeRate
    },

    data(){
        return {
            translations: {
                core: {
                    shared: I18n.t('core.shared'),
                    account: {
                        exchange_rates: I18n.t("core.account/currency/exchange_rates"),
                    }
                }
            },
            exchange_rate: null,
            account_currency_id: null,
            exchange_rates_id: null,
        }
    },

    mounted(){
        this.account_currency_id = this.$route.params.account_currency_id;
        this.exchange_rates_id = this.$route.params.id;
      this.getExchangeRate();
    },

    methods: {
        getExchangeRate() {
            this.http.get(this.url.admin("account/currencies/:account_currency_id/exchange_rates/:exchange_rates_id", {
                account_currency_id: this.account_currency_id,
                exchange_rates_id: this.exchange_rates_id
            })).then(result => {
                if (result.successful) {
                    this.exchange_rate = result.data;
                    this.data.exchange_rate = this.exchange_rate;
                    this.data.reload.exchange_rate = true;
                }else{
                    this.msg.error(result.error.message);
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
        <component-header :title="translations.core.account.exchange_rates.view_title_exchange_rates">
            <div class="navbar-item">
                <div class="buttons">
                    <router-link class="button" :to="{path: `/${this.account_currency_id}/exchange_rates/`}">
                        <b-icon icon="list" size="is-small" />
                        <span>{{ translations.core.shared.view_btn_list }}</span>
                    </router-link>
                    <router-link class="button" :to="`/${account_currency_id}/edit`">
                        <b-icon icon="edit" size="is-small" />
                        <span>{{ translations.core.shared.view_btn_edit }}</span>
                    </router-link>
                </div>
            </div>
        </component-header>
        <component-exchange_rate v-if="exchange_rate" :exchange_rate="exchange_rate"></component-exchange_rate>
    </section>
</template>
