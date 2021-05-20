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

import DatePicker from 'v-calendar/lib/components/date-picker.umd'

export default {
    props: {
        viewType: {
            type: String,
            required: true
        }
    },

    components: {
        'vc-date-picker': DatePicker
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
            submitting_form: false,
            account_currency: {
                name: null,
                symbol: null,
                country_alpha_3: null,
            },
        }
    },

    mounted() {
        this.setAccountCurrency();
    },

    methods: {
        setAccountCurrency(){
            this.account_currency_id = this.$route.params.id;
            this.account_currency = this.data.account_currency;
        },
        submitCurrency(event){
            if (event) { event.preventDefault() }

            if (this.account_currency.id) {
                this.putCurrency();
            } else {
                this.postCurrency();
            }
        },

        postCurrency() {
            this.submitting_form = true 
            let data = {
                account_currency: this.account_currency
            }

            this.http.post(this.url.admin("account/currencies"), data).then(result => {
                if (result.successful) {
                    this.msg.success(this.translations.core.account.currencies.messages_success_currency_created_successfully)
                    this.$router.push(`/${result.data.id}`)
                }else{
                    this.msg.error(result.error.message)
                }

                this.submitting_form = false 
            }).catch(error => {
                console.log(error)
            })

        },

        putCurrency() {
            this.submitting_form = true
            let data = {
                account_currency: this.account_currency
            }
            this.http.put(this.url.admin("account/currencies/:id", {id: this.account_currency_id}), data).then(result => {
                if (result.successful) {
                    this.msg.success(this.translations.core.account.currencies.messages_success_currency_updated_successfully)
                }else{
                    this.msg.error(result.error.message)
                }
            }).catch(error => {
                console.log(error)
            }).finally(error => {
                this.submitting_form = false
            })

        }
    }
}
</script>
<template>
    <div class="card">
        <div class="card-content">
            <b-tabs>
                <b-tab-item :label="translations.core.account.currencies.view_tab_title_general_information">
                    <form @submit.prevent="submitCurrency">
                        <fieldset :disabled="submitting_form">
                            <!-- Name -->
                            <div class="field">
                                <label class="label">{{ translations.core.account.currencies.column_name }}
                                    <sup class="has-text-danger">*</sup>
                                </label>
                                <div class="control">
                                    <input
                                        v-model="account_currency.name"
                                        class="input"
                                        type="text"
                                        name="currency-name"
                                        required>
                                </div>
                            </div>

                              <!-- Symbol -->
                              <div class="field">
                                  <label class="label">{{ translations.core.account.currencies.column_symbol }}
                                      <sup class="has-text-danger">*</sup>
                                  </label>
                                  <div class="control">
                                      <input
                                          v-model="account_currency.symbol"
                                          class="input"
                                          type="text"
                                          name="currency-symbol"
                                          required>
                                  </div>
                              </div>

                              <!-- Country Code -->
                              <div class="field">
                                  <label class="label">{{ translations.core.account.currencies.column_country_alpha_3 }}
                                      <sup class="has-text-danger">*</sup>
                                  </label>
                                  <div class="control">
                                      <input
                                          v-model="account_currency.country_alpha_3"
                                          class="input"
                                          type="text"
                                          maxlength="3"
                                          name="currency-country-alpha-3"
                                          required>
                                  </div>
                              </div>
                              <!-- Submitt -->
                              <p class="control">
                                  <button class="button is-primary">
                                      <span v-if="submitting_form">
                                          <b-icon icon="circle-notch" custom-class="fa-spin" size="is-small" />
                                          &nbsp;
                                          {{translations.core.shared.view_btn_saving}}
                                      </span>
                                      <span v-else>
                                          <b-icon icon="save" size="is-small" />
                                          &nbsp;
                                          {{translations.core.shared.view_btn_save}}
                                      </span>
                                  </button>
                              </p>
                        </fieldset>
                    </form>
                </b-tab-item>
                <b-tab-item :label="translations.core.account.currencies.view_tab_title_exchange_rates">
                </b-tab-item>
            </b-tabs>
        </div>
    </div>
</template>
