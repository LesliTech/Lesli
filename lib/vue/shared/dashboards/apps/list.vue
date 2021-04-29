<script>
export default {
    props: {
        cloudEngine: {
            type: String,
            required: true
        },

        engineNamespace: {
            type: String,
            required: true
        }
    },

    // @return [Object] Data used by this component's methods
    // @description Returns the data needed for this component to work properly
    // @data_variable main_route [String] the main route to which this component connects to the lesli API
    // @data_variable dashboards [Array] An array of objects, each object represents a
    //      Dashboard, with the same params as the associated rails model
    data(){
        return {
            main_route: `/${this.engineNamespace}/dashboards`,
            translations: {
                main: I18n.t(`${this.cloudEngine.toLowerCase()}.dashboards`),
                dashboards: I18n.t('core.dashboards'),
                core: I18n.t('core.shared')
            },
            dashboards: [],
            loading: false,
            pagination: {
                dashboards_count: 0,
                current_page: 1,
                range_before: 3,
                range_after: 3
            },
            filters: {
                query: '',
                per_page: 15
            },
            filters_ready: false,
            sorting: {
                field: 'name',
                order: 'asc'
            },
            index_abilities: this.abilities.privilege('dashboards', `${this.object_utils.toSnakeCase(this.cloudEngine)}`)
        }
    },

    // @return [void]
    // @description Executes the necessary functions needed to initialize this component
    mounted() {
        this.setSessionStorageFilters()
        this.getDashboards()
    },

    methods: {

        // @return [void]
        // @description Connects to the backend using HTTP and retrieves a list of Dashboard associated to
        //      the current user's account. If the HTTP request fails, an error message is shown
        // @example
        //      console.log(this.dashboards) // will display null
        //      this.getDashboards()
        //      console.log(this.dashboards) // will display an array of objects, each representing a Dashboard.

        setSessionStorageFilters(){
            let stored_filters = this.storage.local("filters")

            if(stored_filters){
                for(let key in stored_filters){
                    this.$set(this.filters, key, stored_filters[key])
                }
            }

            // Query filters will always override stored filters
            if(this.$route.query.status){
                this.$set(this.filters, 'statuses', [{value: this.$route.query.status}])
            }

            this.$nextTick(()=>{
                this.filters_ready = true
            })
        },

        getDashboards(reset_current_page = true) {
            this.loading = true
            this.storage.local("filters", this.filters)
            let url = `${this.main_route}/list.json`

            let data = {
                filters: {
                    statuses: this.filters.statuses,
                    search_type: this.filters.search_type,
                    include: this.filters.include,
                    query: this.filters.query
                },
                order: this.sorting.order,
                orderColumn: this.sorting.field,
                perPage: this.filters.per_page
            }
            if(reset_current_page){
                this.pagination.current_page = 1
                data.filters.get_total_count = true
            }else{
                data.filters.get_total_count = false
            }
            data.page = this.pagination.current_page

            this.http.post(url, data).then(result => {
                this.loading = false
                if (result.successful) {
                    this.dashboards = result.data.dashboards

                    if(result.data.total_count != null){
                        this.pagination.dashboards_count = result.data.total_count
                    }
                }else{
                    this.msg.error(result.error.message)
                }
            }).catch(error => {
                console.log(error)
            })
        },

        // @return [void]
        // @param dashboard [Object] The object representation of the selected Dashboard
        // @description Redirects the router to show the selected Dashboard
        // @example
        //      this.showDashboard(this.dashboards[1])
        //      // Asume the id of the Dashboard is 4
        //      // The user will be redirected to the url /crm/dashboards/4
        showDashboard(dashboard) {
            this.$router.push(`/${dashboard.id}`)
        },

        reloadDashboards(){
            this.dashboards = []
            this.getDashboards(false)
        },

        searchDashboards(text) {
            this.filters.query = text
            this.getDashboards()
        },

        sortDashboards(field, order){
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
            this.getDashboards()
        }
    },

    watch: {
        'pagination.current_page': function(){
            if(! this.loading){
                this.getDashboards(false)
            }
        },

        'filters.per_page'(){
            if(this.filters_ready){
                this.getDashboards(true)
            }
        },
    }
}
</script>
<template>
    <section class="application-component">
        <component-header
            :title="translations.dashboards.view_title_main">
            <div class="buttons">
                <button class="button" @click="reloadDashboards()">
                    <b-icon icon="sync" size="is-small" :custom-class="loading ? 'fa-spin' : ''" />
                    <span> {{ translations.core.view_text_btn_reload }}</span>
                </button>
                <router-link class="button" tag="button" to="/new" v-if="index_abilities.grant_create">
                    <b-icon icon="plus" size="is-small" />
                    <span>{{ translations.dashboards.view_btn_create }}</span>
                </router-link>
            </div>
        </component-header>

        <component-toolbar
            v-if="filters_ready"
            :search-text="translations.dashboards.view_placeholder_filter_text"
            @search="searchDashboards"
            :initial-value="filters.query"
        >
        </component-toolbar>

        <div class="card">
            <div class="card-content">

                <component-data-loading v-if="loading" />
                <component-data-empty v-if="!loading && dashboards.length == 0" />

                <b-table
                    :data="dashboards"
                    @click="showDashboard"
                    :hoverable="true"
                    v-if="!loading && dashboards.length > 0"
                    @sort="sortDashboards"
                    backend-sorting
                >
                    <template slot-scope="props">
                        <b-table-column field="name" :label="translations.dashboards.column_name" sortable>
                            <template slot="header" slot-scope="{ column }">
                                {{ column.label }}
                                <span v-if="sorting.field == 'name'">
                                    <b-icon v-if="sorting.order == 'asc'" size="is-small" icon="arrow-up" ></b-icon>
                                    <b-icon v-else size="is-small" icon="arrow-down"></b-icon>
                                </span>
                            </template>
                            {{ props.row.name }}
                        </b-table-column>

                        <b-table-column field="default" :label="translations.dashboards.column_default" sortable>
                            <template slot="header" slot-scope="{ column }">
                                <span>
                                    {{ column.label }}
                                    <span v-if="sorting.field == 'default'">
                                        <b-icon v-if="sorting.order == 'asc'" size="is-small" icon="arrow-up" ></b-icon>
                                        <b-icon v-else size="is-small" icon="arrow-down"></b-icon>
                                    </span>
                                </span>
                            </template>
                            <span v-if="props.row.default">
                                <b>{{translations.core.view_text_yes}}</b>
                            </span>
                            <span v-else>
                                {{translations.core.view_text_no}}
                            </span>
                        </b-table-column>

                        <b-table-column field="id" :label="translations.dashboards.column_created_at" sortable>
                            <template slot="header" slot-scope="{ column }">
                                <span>
                                    {{ column.label }}
                                    <span v-if="sorting.field == 'id'">
                                        <b-icon v-if="sorting.order == 'asc'" size="is-small" icon="arrow-up" ></b-icon>
                                        <b-icon v-else size="is-small" icon="arrow-down"></b-icon>
                                    </span>
                                </span>
                            </template>
                            {{ props.row.created_at }}
                        </b-table-column>
                    </template>
                </b-table>
                <hr>
                <b-pagination
                    :simple="false"
                    :total="pagination.dashboards_count"
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
            </div>
        </div>
    </section>
</template>
