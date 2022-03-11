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
        lesli_engine: {
            default: "admin"
        }  
    },
    data() {
        return {
            roles: [],
            roles_name: [],
            sort: {
                icon_size: 'is-small',
                direction: 'desc'
            },
            filters: {
                per_page: 10,
                text: ''
            },
            sorting: {
                order: "asc",
                field: "id",
                icon_size: "is-small",
            },
            pagination: {
                roles_count: 0,
                current_page: 1,
                range_before: 3,
                range_after: 3
            },
            translations: {
                core: {
                    roles: I18n.t('core.roles'),
                    shared: I18n.t('core.shared')   
                }
            },
            loading: false,
            index_abilities: {
                users: this.abilities.privilege('users'),
                roles: this.abilities.privilege('roles'),
                logs: this.abilities.privilege('role/activities')
            },
            filters_ready: false,
            roles_name_ready: false
        }
    },
    mounted() {
        this.setSessionStorageFilters()
        this.getRolesOptions()
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

            this.filters_ready = true
        },

        getRolesOptions(){
            const url =  this.url.admin('roles/list')
            
            this.http.get(url).then(result => {
                if (result.successful) {
                    this.roles_name = result.data.map(role => {
                        return {
                            name: role.name,
                            translated_name: (this.object_utils.translateEnum(this.translations.core.roles, 'column_enum_role',  role.name))||role.name
                        }
                    })

                    this.roles_name_ready = true
                }else{
                    this.msg.error(result.error.message)
                }
            }).catch(error => {
                console.log(error)
            })
        },

        getRoles() {
            this.storage.local("filters", this.filters)

            this.loading = true

            let url = this.url.admin('roles')

            url = url.filters({
                text: (this.filters.role_name || this.filters.text)
            }).paginate(
                this.pagination.current_page, this.filters.per_page
            )
            
            this.http.get(url).then(result => {
                this.loading = false
                if (result.successful) {
                    this.roles = result.data.records.map(role => {
                        return {
                            ...role,
                            translated_name: (this.object_utils.translateEnum(this.translations.core.roles, 'column_enum_role',  role.name))||role.name
                        }
                    })

                    this.pagination.roles_count = result.data.pagination.count_total
                }else{
                    this.msg.error(result.error.message)
                }
            }).catch(error => {
                console.log(error)
            })
        },

        searchRoles(text){
            this.pagination.current_page = 1

            text = text.trim()
            this.filters.role_name = null

            if (text != "") {
              for(let role of this.roles_name) {
                  if ((role.translated_name||"").toLowerCase() === text.toLowerCase()) {

                      this.filters.role_name = role.name

                      break;
                  }
              }
            }

            this.filters.text = text

            this.getRoles()
        },

        deleteRole(role_id){
            const url = this.url.admin('roles/:id', {id: role_id});
            
            this.http.delete(url).then(result => {
                if (result.successful) {
                    this.msg.success(this.translations.core.roles.messages_success_role_deleted);

                    this.roles = this.roles.filter(e => {
                        return e.id !== role_id;
                    });
                }else{
                    this.msg.error(result.error.message);
                };
            }).catch(error => {
                console.log(error);
            })
        },
        
        showRole(role){
            this.$router.push(`${role.id}`)
        }
    },
    watch: {
        'pagination.current_page'(){
            this.getRoles()
        },

        'filters.per_page'(){
            if(this.filters_ready && this.roles_name_ready){
                this.getRoles()
            }
        }
    }
}
</script>
<template>
    <section class="application-component">
        <component-header
            :title="translations.core.roles.view_text_roles">
            <div class="buttons">
                <button class="button" @click="getRoles()">
                    <b-icon icon="sync" size="is-small" :custom-class="loading ? 'fa-spin' : ''" />
                    <span> {{ translations.core.shared.view_btn_reload }}</span>
                </button>
                <router-link class="button" tag="button" to="/new" v-if="index_abilities.roles.create">
                    <b-icon icon="plus" size="is-small" />
                    <span>{{ translations.core.roles.view_btn_new_role }}</span>
                </router-link>
            </div>
        </component-header>

        <component-toolbar
            v-if="filters_ready"
            :search-text="translations.core.roles.view_toolbar_search_by_placeholder_text"
            @search="searchRoles"
            :initial-value="filters.text">

            <div class="control">
                <div class="select">
                    <select
                        name="filter-per-page"
                        v-model="filters.per_page"
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
        <component-data-empty v-if="!loading && roles.length == 0" />

        <div class="card" v-if="roles.length > 0">
            <div class="card-content">

                <b-table
                    :data="roles"
                    :hoverable="true"
                    v-if="!loading && roles.length > 0"
                    :sort-icon-size="sort.icon_size"
                    :default-sort-direction="sort.direction"
                    @click="showRole"
                >
                    <template v-slot="props">

                        <b-table-column :label="translations.core.shared.view_text_name" field="name">
                            {{ props.row.translated_name }}
                        </b-table-column>

                        <b-table-column :label="translations.core.roles.view_text_users_count" field="users_count">
                            {{ props.row.user_count ? props.row.user_count : 0 }}
                        </b-table-column>

                        <b-table-column :label="translations.core.shared.view_text_active" field="active">
                            {{ props.row.active ? translations.core.shared.view_text_yes : translations.core.shared.view_text_no }}
                        </b-table-column>

                        <b-table-column @click.native.prevent="e=>e.stopPropagation()" :label="translations.core.shared.view_text_actions" centered>
                            <b-dropdown aria-role="menu" position="is-bottom-left">
                                <button class="button is-rounded is-default" slot="trigger" slot-scope="{ active }">
                                    <span class="icon">
                                        <i v-if="!active" class="fas fa-ellipsis-h fa-1x"></i>
                                        <i v-if="active" class="far fa-circle"></i>
                                    </span>
                                </button>
                                <b-dropdown-item @click="$router.push(`/${props.row.id}?view_type=simple`)" class="has-text-right pr-4">
                                    {{ translations.core.roles.view_btn_edit_privilege_actions }}
                                    <span class="icon">
                                        <i class="fas fa-cogs"></i>
                                    </span>
                                </b-dropdown-item>
                                <b-dropdown-item @click="$router.push(`/${props.row.id}?view_type=edit`)" class="has-text-right pr-4">
                                    {{ translations.core.roles.view_btn_edit_role_information }}
                                    <span class="icon">
                                        <i class="fas fa-edit"></i>
                                    </span>
                                </b-dropdown-item>
                                <b-dropdown-item @click="url.go(url[lesli_engine](`users?role=${props.row.name}`))" class="has-text-right pr-4">
                                    {{ translations.core.roles.view_btn_users_list }}
                                    <span class="icon">
                                        <i class="fas fa-users"></i>
                                    </span>
                                </b-dropdown-item>
                                <b-dropdown-item @click="$router.push(`/${props.row.id}?view_type=logs`)" class="has-text-right pr-4">
                                    {{ translations.core.roles.view_btn_logs }}
                                    <span class="icon">
                                        <i class="fas fa-history"></i>
                                    </span>
                                </b-dropdown-item>
                                <b-dropdown-item @click="deleteRole(props.row.id)" v-if="index_abilities.roles.destroy" class="has-text-right pr-4">
                                    {{ translations.core.roles.view_btn_delete }}
                                    <span class="icon">
                                        <i class="fas fa-trash"></i>
                                    </span>
                                </b-dropdown-item>
                            </b-dropdown>
                        </b-table-column>
                    </template>
                </b-table>
                <b-pagination
                    :simple="false"
                    :total="pagination.roles_count"
                    :current.sync="pagination.current_page"
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
