<script>
/*

Copyright (c) 2021, all rights reserved.

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
    props: {
        appMountPath: {
            type: String,
            default: ''
        }
    },

    data() {
        return {
            role_descriptors: [],
            loading: false,
            filters_ready: false,
            translations: {
                core: I18n.t('core.shared'),
                role_descriptors: I18n.t('core.role_descriptors')
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
        this.getRoleDescriptors()
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

        getRoleDescriptors() {
            this.loading = true
            let url = this.url.admin("role_descriptors")

            url = url.filters({
                search: this.filters.search,
            }).paginate(
                this.pagination.current_page, this.filters.per_page
            ).order(
                this.sorting.field,
                this.sorting.order
            )

            this.http.get(url).then(result => {
                this.loading = false

                if (result.successful) {
                    this.role_descriptors = result.data.records
                    this.pagination.total_count = result.data.pagination.count_total
                }else{
                    this.msg.error(result.error.message)
                }
            }).catch(error => {
                console.log(error)
            })
        },

        searchRoleDescriptors(text) {
            this.pagination.current_page = 1
            this.filters.search= text
            this.getRoleDescriptors()
        },

        sortRoleDescriptors(field, _order){
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
            this.getRoleDescriptors()
        },

        deleteRoleDescriptor(role_descriptor){
            let url = this.url.admin(`role_descriptors/:id`, { id: role_descriptor.id })

            this.http.delete(url).then(result => {
                if (result.successful) {

                    this.role_descriptors = this.role_descriptors.filter(e => e.id !== role_descriptor.id)

                    this.msg.success(this.translations.role_descriptors.messages_success_deleted)
                }else{
                    this.msg.error(result.error.message)
                }
            }).catch(error => {
                console.log(error)
            })
        },

        gotoRoleDescriptor(role_descriptor) {
            this.$router.push(`${this.appMountPath}/${role_descriptor.id}`)
        },

        confirmRoleDescriptorDeletion(role_descriptor){
            this.$buefy.dialog.confirm({
                title: this.translations.role_descriptors.view_text_confirm_deletion_title,
                message: this.translations.role_descriptors.view_text_delete_confirmation,
                confirmText: this.translations.role_descriptors.view_text_confirm_deletion,
                type: 'is-danger',
                hasIcon: true,
                onConfirm: () => this.deleteRoleDescriptor(role_descriptor)
            })
        }
    },
    watch: {
        'pagination.current_page': function(){
            if(! this.loading){
                this.getRoleDescriptors()
            }
        },

        'filters.per_page'(){
            if(this.filters_ready){
                this.getRoleDescriptors()
            }
        }
    }
}
</script>
<template>
    <section class="application-component">
        <component-header :title="translations.role_descriptors.view_title_main">
            <div class="buttons">
                <button class="button" @click="getRoleDescriptors">
                    <b-icon icon="sync" size="is-small" :custom-class="loading ? 'fa-spin' : ''" />
                    <span> {{ translations.core.view_btn_reload }}</span>
                </button>
                <router-link class="button"  :to="`${appMountPath}/new`">
                    <b-icon icon="plus" size="is-small" />
                    <span> {{ translations.role_descriptors.view_btn_new_role_descriptor }}</span>
                </router-link>
            </div>
        </component-header>

        <component-toolbar
            v-if="filters_ready"
            :search-text="translations.core.view_placeholder_search"
            @search="searchRoleDescriptors"
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

        <div class="card">
            <div class="card-content">
                <component-data-loading v-if="loading" />
                <component-data-empty v-if="!loading && role_descriptors.length == 0" />

                <b-table
                    :data="role_descriptors"
                    :hoverable="true"
                    v-if="!loading && role_descriptors.length > 0"
                    @click="gotoRoleDescriptor"
                    backend-sorting
                    @sort="sortRoleDescriptors"
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
                            {{props.row.created_at_date}}
                        </b-table-column>

                        <b-table-column field="actions_length" :label="translations.role_descriptors.view_text_actions_length" sortable>
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
                                <b-button type="is-danger" outlined @click.stop="confirmRoleDescriptorDeletion(props.row)">
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
            </div>
        </div>
    </section>
</template>
