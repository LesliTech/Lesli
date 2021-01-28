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
    props: {
        role: {
            type: Object,
            required: true
        }
    },

    data(){
        return {
            translations: {
                shared: I18n.t('deutscheleibrenten.shared'),
                users: I18n.t('deutscheleibrenten.users'),
                roles: I18n.t('core.roles'),
                role_activities: I18n.t('core.role/activities')
            },
            sorting: {
                order: 'desc',
                field: 'created_at'
            },
            pagination: {
                total_count: 0,
                current_page: 1,
                range_before: 3,
                range_after: 3,
                per_page: 10
            },
            filters: {
                text: '',
                text_category: ''
            },
            main_route: '/administration/roles',
            filters_ready: false,
            loading: false,
            role_activities: [],
            options: []
        }
    },

    mounted(){
        this.setSessionStorageFilters()
        this.getOptions()
        this.getRoleActivities()
    },

    methods: {
        setSessionStorageFilters(){
            let stored_filters = this.storage.local('filters')

            if (stored_filters) {
                for(let key in stored_filters){
                    this.$set(this.filters, key, stored_filters[key])
                }
            }
            
            this.$nextTick(()=>{
                this.filters_ready = true
            })
        },
        
        getOptions(){
            this.http.get(`${this.main_route}/activities/options.json`).then(result => {
                if (result.successful) {
                    this.options = result.data
                } else {
                    this.alert(result.error.message,'danger')
                }
            }).catch(error => {
                console.log(error)
            })  
        },

        getRoleActivities(){
            this.loading = true

            let url = `${this.main_route}/${this.role.id}/activities.json?` // url
            url += `page=${this.pagination.current_page}&perPage=${this.pagination.per_page}` // pagination
            url += `&order=${this.sorting.order}&orderColumn=${this.sorting.field}` // sorting
            url += `&filters[text]=${this.filters.text}&filters[text_category]=${this.filters.text_category}` // filters

            this.storage.local('filters', this.filters)

            this.http.get(url).then(result => {
                if (result.successful) {
                    this.role_activities = result.data.activities // list of activities

                    this.pagination.total_count = result.data.activities_count // total count
                } else {
                    this.alert(result.error.message,'danger')
                }
                
                this.loading = false
            }).catch(error => {
                console.log(error)
            })     
        },

        reloadactivities(){
            this.loading = true
            this.getRoleActivities()
        },

        sortActivities(field, order){
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
            this.getRoleActivities()
        },

        searchRoleActivities(text) {
            this.filters.text = text.trim()
            this.getRoleActivities()
        },
    },

    watch: {
        'pagination.current_page'(){
            this.getRoleActivities()
        },
        
        'pagination.per_page'(){
            if(this.filters_ready){
                this.getRoleActivities()
            }
        }
    }
}
</script>
<template>
    <section>
        <component-header
            :buttons="false"
            :title="`${translations.users[`column_enum_role_${(role.name || '').toLowerCase()}`] || role.name} [${translations.shared.text_log}]`"
        >
            <div class="buttons">
                <router-link class="button" to="/">
                    <b-icon icon="list" size="is-small" />
                    <span>{{ translations.shared.btn_list }}</span>
                </router-link>
                <router-link class="button" :to="this.role.id + '/edit'">
                    <b-icon icon="edit" size="is-small" />
                    <span>{{ translations.shared.btn_edit }}</span>
                </router-link>
                <b-button class="button" @click.stop="url.go(`/crm/roles/${role.id}`)">
                    <b-icon icon="eye" size="is-small" />
                    <span>{{ translations.shared.btn_show }}</span>
                </b-button>
            </div>
        </component-header>
        
        <component-toolbar
            v-if="filters_ready"
            :search-text="translations.role_activities.view_toolbar_filter_placeholder_text"
            @search="searchRoleActivities"
            :initial-value="filters.text"
        >

            <div class="control">
                <div class="select"> 
                    <select
                        name="filter-categories"
                        v-model="filters.text_category"
                        @change="getRoleActivities"
                    >
                        <option value=""> {{ translations.roles.view_toolbar_filter_all_categories }} </option>
                        <option v-for="category in options.categories" v-bind:key="category.value" v-bind:value="category.value">
                            {{ object_utils.translateEnum(translations.roles, 'column_enum_category', category.text) }}
                        </option>
                    </select>
                </div>
            </div>

            <div class="control">
                <div class="select">
                    <select
                        name="filter-per-page" 
                        v-model="pagination.per_page"
                    >
                        <option :value="10">10</option>
                        <option :value="15">15</option>
                        <option :value="30">30</option>
                        <option :value="50">50</option>
                    </select>
                </div>
            </div>
        </component-toolbar>

        <component-data-loading v-if="loading" />
        <component-data-empty v-if="!loading && role_activities.length == 0" />

        <div class="card" v-if="role_activities.length > 0">
            <div class="card-content">
                <b-table 
                    :data="role_activities" 
                    :hoverable="true"
                    v-if="!loading && role_activities.length > 0"
                    backend-sorting
                    @sort="sortActivities"
                >
                    <template v-slot="props">

                        <b-table-column :label="translations.role_activities.column_created_at" field="created_at" sortable>
                            <template slot="header" slot-scope="{ column }">
                                {{ column.label }}
                                <span v-if="sorting.field == 'created_at'">
                                    <b-icon v-if="sorting.order == 'asc'" size="is-small" icon="arrow-up" ></b-icon>
                                    <b-icon v-else size="is-small" icon="arrow-down"></b-icon>
                                </span>
                            </template>
                            <small>{{ props.row.created_at_raw }}</small>
                        </b-table-column>  

                        <b-table-column :label="translations.role_activities.column_users_id"  field="user_creator_name" sortable>
                            <template slot="header" slot-scope="{ column }">
                                {{ column.label }}
                                <span v-if="sorting.field == 'user_creator_name'">
                                    <b-icon v-if="sorting.order == 'asc'" size="is-small" icon="arrow-up" ></b-icon>
                                    <b-icon v-else size="is-small" icon="arrow-down"></b-icon>
                                </span>
                            </template>
                            <small>{{ props.row.user_creator_name }}</small>
                        </b-table-column>     

                        <b-table-column :label="translations.role_activities.column_category"  field="category" sortable>
                            <template slot="header" slot-scope="{ column }">
                                {{ column.label }}
                                <span v-if="sorting.field == 'category'">
                                    <b-icon v-if="sorting.order == 'asc'" size="is-small" icon="arrow-up" ></b-icon>
                                    <b-icon v-else size="is-small" icon="arrow-down"></b-icon>
                                </span>
                            </template>
                            <small>{{ props.row.category}} </small>
                        </b-table-column>  

                        <b-table-column :label="translations.role_activities.column_description"  field="description" sortable>
                            <template slot="header" slot-scope="{ column }">
                                {{ column.label }}
                                <span v-if="sorting.field == 'description'">
                                    <b-icon v-if="sorting.order == 'asc'" size="is-small" icon="arrow-up" ></b-icon>
                                    <b-icon v-else size="is-small" icon="arrow-down"></b-icon>
                                </span>
                            </template>
                            <small>{{ props.row.description}} </small>
                        </b-table-column>        

                        <b-table-column :label="translations.role_activities.column_field"  field="field_name" sortable>
                            <template slot="header" slot-scope="{ column }">
                                {{ column.label }}
                                <span v-if="sorting.field == 'field_name'">
                                    <b-icon v-if="sorting.order == 'asc'" size="is-small" icon="arrow-up" ></b-icon>
                                    <b-icon v-else size="is-small" icon="arrow-down"></b-icon>
                                </span>
                            </template>
                            <small>{{ props.row.field_name }}</small>
                        </b-table-column> 

                        <b-table-column :label="translations.role_activities.column_value_from"  field="value_from" sortable>
                            <template slot="header" slot-scope="{ column }">
                                {{ column.label }}
                                <span v-if="sorting.field == 'value_from'">
                                    <b-icon v-if="sorting.order == 'asc'" size="is-small" icon="arrow-up" ></b-icon>
                                    <b-icon v-else size="is-small" icon="arrow-down"></b-icon>
                                </span>
                            </template>
                            <small>
                                {{ props.row.value_from }}
                            </small>
                        </b-table-column>     

                        <b-table-column :label="translations.role_activities.column_value_to"  field="value_to" sortable>
                            <template slot="header" slot-scope="{ column }">
                                {{ column.label }}
                                <span v-if="sorting.field == 'value_to'">
                                    <b-icon v-if="sorting.order == 'asc'" size="is-small" icon="arrow-up" ></b-icon>
                                    <b-icon v-else size="is-small" icon="arrow-down"></b-icon>
                                </span>
                            </template>
                            <small>
                                {{ props.row.value_to }}
                            </small>
                        </b-table-column>
                    </template>
                </b-table>
                <b-pagination
                    :simple="false"
                    :total="pagination.total_count"
                    :current.sync="pagination.current_page"
                    :range-before="pagination.range_before"
                    :range-after="pagination.range_after"
                    :per-page="pagination.per_page"
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

