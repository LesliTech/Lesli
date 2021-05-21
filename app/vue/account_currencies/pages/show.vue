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
import componentForm from '../components/form.vue'
import componentCurrency from '../components/currency.vue'

// ·
// · ~·~     ~·~     ~·~     ~·~     ~·~     ~·~     ~·~     ~·~     ~·~     ~·~     ~·~     ~·~
export default {
    props: {},

    components: {
        'component-form': componentForm,
        'component-currency': componentCurrency
    },

    data(){
        return {
            translations: {
                core: {
                    shared: I18n.t('core.shared'),
                    account: {
                        currencies: I18n.t("core.account/currencies"),
                    }
                }
            },
            account_currency: null,
            account_currency_id: null,
        }
    },

    mounted(){
        this.account_currency_id = this.$route.params.id;
        this.getAccountCurrency();
    },

    methods: {
        getAccountCurrency() {
            this.http.get(this.url.admin("account/currencies/:id", { id: this.account_currency_id  })).then(result => {
                if (result.successful) {
                    this.account_currency = result.data;
                    this.data.account_currency = this.account_currency;
                    this.data.reload.account_currency = true;
                }else{
                    this.alert(result.error.message,'danger');
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
        <component-header :title="translations.core.account.currencies.view_text_title" >
            <div class="navbar-item">
                <div class="buttons">
                    <router-link class="button" to="/">
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
        <b-tabs>
            <b-tab-item :label="translations.core.account.currencies.view_tab_title_general_information">
                <component-currency v-if="data.account_currency" :account_currency="account_currency"></component-currency>
            </b-tab-item>
            <b-tab-item :label="translations.core.account.currencies.view_tab_title_exchange_rates">
            </b-tab-item>
        </b-tabs>
    </section>
</template>
