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
            account_currency: {},
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
        this.initializeCurrency();
    },

    methods: {
        initializeCurrency(){
          this.data.account_currency = null
          this.account_currency = {
              name: null,
              symbol: null,
              country_alpha_3: null,
          }
          this.$nextTick(()=>{
              this.data.account_currency = this.account_currency
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
        <component-form v-if="data.account_currency" view-type="new"></component-form>
    </section>
</template>
