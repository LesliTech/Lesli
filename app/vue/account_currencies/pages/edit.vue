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


// ·
// · ~·~     ~·~     ~·~     ~·~     ~·~     ~·~     ~·~     ~·~     ~·~     ~·~     ~·~     ~·~


export default {
    props: {

    },

    components: {
        'component-form': componentForm
    },

    data(){
        return {
            account_currency: null,
            account_currency_id: null,
            translations: {
                core: {
                    shared: I18n.t('core.shared'),
                    account: {
                        currencies: I18n.t("core.account/currencies"),
                    }
                }
            }
        }
    },

    mounted(){
        this.setAccountCurrencyId();
        this.getAccountCurrency();
    },

    methods: {
        setAccountCurrencyId(){
            this.account_currency_id = this.$route.params.id
        },
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
                </div>
            </div>
        </component-header>
        <component-form v-if="data.account_currency" view-type="edit"></component-form>
    </section>
</template>
