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
            main_route: 'administration/roles',
            translations: {
                roles: I18n.t('deutscheleibrenten.roles'),
                shared: I18n.t('deutscheleibrenten.shared'),
                users: I18n.t('deutscheleibrenten.users'),
                core_roles: I18n.t('core.roles')
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
            let url = `/${this.main_route}/list.json`
            this.http.get(url).then(result => {
                if (result.successful) {
                    this.roles_name = result.data.map(role => {
                        return {
                            name: role.name,
                            translated_name: (this.object_utils.translateEnum(this.translations.core_roles, 'column_enum_role',  role.name))||role.name
                        }
                    })

                    this.roles_name_ready = true
                }else{
                    this.alert(result.error.message,'danger')
                }
            }).catch(error => {
                console.log(error)
            })
        },

        getRoles() {
            this.storage.local("filters", this.filters)

            this.loading = true

            let url = this.url.lesli(`${this.main_route}`)

            url = url.filters({
                text: (this.filters.role_name || this.filters.text),
            }).paginate(
                this.pagination.current_page,
                this.filters.per_page
            )

            this.http.get(url).then(result => {
                this.loading = false
                if (result.successful) {
                    this.roles = result.data.records.map(role => {
                        return {
                            ...role,
                            translated_name: (this.object_utils.translateEnum(this.translations.core_roles, 'column_enum_role',  role.name))||role.name
                        }
                    })

                    this.pagination.roles_count = result.data.pagination.count_total
                }else{
                    this.alert(result.error.message,'danger')
                }
            }).catch(error => {
                console.log(error)
            })
        },

        searchRoles(text){
            this.pagination.current_page = 1

            text = (text||"").trim()
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
            this.http.delete(`/${this.main_route}/${role_id}`).then(result => {
                if (result.successful) {
                    this.alert(this.translations.roles.notification_delete, 'success')
                    this.roles = this.roles.filter(e => {
                        return e.id !== role_id
                    })
                }else{
                    this.msg.error(result.error.message)
                }
            }).catch(error => {
                console.log(error)
            })
        },

        showRole(role) {
            this.$router.push(`/${role.id}`)
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
            :title="translations.roles.title">
            <div class="buttons">
                <button class="button" @click="getRoles()">
                    <b-icon icon="sync" size="is-small" :custom-class="loading ? 'fa-spin' : ''" />
                    <span> {{ translations.shared.btn_reload }}</span>
                </button>
                <router-link class="button" tag="button" to="/new" v-if="index_abilities.roles.create">
                    <b-icon icon="plus" size="is-small" />
                    <span>{{ translations.roles.btn_new }}</span>
                </router-link>
            </div>
        </component-header>

        <component-toolbar
            v-if="filters_ready"
            :search-text="translations.roles.view_toolbar_search_by_placeholder_text"
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

                        <b-table-column :label="translations.shared.text_name" field="name">
                            {{ props.row.translated_name }}
                        </b-table-column>

                        <b-table-column :label="translations.users.title_users" field="users_count">
                            {{ props.row.user_count ? props.row.user_count : 0 }}
                        </b-table-column>

                        <b-table-column :label="translations.shared.text_active" field="active">
                            {{ props.row.active ? translations.shared.text_yes : translations.shared.text_no }}
                        </b-table-column>

                        <b-table-column :label="translations.shared.text_actions" class="has-text-center">
                            <span>
                                <router-link class="button" :to="`/${props.row.id}?view_type=simple`">
                                    <b-icon icon="eye" />
                                </router-link>
                                <router-link class="button" :to="`/${props.row.id}?view_type=advanced`">
                                    <b-icon icon="cogs" />
                                </router-link>
                                <router-link class="button" :to="`/${props.row.id}?view_type=edit`">
                                    <b-icon icon="edit" />
                                </router-link>
                                <b-button type="is-default" outlined @click.stop="url.go(url[lesli_engine](`users?role=${props.row.name}`))">
                                    <b-icon icon="users" />
                                </b-button>
                                <b-tooltip v-if="index_abilities.logs.index" :label="translations.roles.view_text_role_logs" type="is-info">
                                    <router-link class="button" :to="`/${props.row.id}`">
                                        <b-icon icon="history" />
                                    </router-link>
                                </b-tooltip>
                                <b-button type="is-danger" outlined @click.stop="deleteRole(props.row.id)" v-if="index_abilities.roles.destroy">
                                    <b-icon icon="trash-alt" />
                                </b-button>
                            </span>
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