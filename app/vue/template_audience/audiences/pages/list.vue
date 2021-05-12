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

export default {
    data() {
        return {
            template_audiences: [],
            loading: false,
            filters_ready: false,
            translations: {
                core: I18n.t('core.shared'),
                main: I18n.t('mailer.audiences')
            },
            filters: {
                search: '',
                per_page: 15,
            },
            sorting: {
                field: 'id',
                order: 'desc'
            },
            pagination: {
                total_count: 0,
                current_page: 1,
                range_before: 3,
                range_after: 3
            },
        }
    },
    mounted() {
        this.setSessionStorageFilters()
        this.getTemplateAudiences()
    },
    methods: {
        setSessionStorageFilters(){
            let stored_filters = this.storage.local('filters')

            if(stored_filters){
                for(let key in stored_filters){
                    this.$set(this.filters, key, stored_filters[key])
                }
            }

            this.filters_ready = true
        },

        getTemplateAudiences() {
            this.loading = true
            let url = this.url.lesli("template/audiences")

            url = url.filters({
                search: this.filters.search,
            }).paginate(
                this.pagination.current_page, this.pagination.per_page
            ).order(
                this.sorting.field,
                this.sorting.order
            )

            this.http.get(url).then(result => {
                this.loading = false

                if (result.successful) {
                    this.template_audiences = result.data.records

                    this.pagination.total_count = result.data.total_count
                }else{
                    this.msg.error(result.error.message)
                }
            }).catch(error => {
                console.log(error)
            })
        },

        searchTemplateAudiences(text) {
            this.pagination.current_page = 1
            this.filters.search= text
            this.getTemplateAudiences()
        },

        sortTemplateAudiences(field, _order){
            if(this.sorting.field == field){
                if(this.sorting.order == 'asc'){
                    this.sorting.order = 'desc'
                }else{
                    this.sorting.order = 'asc'
                }
            }else{
                this.sorting.field = field
                this.sorting.order = 'desc'
            }
            this.getTemplateAudiences()
        },

        deleteTemplateAudience(audience){
            let url = this.url.lesli(`template_audiences/${audience.id}`)

            this.http.delete(url).then(result => {
                if (result.successful) {

                    this.getTemplateAudiences()

                    this.msg.success(this.translations.main.messages_success_deleted)
                }else{
                    this.msg.error(result.error.message)
                }
            }).catch(error => {
                console.log(error)
            })
        },

        gotoTemplateAudience(audience) {
            this.$router.push(`${audience.id}/edit`)
        }
    },
    watch: {
        'pagination.current_page': function(){
            if(! this.loading){
                this.getTemplateAudiences()
            }
        },

        'filters.per_page'(){
            if(this.filters_ready){
                this.getTemplateAudiences()
            }
        }
    }
}
</script>
<template>
    <section class="application-component">
        <component-header :title="translations.main.view_title_main">
            <div class="buttons">
                <router-link class="button" tag="button" to="/new">
                    <b-icon icon="plus" size="is-small" />
                    <span> {{ translations.main.view_btn_new_template_audience }}</span>
                </router-link>
            </div>
        </component-header>

        <component-toolbar
            v-if="filters_ready"
            :search-text="translations.core.view_placeholder_search"
            @search="searchAudiences"
            :initial-value="filters.search"
        >
            <div class="control">
                <div class="select">
                    <select v-model="filters.per_page">
                        <option :value="10">10</option>
                        <option :value="15">15</option>
                        <option :value="30">30</option>
                        <option :value="50">50</option>
                    </select>
                </div>
            </div>
        </component-toolbar>

        <component-data-loading v-if="loading" />
        <component-data-empty v-if="!loading && template_audiences.length == 0" />

        <b-table
            :data="template_audiences"
            :hoverable="true"
            v-if="!loading && template_audiences.length > 0"
            @click="gotoTemplateAudience"
            backend-sorting
            @sort="sortAudiences"
        >
            <template slot-scope="props">
                <b-table-column field="id" :label="translations.main.view_text_id" sortable>
                    <template slot="header" slot-scope="{ column }">
                        {{ column.label }}
                        <span v-if="sorting.field == 'id'">
                            <b-icon v-if="sorting.order == 'asc'" size="is-small" icon="arrow-up" ></b-icon>
                            <b-icon v-else size="is-small" icon="arrow-down"></b-icon>
                        </span>
                    </template>
                    {{props.row.id}}
                </b-table-column>

                <b-table-column field="name" :label="translations.core.view_text_name" sortable>
                    <template slot="header" slot-scope="{ column }">
                        <span>
                            {{ column.label }}
                            <span v-if="sorting.field == 'name'">
                                <b-icon v-if="sorting.order == 'asc'" size="is-small" icon="arrow-up" ></b-icon>
                                <b-icon v-else size="is-small" icon="arrow-down"></b-icon>
                            </span>
                        </span>
                    </template>
                    {{props.row.name}}
                </b-table-column>

                <b-table-column field="created_at" :label="translations.core.view_text_created_at" sortable>
                    <template slot="header" slot-scope="{ column }">
                        <span>
                            {{ column.label }}
                            <span v-if="sorting.field == 'created_at'">
                                <b-icon v-if="sorting.order == 'asc'" size="is-small" icon="arrow-up" ></b-icon>
                                <b-icon v-else size="is-small" icon="arrow-down"></b-icon>
                            </span>
                        </span>
                    </template>
                    {{props.row.created_at_text}}
                </b-table-column>

                <b-table-column :label="translations.core.view_table_header_actions">
                    <span>
                        <b-button type="is-danger" outlined @click.stop="deleteTemplateAudience(props.row)">
                            <b-icon size="is-small" icon="trash-alt" >
                            </b-icon>
                        </b-button>
                    </span>
                </b-table-column>
            </template>
        </b-table>
        <hr>
        <b-pagination
            :simple="false"
            :total="pagination.total_count"
            :current.sync="pagination.current_page"
            :range-before="pagination.range_before"
            :range-after="pagination.range_after"
            :per-page="filters.per_page"
            order="is-centered"
            icon-prev="chevron-left"
            icon-next="chevron-right"
            aria-next-label="Next page"
            aria-previous-label="Previous page"
            aria-page-label="Page"
            aria-current-label="Current page"
        >
        </b-pagination>
    </section>
</template>
