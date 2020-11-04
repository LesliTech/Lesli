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
            loading: false,
            filters_ready: false,
            translations: {
                core: {
                    users: I18n.t("core.users"),
                    shared: I18n.t("core.shared")
                }
            },
            filters:{
                search: ''
            },
            sort: {
                icon_size: 'is-small',
                direction: 'desc'
            },
            pagination: {
                current_page: 1,
                per_page: 10,
                range_before: 3,
                range_after: 3
            },
            privileges: {
                users: this.abilities.privileges()
            }
        }
    },

    // @return [void]
    // @description Executes the necessary functions needed to initialize this component
    mounted() {
        this.setSessionStorageFilters()
        this.reloadUsers()
    },

    methods: {

        setSessionStorageFilters(){
            let stored_filters = this.storage.local("filters")
            
            if (stored_filters) {
                for(let key in stored_filters){
                    this.$set(this.filters, key, stored_filters[key])
                }
            } 

            this.filters_ready = true
        },

        // @return [void]
        // @description Connects to the backend using HTTP and retrieves a list of Users associated to
        //      the current user's account. If the HTTP request fails, an error message is shown
        // @example
        //      console.log(this.users) // will display null
        //      this.getUsers()
        //      console.log(this.users) // will display an array of objects, each representing a Users.
        getUsers() {
            let url = `${this.main_route}.json?role=kop,callcenter,guest&type=exclude&status=all`
            this.http.get(url).then(result => {
                if (result.successful) {
                    this.users = result.data.map(e => {
                        e.role = this.object_utils.translateEnum(this.translations.core.users, 'enum_role', e.role)
                        e.active_text = e.active ? this.translations.core.shared.text_active : this.translations.core.shared.text_disabled
                        return e
                    })
                }else{
                    this.alert(result.error.message,'danger')
                }
            }).catch(error => {
                console.log(error)
            }).finally(() => {
                this.loading = false
            })
        },
        
        // @return [void]
        // @param users [Object] The object representation of the selected Users
        // @description Redirects the router to show the selected Users
        // @example
        //      this.showUsers(this.users[1])
        //      // Asume the id of the Users is 4
        //      // The user will be redirected to the url /users/4
        showUser(user) {
            this.$router.push(`${user.id}`)
        },

        reloadUsers() {
            this.loading = true
            this.getUsers()
        },

        searchUsers(text){
            this.filters.search = text
        },

        doUserLogout(user) {
            this.http.post(`${this.main_route}/${user.id}/resources/logout`).then(result => {
                if (!result.successful) {
                    this.alert(result.error.message, "danger")
                    return
                }
                this.getUsers()
                this.alert("Operation successful")
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
                this.alert("Operation successful")
            }).catch(error => {
                console.log(error)
            })
        }

    },

    computed: {
        filteredUsers(){
            this.storage.local("filters", this.filters)

            let search_field = this.filters.search.toLowerCase().trim()
            this.pagination.current_page = 1
            if (search_field.length > 0) {
                return this.users.filter((user)=>{
                    return ( 
                        user.role.toLowerCase().includes(search_field) ||  
                        user.name.toLowerCase().includes(search_field) || 
                        user.email.toLowerCase().includes(search_field) || 
                        user.id.toString().toLowerCase().includes(search_field) ||
                        user.active_text.toString().toLowerCase().includes(search_field)
                    )  
                })
            } else {
                return this.users
            }
        }
    },

    
}
</script>
<template>
    <section class="application-component">
        <component-header :title="translations.core.users.view_text_title_users">
            <div class="buttons">
                <button class="button" @click="reloadUsers()">
                    <b-icon icon="sync" size="is-small" :custom-class="loading ? 'fa-spin' : ''" />
                    <span> {{ translations.core.shared.view_text_btn_reload }}</span>
                </button>
                <router-link class="button" tag="button" to="/new" v-if="privileges.users.grant_create">
                    <b-icon icon="plus" size="is-small" />
                    <span>{{ translations.core.users.view_text_add_user }}</span>
                </router-link>
            </div>
        </component-header>

        <component-toolbar
            v-if="filters_ready"
            :search-text="translations.core.shared.view_placeholder_search"
            @search="searchUsers"
            :initial-value="filters.search">
        </component-toolbar>

        <div class="card">
            <div class="card-content">
                <component-data-loading v-if="loading" />
                <component-data-empty v-if="!loading && users.length == 0" />
                <b-table 
                    v-if="!loading && users.length > 0"
                    :data="filteredUsers" 
                    @click="showUser"
                    :sort-icon-size="sort.icon_size"
                    :default-sort-direction="sort.direction"
                    :hoverable="true"
                    :paginated="true"
                    :per-page="pagination.per_page"
                    :current-page.sync="pagination.current_page"
                    :pagination-simple="false"
                    pagination-position="bottom">
                    <template slot-scope="props">
                        <!--
                        <b-table-column :label="translations.core.users.view_table_header_id" sortable field="id">
                            {{ props.row.id }}
                        </b-table-column>
                        -->
                        <b-table-column :label="translations.core.users.view_table_header_name" sortable field="name">
                            {{ props.row.name }}
                        </b-table-column>
                        <b-table-column :label="translations.core.users.view_table_header_email" sortable field="email">
                            <a :href="`mailto: ${props.row.email}`"> {{ props.row.email }} </a>
                        </b-table-column>
                        <b-table-column :label="translations.core.users.view_table_header_role" sortable field="role">
                            {{ props.row.role }}
                        </b-table-column>
                        <b-table-column :label="translations.core.users.view_table_header_status" sortable field="active">
                            <span class="tag is-success" v-if="props.row.active">
                                {{ translations.core.shared.view_text_active }}
                            </span>
                            <span class="tag is-warning" v-else> 
                                {{ translations.core.shared.view_text_inactive }}
                            </span>
                        </b-table-column>
                        <b-table-column :label="translations.core.users.view_table_header_last_sign_in" sortable field="last_sign_in_at">
                            <span class="tag is-success" v-if="props.row.session_active">
                                {{ props.row.last_sign_in_at }}
                            </span>
                            <span class="tag" v-else> 
                                {{ props.row.last_sign_in_at }}
                            </span>
                        </b-table-column>
                        <b-table-column :label="translations.core.users.view_text_last_activity_at" sortable field="last_activity_at">
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
                                    logout
                                    <span class="icon">
                                        <i class="fas fa-sign-out-alt"></i>
                                    </span>
                                </b-dropdown-item>
                                <b-dropdown-item @click="doRevokeAccess(props.row)" class="has-text-right pr-4">
                                    revoke access
                                    <span class="icon">
                                        <i class="fas fa-user-lock"></i>
                                    </span>
                                </b-dropdown-item>
                            </b-dropdown>
                        </b-table-column>
                    </template>
                </b-table>
                <hr>
            </div>
        </div>
    </section>
</template>
