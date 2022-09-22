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
            currencies: [],
            loading: false,
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
                        currencies: I18n.t("core.account/currencies"),
                        exchange_rates: I18n.t("core.account/currency/exchange_rates")
                    }
                }
            }
        }
    },

    mounted(){
        this.getCurrencies()
    },

    methods: {
        getCurrencies() {
            let filters = {
                include: "exchange_rates"
            }
            let url = this.url.admin("account/currencies").filters(filters).paginate(
                this.pagination.current_page, this.pagination_config.per_page
            )
            this.loading = true

            this.http.get(url).then(result => {
                if (result.successful) {
                    this.currencies = result.data.records
                    this.pagination = result.data.pagination
                } else {
                    return this.msg.error(result.error.message)
                }
            }).catch(error => {
                console.log(error)
            }).finally(() => {
                this.loading = false
            })
        },

        showObject(object) {
            this.$router.push(`/${object.id}`)
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
            :title="translations.core.account.currencies.view_text_title">
            <div class="buttons">
                <button class="button" name="btn-reload" @click="getCurrencies()">
                    <b-icon icon="sync" size="is-small" :custom-class="loading ? 'fa-spin' : ''" />
                    <span>{{translations.core.shared.view_btn_reload}}</span>
                </button>
                <router-link class="button" name="btn-new" tag="button" :to="'/new'">
                    <b-icon icon="plus" size="is-small" />
                    <span>{{translations.core.account.currencies.view_btn_create}}</span>
                </router-link>
            </div>
        </component-header>

        <div class="card">
            <div class="card-content">
                <component-data-loading v-if="loading"> </component-data-loading>
                <component-data-empty v-if="!loading && currencies.length === 0"> </component-data-empty>
                    <b-table
                        v-if="!loading && currencies.length > 0"
                        :data="currencies"
                        :hoverable="true"
                        @click="showObject"
                    >
                        <template v-slot="props">
                            <b-table-column :label="translations.core.account.currencies.column_name" field="lower(name)">
                                <small>{{ props.row.name }}</small>
                            </b-table-column>
                            <b-table-column :label="translations.core.account.currencies.column_symbol" field="lower(symbol)">
                                <small>{{ props.row.symbol }}</small>
                            </b-table-column>
                            <b-table-column :label="translations.core.account.currencies.column_country_alpha_3" field="lower(country_alpha_3)">
                                <small>{{ props.row.country_alpha_3 }}</small>
                            </b-table-column>
                            <b-table-column :label="translations.core.account.exchange_rates.column_valid_from">
                                <small>{{ props.row.valid_from_text }}</small>
                            </b-table-column>
                            <b-table-column :label="translations.core.account.exchange_rates.column_valid_to">
                                <small>{{ props.row.valid_to_text }}</small>
                            </b-table-column>
                            <b-table-column :label="translations.core.account.exchange_rates.column_exchange_rate">
                                <small>{{ props.row.exchange_rate }}</small>
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
            </div>
        </div>
    </section>
</template>
