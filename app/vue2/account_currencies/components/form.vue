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
                        exchange_rates: I18n.t("core.account/currency/exchange_rates"),
                    }
                }
            },
            submit: {
                currency: false,
                exchange_rate: false
            },
            pagination: {
                total_pages: 0,
                current_page: 1,
                count_total: 0,
                count_results: 0,
            },
            pagination_config: {
                per_page: 10,
                range_before: 3,
                range_after: 3,
            },
            account_currency: {
                name: null,
                symbol: null,
                country_alpha_3: null,
            },
            new_exchange_rate: {
                valid_from: null,
                valid_to: null,
                exchange_rate: 1
            },
            exchange_rates: [],
            loading: {
                exchange_rates: false
            }
        }
    },

    mounted() {
        this.setAccountCurrency()
        this.getExchangeRates()
    },

    methods: {
        setAccountCurrency(){
            this.account_currency_id = this.$route.params.id
            this.account_currency = this.data.account_currency
        },

        getExchangeRates(){
            if(! this.account_currency_id){
                return
            }
            
            let params = {
                perPage: this.pagination_config.per_page,
                page: this.pagination.current_page,
            }
            let url = this.url.admin(
                'account/currencies/:currency_id/exchange_rates', 
                {currency_id: this.account_currency_id}
            ).paginate(
                this.pagination.current_page, this.pagination_config.per_page
            )
            this.loading.exchange_rates = true

            this.http.get(url, params).then(result => {
                if (result.successful) {
                    this.exchange_rates = this.parseExchangeRates(result.data.records)
                    this.pagination = result.data.pagination
                } else {
                    return this.msg.error(result.error.message)
                }
            }).catch(error => {
                console.log(error)
            }).finally(() => {
                this.loading.exchange_rates = false
            })
        },

        parseExchangeRates(exchange_rates){
            exchange_rates.forEach((exchange_rate)=>{
                exchange_rate.valid_from_new = exchange_rate.valid_from
                exchange_rate.valid_to_new = exchange_rate.valid_to
                exchange_rate.exchange_rate_new = exchange_rate.exchange_rate
            })

            return exchange_rates
        },

        submitCurrency(event){
            if (event) { event.preventDefault() }

            if (this.account_currency.id) {
                this.putCurrency()
            } else {
                this.postCurrency()
            }
        },
        
        postExchangeRate(event){
            if(event){
                event.preventDefault()    
            }

            let url = this.url.admin('account/currencies/:currency_id/exchange_rates', {currency_id: this.account_currency_id})
            let data = {
                currency_exchange_rate: this.new_exchange_rate
            }

            this.submit.exchange_rate = true 

            this.http.post(url, data).then(result => {
                if (result.successful) {
                    this.clearExchangeRate()
                    this.getExchangeRates()
                    this.msg.success(this.translations.core.account.exchange_rates.messages_success_exchange_rate_created)
                }else{
                    this.msg.error(result.error.message)
                }
            }).catch(error => {
                console.log(error)
            }).finally(()=>{
                this.submit.exchange_rate = false 
            })
        },
        
        putExchangeRate(exchange_rate){
            if((! exchange_rate.valid_to_new) || (!exchange_rate.exchange_rate_new)){
                this.msg.warn(this.translations.core.account.exchange_rates.messages_warning_required_fields_empty)
                return
            }
            
            let url = this.url.admin(
                'account/currencies/:currency_id/exchange_rates/:id',
                {currency_id: this.account_currency_id, id: exchange_rate.id}
            )
            let data = {
                currency_exchange_rate: {
                    valid_from: exchange_rate.valid_from_new,
                    valid_to: exchange_rate.valid_to_new,
                    exchange_rate: exchange_rate.exchange_rate_new
                }
            }
            this.$set(exchange_rate, 'submitting', true)

            this.http.put(url, data).then(result => {
                if (result.successful) {
                    this.$set(exchange_rate, 'editing', false)
                    for(let key in exchange_rate){
                        if(result.data[key]){
                            this.$set(exchange_rate, key, result.data[key])
                        }
                    }

                    this.msg.success(this.translations.core.account.exchange_rates.messages_success_exchange_rate_updated)
                }else{
                    this.msg.error(result.error.message)
                }
            }).catch(error => {
                console.log(error)
            }).finally(()=>{
                this.$set(exchange_rate, 'submitting', false)
            })
        },

        clearExchangeRate(){
            this.new_exchange_rate = {
                valid_from: null,
                valid_to: null,
                exchange_rate: 1
            }
        },

        postCurrency() {
            this.submit.currency = true 
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

                this.submit.currency = false 
            }).catch(error => {
                console.log(error)
            })
        },

        putCurrency() {
            this.submit.currency = true
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
                this.submit.currency = false
            })

        },

        confirmExchangeRateDeletion(exchange_rate){
            this.$buefy.dialog.confirm({
                title: this.translations.core.account.exchange_rates.view_text_confirm_deletion_title,
                message: this.translations.core.account.exchange_rates.view_text_confirm_deletion_body,
                confirmText: this.translations.core.shared.view_btn_delete,
                cancelText: this.translations.core.shared.view_btn_cancel,
                type: 'is-danger',
                hasIcon: true,
                onConfirm: () => {
                    this.deleteExchangeRate(exchange_rate)
                }
            })
        },

        deleteExchangeRate(exchange_rate){

            let url = this.url.admin(
                'account/currencies/:currency_id/exchange_rates/:id',
                {currency_id: this.account_currency_id, id: exchange_rate.id}
            )
            this.$set(exchange_rate, 'submitting', true)

            this.http.delete(url).then(result => {
                if (result.successful) {
                    this.getExchangeRates()
                    this.msg.success(this.translations.core.account.exchange_rates.messages_success_exchange_rate_deleted)
                }else{
                    this.msg.error(result.error.message)
                }
            }).catch(error => {
                console.log(error)
            }).finally(()=>{
                this.$set(exchange_rate, 'submitting', true)
            })
        },

        toggleExchangeRateEditForm(exchange_rate){
            this.$set(exchange_rate, 'editing', ! exchange_rate.editing)
        },

        deleteCurrency() {
            let url = this.url.admin('account/currencies/:id', {id: this.account_currency_id})
            this.submit.currency = true 

            this.http.delete(url).then(result => {
                if (result.successful) {
                    this.msg.success(this.translations.core.account.currencies.messages_success_currency_deleted)
                    this.$router.push('/')
                }else{
                    this.msg.error(result.error.message)
                }
            }).catch(error => {
                console.log(error)
            }).finally(()=>{
                this.submit.currency = false 
            })
        }
    },

    watch: {
        'pagination.current_page'(){
            this.getExchangeRates()
        },

        'pagination.per_page'(){
            this.getExchangeRates()
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
                        <fieldset :disabled="submit.currency">
                            <div class="columns is-multiline">
                                <div class="column is-5">
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
                                </div>
                                <div class="column is-4">
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
                                </div>
                                <div class="column is-3">
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
                                </div>
                                <div class="column is-12">
                                    <!-- Submit -->
                                    <b-button expanded type="is-primary" native-type="submit">
                                        <span v-if="submit.currency">
                                            <b-icon icon="circle-notch" custom-class="fa-spin" size="is-small" />
                                            &nbsp;
                                            {{translations.core.shared.view_btn_saving}}
                                        </span>
                                        <span v-else>
                                            <b-icon icon="save" size="is-small" />
                                            &nbsp;
                                            {{translations.core.shared.view_btn_save}}
                                        </span>
                                    </b-button>
                                </div>
                            </div>
                        </fieldset>
                    </form>
                </b-tab-item>
                <b-tab-item :label="translations.core.account.currencies.view_tab_title_exchange_rates" v-if="viewType != 'new'">
                    <form @submit.prevent="postExchangeRate">
                        <fieldset :disabled="submit.exchange_rate">
                            <div class="columns is-multiline">
                                <div class="column is-4">
                                    <!-- Valid From -->
                                    <div class="field">
                                        <label class="label">{{ translations.core.account.exchange_rates.column_valid_from }}
                                        </label>
                                        <div class="control">
                                            <vc-date-picker
                                                v-model="new_exchange_rate.valid_from"
                                                :locale="date.vcDatepickerConfig()"
                                                :popover="{ visibility: 'focus' }"
                                                mode="dateTime"
                                            >
                                                <template v-slot="{ inputValue, inputEvents }">
                                                    <input
                                                        class="input is-default"
                                                        v-on="inputEvents"
                                                        :value="inputValue"
                                                        :placeholder="translations.core.shared.text_select_date"
                                                    />
                                                </template>
                                            </vc-date-picker>
                                        </div>
                                    </div>
                                </div>
                                <div class="column is-4">

                                    <!-- Valid to -->
                                    <div class="field">
                                        <label class="label">{{ translations.core.account.exchange_rates.column_valid_to }}
                                            <sup class="has-text-danger">*</sup>
                                        </label>
                                        <div class="control">
                                            <vc-date-picker
                                                v-model="new_exchange_rate.valid_to"
                                                :locale="date.vcDatepickerConfig()"
                                                :popover="{ visibility: 'focus' }"
                                                mode="dateTime"
                                            >
                                                <template v-slot="{ inputValue, inputEvents }">
                                                    <input
                                                        class="input is-default"
                                                        v-on="inputEvents"
                                                        :value="inputValue"
                                                        :placeholder="translations.core.shared.text_select_date"
                                                    />
                                                </template>
                                            </vc-date-picker>
                                        </div>
                                    </div>
                                </div>
                                <div class="column is-4">

                                    <!-- Exchange rate -->
                                    <div class="field">
                                        <label class="label">{{ translations.core.account.exchange_rates.column_exchange_rate }}
                                            <sup class="has-text-danger">*</sup>
                                        </label>
                                        <div class="control">
                                            <b-input
                                                v-model="new_exchange_rate.exchange_rate"
                                                required
                                                type="number"
                                                min="0"
                                                step="0.01"
                                            >
                                            </b-input>
                                        </div>
                                    </div>
                                </div>
                                <div class="column is-12">
                                    <b-button expanded type="is-primary" native-type="submit">
                                        <span v-if="submit.exchange_rate">
                                            <b-icon icon="circle-notch" custom-class="fa-spin" size="is-small" />
                                            &nbsp;
                                            {{translations.core.shared.view_btn_saving}}
                                        </span>
                                        <span v-else>
                                            <b-icon icon="save" size="is-small" />
                                            &nbsp;
                                            {{translations.core.shared.view_btn_save}}
                                        </span>
                                    </b-button>
                                </div>
                            </div>
                        </fieldset>
                    </form>
                    <hr>
                    <component-data-loading v-if="loading.exchange_rates"> </component-data-loading>
                    <component-data-empty v-if="!loading.exchange_rates && exchange_rates.length === 0"> </component-data-empty>
                        <b-table
                            v-if="!loading.exchange_rates && exchange_rates.length > 0"
                            :data="exchange_rates"
                        >
                            <template v-slot="props">
                                <b-table-column :label="translations.core.account.exchange_rates.column_valid_from" field="valid_from">
                                    
                                    <!-- Valid From -->
                                    <div v-if="props.row.editing" class="field">
                                        <div class="control">
                                            <vc-date-picker
                                                v-model="props.row.valid_from_new"
                                                :locale="date.vcDatepickerConfig()"
                                                :popover="{ visibility: 'focus' }"
                                                mode="dateTime"
                                            >
                                                <template v-slot="{ inputValue, inputEvents }">
                                                    <input
                                                        class="input is-default"
                                                        v-on="inputEvents"
                                                        :value="inputValue"
                                                        :placeholder="translations.core.shared.text_select_date"
                                                    />
                                                </template>
                                            </vc-date-picker>
                                        </div>
                                    </div>
                                    <small v-else>{{ props.row.valid_from_text }}</small>

                                </b-table-column>
                                <b-table-column :label="translations.core.account.exchange_rates.column_valid_to" field="valid_to">

                                    <!-- Valid to -->
                                    <div v-if="props.row.editing" class="field">
                                        <div class="control">

                                            
                                            <vc-date-picker
                                                v-model="props.row.valid_to_new"
                                                :locale="date.vcDatepickerConfig()"
                                                :popover="{ visibility: 'focus' }"
                                                mode="dateTime"
                                            >
                                                <template v-slot="{ inputValue, inputEvents }">
                                                    <input
                                                        class="input is-default"
                                                        v-on="inputEvents"
                                                        :value="inputValue"
                                                        :placeholder="translations.core.shared.text_select_date"
                                                    />
                                                </template>
                                            </vc-date-picker>
                                        </div>
                                    </div>
                                    <small v-else>{{ props.row.valid_to_text }}</small>
                                </b-table-column>
                                <b-table-column :label="translations.core.account.exchange_rates.column_exchange_rate" field="exchange_rate">
                                    
                                    <!-- Exchange rate -->
                                    <div v-if="props.row.editing" class="field">
                                        <div class="control">
                                            <b-input
                                                v-model="props.row.exchange_rate_new"
                                                required
                                                type="number"
                                                min="0"
                                                step="0.01"
                                            >
                                            </b-input>
                                        </div>
                                    </div>
                                    <small v-else>
                                        {{ parseFloat(props.row.exchange_rate).toFixed(2) }}
                                        &nbsp;
                                        <span class="has-text-success" v-if="props.row.active">
                                            ({{translations.core.account.exchange_rates.view_text_active}})
                                        </span>
                                    </small>
                                </b-table-column>
                                <b-table-column field="actions">
                                    <template v-slot:label>
                                        &nbsp;
                                    </template>
                                    <div v-if="props.row.editing" class="has-text-right">
                                        <b-button size="is-small" type="is-primary" :disabled="props.row.submitting" @click="putExchangeRate(props.row)">
                                            <b-icon v-if="props.row.submitting" size="is-small" icon="circle-notch" custom-class="fa-spin"></b-icon>
                                            <b-icon v-else size="is-small" icon="save"></b-icon>
                                            <span>{{translations.core.shared.view_btn_save}}</span>
                                        </b-button>
                                        <b-button :disabled="props.row.submitting" size="is-small" @click="toggleExchangeRateEditForm(props.row)">
                                            <b-icon v-if="props.row.submitting" size="is-small" icon="circle-notch" custom-class="fa-spin"></b-icon>
                                            <b-icon v-else size="is-small" icon="times"></b-icon>
                                            <span>{{translations.core.shared.view_btn_cancel}}</span>
                                        </b-button>
                                    </div>
                                    <div v-else class="has-text-right">
                                        <b-button size="is-small" :disabled="props.row.submitting" @click="toggleExchangeRateEditForm(props.row)">
                                            <b-icon v-if="props.row.submitting" size="is-small" icon="circle-notch" custom-class="fa-spin"></b-icon>
                                            <b-icon v-else size="is-small" icon="edit"></b-icon>
                                            <span>{{translations.core.shared.view_btn_edit}}</span>
                                        </b-button>
                                        <b-button :disabled="props.row.submitting" size="is-small" type="is-danger" @click="confirmExchangeRateDeletion(props.row)">
                                            <b-icon v-if="props.row.submitting" size="is-small" icon="circle-notch" custom-class="fa-spin"></b-icon>
                                            <b-icon v-else size="is-small" icon="trash-alt"></b-icon>
                                            <span>{{translations.core.shared.view_btn_delete}}</span>
                                        </b-button>
                                    </div>
                                </b-table-column>
                            </template>
                        </b-table>
                        <hr>
                        <b-pagination
                            :simple="false"
                            :total="pagination.count_total"
                            :current.sync="pagination.current_page"
                            :range-before="pagination_config.range_before"
                            :range-after="pagination_config.range_after"
                            :per-page="pagination_config.per_page"
                            order="is-centered"
                            icon-prev="chevron-left"
                            icon-next="chevron-right"
                            aria-next-label="Next page"
                            aria-previous-label="Previous page"
                            aria-page-label="Page"
                            aria-current-label="Current page"
                        >
                        </b-pagination>
                </b-tab-item>
                <b-tab-item :label="translations.core.shared.view_tab_title_delete_section" v-if="viewType != 'new'">
                    <span class="has-text-danger">
                        {{translations.core.account.currencies.view_text_delete_confirmation}}
                    </span>
                    <br>
                    <br>
                    <!---------------------------------- START DELETE BUTTON ---------------------------------->
                    <b-field>
                        <b-button type="is-danger" @click="deleteCurrency" expanded class="submit-button" :disabled="submit.currency">
                            <span v-if="submit.currency">
                                <i class="fas fa-spin fa-circle-notch"></i> {{translations.core.shared.view_btn_deleting}}
                            </span>
                            <span v-else>
                                <i class="fas fa-trash-alt"></i> {{translations.core.shared.view_btn_delete}}
                            </span>
                        </b-button>
                    </b-field>
                    <!----------------------------------  END DELETE BUTTON  ---------------------------------->
                </b-tab-item>
            </b-tabs>
        </div>
    </div>
</template>
