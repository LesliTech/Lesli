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


// · Import components
// · ~·~     ~·~     ~·~     ~·~     ~·~     ~·~     ~·~     ~·~     ~·~     ~·~     ~·~     ~·~


// · component
export default {
    components: {},

    data() {
        return {
            exchange_rates: [],
            loading: true,
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
            translations: {
                core: {
                    shared: I18n.t('core.shared'),
                    account: {
                        exchange_rates: I18n.t("core.account/currency/exchange_rates"),
                    }
                }
            },
            account_currency_id: null
        }
    },

    mounted(){
        this.account_currency_id = this.$route.params.account_currency_id;
        this.getExchangeRates();
        window.translations = this.translations
    },

    methods: {
        getExchangeRates() {
            let url = this.url.admin("account/currencies/:account_currency_id/exchange_rates",
                {
                    account_currency_id: this.account_currency_id
                }
            ).paginate(this.pagination.current_page, this.pagination_config.per_page)

            this.http.get(url).then(result => {
                if (result.successful) {
                    this.exchange_rates = result.data.records;
                    this.pagination = result.data.pagination;
                } else {
                    return this.msg.error(result.error.message);
                }
            }).catch(error => {
                console.log(error)
            }).finally(() => {
                this.loading = false;
            })
        },

        showExchangeRate(object) {
            this.$router.push(`/${this.account_currency_id}/exchange_rates/${object.id}`)
        },
    },

    watch: {
        'pagination.current_page'(){
            this.getCurrencies()
        },

        'pagination.per_page'(){
            this.getCurrencies()
        }
    }
}
</script>
<template>
    <section class="application-component">
        <component-header
            :title="translations.core.account.exchange_rates.view_title_exchange_rates">
            <div class="buttons">
                <button class="button" name="btn-reload" @click="getExchangeRates()">
                    <b-icon icon="sync" size="is-small" :custom-class="loading ? 'fa-spin' : ''" />
                    <span>{{translations.core.shared.view_btn_reload}}</span>
                </button>
                <router-link class="button" name="btn-new" tag="button" :to="'/new'">
                    <b-icon icon="plus" size="is-small" />
                    <span>{{translations.core.account.exchange_rates.view_btn_create}}</span>
                </router-link>
            </div>
        </component-header>

        <component-data-loading v-if="loading"> </component-data-loading>
        <component-data-empty v-if="!loading && exchange_rates.length === 0"> </component-data-empty>
        <div class="card" v-if="exchange_rates.length > 0">
            <div class="card-content">
                <b-table
                    :data="exchange_rates"
                    :hoverable="true"
                    v-if="!loading && exchange_rates.length > 0"
                    @click="showExchangeRate"
                >
                    <template v-slot="props">
                        <b-table-column :label="translations.core.account.exchange_rates.column_exchange_rate" field="lower(exchange_rate)">
                            <small>{{ props.row.exchange_rate }}</small>
                        </b-table-column>
                        <b-table-column :label="translations.core.account.exchange_rates.column_valid_from" field="lower(valid_from_string)">
                            <small>{{ props.row.valid_from_string }}</small>
                        </b-table-column>
                        <b-table-column :label="translations.core.account.exchange_rates.column_valid_to" field="lower(valid_to_string)">
                            <small>{{ props.row.valid_to_string }}</small>
                        </b-table-column>
                    </template>
                </b-table>
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
            </div>
        </div>
    </section>
</template>
