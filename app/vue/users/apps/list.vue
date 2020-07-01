<script>
/*
Lesli

Copyright (c) 2020, Lesli Technologies, S. A.

All the information provided by this website is protected by laws of Guatemala related 
to industrial property, intellectual property, copyright and relative international laws. 
Lesli Technologies, S. A. is the exclusive owner of all intellectual or industrial property
rights of the code, texts, trade mark, design, pictures and any other information.
Without the written permission of Lesli Technologies, S. A., any replication, modification,
transmission, publication is strictly forbidden.
For more information read the license file including with this software.

Lesli - Your Smart Business Assistant

Powered by https://www.lesli.tech
Building a better future, one line of code at a time.

@contact  <hello@lesli.tech>
@website  <https://lesli.tech>
@license  Propietary - all rights reserved.

// · ~·~     ~·~     ~·~     ~·~     ~·~     ~·~     ~·~     ~·~     ~·~     ~·~     ~·~     ~·~
// · 
*/


// · List of Imported Components
// · ~·~     ~·~     ~·~     ~·~     ~·~     ~·~     ~·~     ~·~     ~·~     ~·~     ~·~     ~·~



// · 
// · ~·~     ~·~     ~·~     ~·~     ~·~     ~·~     ~·~     ~·~     ~·~     ~·~     ~·~     ~·~
export default {

    // @return [Object] Data used by this component's methods
    // @description Returns the data needed for this component to work properly
    // @data_variable main_route [String] the main route to which this component connects to the lesli API
    // @data_variable users [Array] An array of objects, each object represents a 
    //      Users, with the same params as the associated rails model
    data(){
        return {
            main_route: '/users',
            show_form: false,
            user_id: null,
            users: [],
            loading: false,
            filters_ready: false,
            translations: {
                core: {
                    users: I18n.t('core.users'),
                    shared: I18n.t('core.shared')
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
            abilities: {
                users: this.abilities.privilege("users")
            }
        }
    },

    // @return [void]
    // @description Executes the necessary functions needed to initialize this component
    mounted() {
        this.setSessionStorageFilters()
        this.getUsers()
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
            let url = `/users.json?role=kop,callcenter,guest&type=exclude`
            this.loading = true
            this.http.get(url).then(result => {
                this.loading = false
                if (result.successful) {
                    this.users = result.data.map(e => {
                        return {
                            id: e.id,
                            name: (e.first_name + ' ' + e.last_name).trim(),
                            email: e.email,
                            active: e.active,
                            role: this.object_utils.translateEnum(this.translations.core.users, 'enum_role', e.role_name),
                            active_text: e.active ? this.translations.core.shared.text_active : this.translations.core.shared.text_disabled 
                        }
                    })
                }else{
                    this.notification.alert(result.error.message,'danger')
                }
            }).catch(error => {
                console.log(error)
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

        reloadUsers(){
            this.getUsers()
        },

        searchUsers(text){
            this.filters.search = text
        },
    },

    computed: {

        // @return [String] The class that is used to give a spinning animation to the icon (if needed)
        // @description When the user clicks the 'reload' button, it changes the value of the *loading*
        //      data variable. And that is used by this method to change the class of the icon and add it
        //      the spinning animation
        reloadingClass(){
            if(this.loading){
                return 'fa-spin'
            }

            return ''
        },

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
        <component-header 
            :title="translations.core.users.title_users">
            <div class="buttons">
                <button class="button" @click="reloadUsers()">
                    <b-icon icon="sync" size="is-small" :custom-class="loading ? 'fa-spin' : ''" />
                    <span> {{ translations.core.shared.btn_reload }}</span>
                </button>
                <router-link class="button" tag="button" to="/new" v-if="abilities.users.grant_create">
                    <b-icon icon="plus" size="is-small" />
                    <span>{{ translations.core.users.title_users }}</span>
                </router-link>
            </div>
        </component-header>

        <component-toolbar
            v-if="filters_ready"
            :search-text="translations.core.shared.search_placeholder"
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
                    pagination-position="bottom"

                >
                    <template slot-scope="props">
                        <b-table-column :label="translations.core.users.table_header_id" sortable field="id">
                            {{ props.row.id }}
                        </b-table-column>
                        <b-table-column :label="translations.core.users.table_header_name" sortable field="name">
                            {{ props.row.name }}
                        </b-table-column>
                        <b-table-column :label="translations.core.users.table_header_email" sortable field="email">
                            <a :href="`mailto: ${props.row.email}`"> {{ props.row.email }} </a>
                        </b-table-column>
                        <b-table-column :label="translations.core.users.table_header_role" sortable field="role">
                            {{ props.row.role }}
                        </b-table-column>
                        <b-table-column :label="translations.core.users.table_header_status" field="active">
                            <span class="tag is-success" v-if="props.row.active">
                                {{ props.row.active_text }}
                            </span>
                            <span class="tag is-warning" v-else> 
                                {{ props.row.active_text }}
                            </span>
                        </b-table-column>
                    </template>
                </b-table>
                <hr>
            </div>
        </div>
    </section>
</template>
