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


// · 
export default {
    props: {
        roleFilters: {
            type: Object,
            default: ()=>{
                return {}
            }
        },

        roleOptions: {
            type: Object,
            default: ()=>{
                return {}
            }
        }
    },

    // @return [Object] Data used by this component's methods
    // @description Returns the data needed for this component to work properly
    // @data_variable main_route [String] the main route to which this component connects to the lesli API
    // @data_variable users [Array] An array of objects, each object represents a 
    //      Users, with the same params as the associated rails model
    data(){
        return {
            main_route: '/administration/users',
            show_form: false,
            user_id: null,
            users: [],
            roles: null,
            loading: false,
            filters_ready: false,
            translations: {
                core: {
                    roles: I18n.t("core.roles"),
                    users: I18n.t("core.users"),
                    shared: I18n.t("core.shared")
                }
            },
            sorting: {
                order: "asc",
                field: "ud.first_name,ud.last_name",
                icon_size: "is-small",
            },
            filters:{
                search: "",
                status: "active",
                role: null
            },
            pagination: {
                current_page: 1,
                per_page: 10,
                range_before: 3,
                range_after: 3,
                users_count: 0
            },
            index_privileges: {
                users: this.abilities.privilege("", "users")
            }
        }
    },

    // @return [void]
    // @description Executes the necessary functions needed to initialize this component
    mounted() {
        this.setSessionStorageFilters()
        this.getUsers()
        this.getRoles()
    },

    methods: {

        setSessionStorageFilters(){
            let stored_filters = this.storage.local("filters")
            
            if (stored_filters) {
                for(let key in stored_filters){
                    this.$set(this.filters, key, stored_filters[key])
                }
            } 

            if (this.$route.query.role) {
                this.filters.role = this.$route.query.role
            }

            this.filters_ready = true
        },

        getUsers() {
            this.storage.local("filters", this.filters)
            
            this.loading = true

            let url = this.url.lesli('administration/users')
            if(! this.filters.role){
                url.query = this.roleFilters
            }else{
                url.query = {role: this.filters.role}
            }
            
            url = url.filters({
                status: this.filters.status,
                view_type: 'index', 
                search: this.filters.search, 
                category: 'user'
            }).paginate(
                this.pagination.current_page, this.pagination.per_page
            ).order(
                this.sorting.field,
                this.sorting.order
            )

            this.http.get(url).then(result => {
                if (result.successful) {
                    this.users = result.data.users.map(user => {
                        user.roles = (user.roles||[]).map(role => {
                            return this.object_utils.translateEnum(this.translations.core.roles, 'column_enum_role', role.name)
                            
                        })

                        user.active_text = user.active ? this.translations.core.shared.text_active : this.translations.core.shared.text_disabled

                        return user
                    })

                    this.pagination.users_count = result.data.users_count
                }else{
                    this.alert(result.error.message,'danger')
                }

                this.loading = false
            }).catch(error => {
                console.log(error)
            }).finally(() => {
                this.loading = false
            })
        },

        getRoles(){
            let url = this.url.lesli('administration/roles/list')

            this.http.get(url).then(result => {
                if (result.successful) {
                    if(this.roleOptions && this.roleOptions.type == 'exclude' && this.roleOptions.role){
                        let excluded_roles = this.roleFilters.role.split(',')

                        this.roles = result.data.filter((role)=>{
                            return ! excluded_roles.includes(role.name)
                        })
                    }else{
                        this.roles = result.data
                    }
                }
            }).catch(error => {
                console.log(error)
            })
        },
        
        showUser(user) {
            this.$router.push(`${user.id}`)
        },

        searchUsers(text){
            this.filters.search = text.trim()
            
            this.pagination.current_page = 1 // clear pagination
            this.getUsers()
        },

        doUserLogout(user) {
            this.http.post(`${this.main_route}/${user.id}/resources/logout`).then(result => {
                if (!result.successful) {
                    this.alert(result.error.message, "danger")
                    return
                }
                this.getUsers()
                this.alert(translations.core.users.messages_success_operation)
            }).catch(error => {
                console.log(error)
            })
        },

        doRevokeAccess(user) {
            this.http.post(`${this.main_route}/${user.id}/resources/lock`).then(result => {
                if (!result.successful) {
                    this.alert(result.error.message, "danger")
                    return
                }
                this.getUsers()
                this.alert(translations.core.users.messages_success_operation)
            }).catch(error => {
                console.log(error)
            })
        },

        sortUsers(field, order){
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
            this.getUsers()
        },

        mailTo(user){
            this.url.go(`mailto: ${user}`)
        }

    },

    watch: {
        'pagination.current_page'(){
            this.getUsers()
        },

        'pagination.per_page'(){
            if(this.filters_ready){
                this.getUsers()
            }
        }
    }
    
}
</script>
<template>
    <section class="application-component">
        <component-header :title="translations.core.users.view_text_title_users">
            <div class="buttons">
                <button class="button" name="btn-reload" @click="getUsers()">
                    <b-icon icon="sync" size="is-small" :custom-class="loading ? 'fa-spin' : ''" />
                    <span> {{ translations.core.shared.view_text_btn_reload }}</span>
                </button>
                <router-link class="button" tag="button" to="/new" v-if="index_privileges.users.grant_create">
                    <b-icon icon="plus" size="is-small" />
                    <span>{{ translations.core.users.view_text_add_user }}</span>
                </router-link>
            </div>
        </component-header>

        <component-toolbar
            v-if="filters_ready"
            :search-text="translations.core.users.view_toolbar_filter_placeholder_search"
            @search="searchUsers"
            :initial-value="filters.search">

            <div class="control" v-if="roles">
                <div class="select">
                    <select
                        v-model="filters.role"
                        @change="getUsers"
                    >
                        <option :value="null"> {{ translations.core.users.view_toolbar_filter_all_roles }} </option>
                        <option v-for="role in roles" :key="role.id" :value="role.name">
                            {{object_utils.translateEnum(translations.core.roles, 'column_enum_role', role.name)}}
                        </option>
                    </select>
                </div>
            </div>

            <div class="control">
                <div class="select">
                    <select
                        name="filter-statuses"
                        v-model="filters.status"
                        @change="getUsers"
                    >
                        <option value="active"> {{ translations.core.users.view_toolbar_filter_placeholder_active_users }} </option>
                        <option value="inactive"> {{ translations.core.users.view_toolbar_filter_placeholder_inactive_users }} </option>
                        <option value=""> {{ translations.core.users.view_toolbar_filter_placeholder_all_users }} </option>
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

        <div class="card">
            <div class="card-content">
                <component-data-loading v-if="loading" />
                <component-data-empty v-if="!loading && users.length == 0" />
                <b-table 
                    v-if="!loading && users.length > 0"
                    :data="users" 
                    :sort-icon-size="sorting.icon_size"
                    :default-sort-direction="sorting.order"
                    :hoverable="true"
                    backend-sorting
                    @click="showUser"
                    @sort="sortUsers"
                >
                    <template slot-scope="props">
                        <b-table-column :label="translations.core.users.view_table_header_name" field="name" sortable>
                            <template slot="header" slot-scope="{ column }">
                                {{ column.label }}
                                <span v-if="sorting.field == 'name'">
                                    <b-icon v-if="sorting.order == 'asc'" size="is-small" icon="arrow-up" ></b-icon>
                                    <b-icon v-else size="is-small" icon="arrow-down"></b-icon>
                                </span>
                            </template>
                            <small> {{ props.row.name }} </small>
                        </b-table-column>
                        
                        <b-table-column :label="translations.core.users.view_table_header_email" field="lower(email)" sortable>
                            <template slot="header" slot-scope="{ column }">
                                {{ column.label }}
                                <span v-if="sorting.field == 'lower(email)'">
                                    <b-icon v-if="sorting.order == 'asc'" size="is-small" icon="arrow-up" ></b-icon>
                                    <b-icon v-else size="is-small" icon="arrow-down"></b-icon>
                                </span>
                            </template>
                            <a v-on:click.stop="mailTo(props.row.email)">  
                                <i class="fas fa-envelope"> </i>
                            </a>
                            &nbsp;
                            {{ props.row.email }}
                        </b-table-column>

                        <b-table-column :label="translations.core.users.view_table_header_role">
                            <span>
                                <span v-for="(role, index) in props.row.roles" :key="`role-${props.row.id}-${index}`">
                                    <b-tooltip type="is-white" :label="role">
                                        <b-tag type="is-info">{{ object_utils.extractInitials(role)}}</b-tag>
                                        &nbsp;
                                    </b-tooltip>
                                </span>
                            </span>
                        </b-table-column>

                        <b-table-column :label="translations.core.users.view_table_header_status" field="active" sortable>
                            <template slot="header" slot-scope="{ column }">
                                {{ column.label }}
                                <span v-if="sorting.field == 'active'">
                                    <b-icon v-if="sorting.order == 'asc'" size="is-small" icon="arrow-up" ></b-icon>
                                    <b-icon v-else size="is-small" icon="arrow-down"></b-icon>
                                </span>
                            </template>
                            <small>  
                                <span class="tag is-success" v-if="props.row.active">
                                    {{ translations.core.shared.view_text_active }}
                                </span>
                                <span class="tag is-warning" v-else> 
                                    {{ translations.core.shared.view_text_inactive }}
                                </span>
                            </small>
                        </b-table-column>

                        <b-table-column :label="translations.core.users.view_table_header_last_sign_in">
                            <span class="tag is-success" v-if="props.row.session_active">
                                {{ props.row.last_sign_in_at }}
                            </span>
                            <span class="tag" v-else> 
                                {{ props.row.last_sign_in_at }}
                            </span>
                        </b-table-column>

                        <b-table-column :label="translations.core.users.view_text_last_activity_at">
                            {{ props.row.last_activity_at }}
                        </b-table-column>

                        <b-table-column @click.native.prevent="e=>e.stopPropagation()" :label="translations.core.shared.view_table_header_actions" centered>
                            <b-dropdown aria-role="menu" position="is-bottom-left">
                                <button class="button is-primary" slot="trigger" slot-scope="{ active }">
                                    <span class="icon">
                                        <i v-if="!active" class="fas fa-ellipsis-h fa-1x"></i>
                                        <i v-if="active" class="far fa-circle"></i>
                                    </span>
                                </button>
                                <b-dropdown-item @click="doUserLogout(props.row)" class="has-text-right pr-4">
                                    {{ translations.core.users.view_btn_logout }}
                                    <span class="icon">
                                        <i class="fas fa-sign-out-alt"></i>
                                    </span>
                                </b-dropdown-item>
                                <b-dropdown-item @click="doRevokeAccess(props.row)" class="has-text-right pr-4">
                                    {{ translations.core.users.view_btn_revoke_access }}
                                    <span class="icon">
                                        <i class="fas fa-user-lock"></i>
                                    </span>
                                </b-dropdown-item>
                            </b-dropdown>
                        </b-table-column>
                    </template>
                </b-table>
                <b-pagination
                    v-if="!loading && users.length > 0"
                    :simple="false"
                    :total="pagination.users_count"
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
