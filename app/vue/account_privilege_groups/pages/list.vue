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
            role_groups: [],
            loading: false,
            filters_ready: false,
            translations: {
                core: I18n.t('core.shared'),
                main: I18n.t('core.account/privilege_groups')
            },
            filters: {
                search: '',
                per_page: 10,
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
        this.getRoleGroups()
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

        getRoleGroups() {
            this.loading = true
            let url = this.url.admin("account/privilege_groups")

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
                    this.role_groups = result.data.records

                    this.pagination.total_count = result.data.total_count
                }else{
                    this.msg.error(result.error.message)
                }
            }).catch(error => {
                console.log(error)
            })
        },

        searchRoleGroups(text) {
            this.pagination.current_page = 1
            this.filters.search= text
            this.getRoleGroups()
        },

        sortRoleGroups(field, _order){
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
            this.getRoleGroups()
        },

        deleteRoleGroup(role_group){
            let url = this.url.admin(`account/privilege_groups/:id`, { id: role_group.id })

            this.http.delete(url).then(result => {
                if (result.successful) {

                    this.role_groups = this.role_groups.filter(e => e.id !== role_group.id)

                    this.msg.success(this.translations.main.messages_success_deleted)
                }else{
                    this.msg.error(result.error.message)
                }
            }).catch(error => {
                console.log(error)
            })
        },

        gotoRoleGroup(role_group) {
            this.$router.push(`${role_group.id}`)
        }
    },
    watch: {
        'pagination.current_page': function(){
            if(! this.loading){
                this.getRoleGroups()
            }
        },

        'filters.per_page'(){
            if(this.filters_ready){
                this.getRoleGroups()
            }
        }
    }
}
</script>
<template>
    <section class="application-component">
        <component-header :title="translations.main.view_title_main">
            <div class="buttons">
                <button class="button" @click="getRoleGroups">
                    <b-icon icon="sync" size="is-small" :custom-class="loading ? 'fa-spin' : ''" />
                    <span> {{ translations.core.view_btn_reload }}</span>
                </button>
                <router-link class="button" tag="button" to="/new">
                    <b-icon icon="plus" size="is-small" />
                    <span> {{ translations.main.view_btn_new_privilege_group }}</span>
                </router-link>
            </div>
        </component-header>

        <component-toolbar
            v-if="filters_ready"
            :search-text="translations.core.view_placeholder_search"
            @search="searchRoleGroups"
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
        <component-data-empty v-if="!loading && role_groups.length == 0" />

        <b-table
            :data="role_groups"
            :hoverable="true"
            v-if="!loading && role_groups.length > 0"
            @click="gotoRoleGroup"
            backend-sorting
            @sort="sortRoleGroups"
        >
            <template slot-scope="props">
                <b-table-column field="id" :label="translations.core.view_text_id" sortable>
                    <template slot="header" slot-scope="{ column }">
                        {{ column.label }}
                        <span v-if="sorting.field == 'id'">
                            <b-icon v-if="sorting.order == 'asc'" size="is-small" icon="arrow-up" ></b-icon>
                            <b-icon v-else size="is-small" icon="arrow-down"></b-icon>
                        </span>
                    </template>
                    {{props.row.id}}
                </b-table-column>

                <b-table-column field="template_audience_documents.name" :label="translations.core.view_text_name" sortable>
                    <template slot="header" slot-scope="{ column }">
                        <span>
                            {{ column.label }}
                            <span v-if="sorting.field == 'template_audience_documents.name'">
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

                <b-table-column field="actions_length" :label="translations.main.view_text_actions_length" sortable>
                    <template slot="header" slot-scope="{ column }">
                        <span>
                            {{ column.label }}
                            <span v-if="sorting.field == 'actions_length'">
                                <b-icon v-if="sorting.order == 'asc'" size="is-small" icon="arrow-up" ></b-icon>
                                <b-icon v-else size="is-small" icon="arrow-down"></b-icon>
                            </span>
                        </span>
                    </template>
                    {{props.row.actions_length}}
                </b-table-column>
                
                <b-table-column :label="translations.core.view_table_header_actions">
                    <span>
                        <b-button type="is-danger" outlined @click.stop="deleteRoleGroup(props.row)">
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
