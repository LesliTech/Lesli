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
        privileges: {
            type: Object
        },
        role: {
            required: true
        },
        translations: {
            required: true
        }
    },
    data() {
        return {
            pagination: {
                tasks_count: 0,
                current_page: 1,
                per_page: 10,
                range_before: 3,
                range_after: 3
            },
            options: [],
            sort: {
                icon_size: 'is-small',
                direction: 'desc'
            },
            submitted_form: false,
            filters:{
                search: ""
            },
            role_abilities: [],
            requests: [],
            ready: false
        }
    },
    mounted() {
        this.getOptions()
    },

    methods: {
        getOptions() {

        },

        parsePrivileges(privileges){
            let role_abilities = []

            for (let index in this.options) {
                let view = this.options[index]
                let module_name = view.name

                role_abilities.push({
                    index: role_abilities.length,
                    is_subrow: false,
                    name: module_name,
                    privileges: {}
                })

                let actions = Object.keys(view.privileges)

                for(let action of actions) {

                    let default_privileges = view.privileges[action] || []

                    for (let default_privilege of default_privileges) {
                        let object_name = Object.keys(default_privilege)[0]
                        let ability = privileges[object_name]


                        if (!ability) {
                            ability = {
                                actions: [],
                                id: null
                            }
                        }

                        let granted = default_privilege[object_name].every(e => {
                            return ability.actions.includes(e)

                        })

                        if (!role_abilities[index].privileges[action]) {
                            role_abilities[index].privileges[action] = {
                                granted: granted,
                                role_privileges: [{id: ability.id, grant_object: object_name, actions: default_privilege[object_name]}],
                            }
                        } else {
                            role_abilities[index].privileges[action].role_privileges.push(
                                {id: ability.id, grant_object: object_name, actions: default_privilege[object_name]}
                            )

                            role_abilities[index].privileges[action].granted = granted &&
                                role_abilities[index].privileges[action].granted
                        }
                    }
                }
            }


            for(let row_index in role_abilities) {
                let role_privilege = role_abilities[row_index]

                if (!(role_privilege.is_subrow)) {
                    let row_name = this.object_utils.singularize(role_privilege.name)

                    let sub_role_privileges = role_abilities.filter(e => e.name.startsWith(`${row_name}_`))


                    if (sub_role_privileges) {

                        for(let subrow_index in sub_role_privileges){
                            let role_privilege = sub_role_privileges[subrow_index]
                            let subrow_name = role_privilege.name.split(`${row_name}_`)[1]

                            role_abilities[role_privilege.index].is_subrow = true

                            if (!(role_abilities[row_index]['sub_categories'])) {
                                role_abilities[row_index]['sub_categories'] = [{
                                    name: subrow_name,
                                    privileges: role_privilege.privileges
                                }]
                            } else {
                                role_abilities[row_index]['sub_categories'].push({
                                    name: subrow_name,
                                    privileges: role_privilege.privileges
                                })
                            }

                        }
                    }
                }
            }

            this.role_abilities = role_abilities.filter(e => e.is_subrow === false)

            this.ready = true
        },

        putPrivileges(abilities, module_name, model_action, event, sub_category_name = null){
            let value = event.target.checked
            let module_index = this.role_abilities.findIndex(
                e => e.name == module_name
            )


            let privileges_used = {}

            if (value) {
                for (let ability of abilities.role_privileges) {
                    let grant_actions = {}

                    ability.actions.forEach(e => {
                        grant_actions[`grant_${e}`] = value
                    })

                    this.putPrivilege(ability.id, grant_actions)
                }
            } else {
                for (let ability of abilities.role_privileges) {
                    let ability_actions = ability.actions
                    let actions = ability_actions

                    for(let role_ability of this.role_abilities) {
                        for (let role_ability_action of Object.keys(role_ability.privileges)) {
                            let role_ability_privileges = role_ability.privileges[role_ability_action]

                            if(role_ability_privileges.granted) {
                                for(let role_privilege of role_ability_privileges.role_privileges) {
                                    if(role_privilege.grant_object === ability.grant_object) {
                                        let contains_any = ability_actions.filter((item) => { return role_privilege.actions.indexOf(item) > -1});

                                        if (contains_any.length > 0) {
                                            if (!privileges_used[role_ability.name]) {
                                                privileges_used[role_ability.name] = []
                                            }

                                            if (privileges_used[role_ability.name].indexOf(role_ability_action) === -1) {
                                                privileges_used[role_ability.name].push(role_ability_action)
                                            }
                                        }

                                        actions = actions.filter(function(e){
                                            return this.indexOf(e) < 0
                                        }, role_privilege.actions)
                                    }
                                }
                            }
                        }
                    }

                    if (actions.length > 0) {
                        let grant_actions = {}
                        actions.forEach(e => {
                            grant_actions[`grant_${e}`] = value
                        })

                        this.putPrivilege(ability.id, grant_actions)
                    }
                }
            }

            Promise.all(this.requests).then(() => {
                if (this.submitted_form) {

                    this.alert(this.translations.roles.notification_privileges_updated,'success')

                } else {

                    if (Object.keys(privileges_used).length > 0) {
                        let message = `${this.translations.roles.notification_privileges_error_message} <br>`
                        for(let index in privileges_used){
                            let privilege_used = privileges_used[index]

                            message += `<strong> ${index} :</strong> `;
                            message += `${privilege_used.join(' , ')} <br>`
                        }

                        this.$buefy.dialog.alert({
                            title: this.translations.roles.notification_privileges_error_title,
                            message: message,
                            type: 'is-warning',
                            hasIcon: true
                        })
                    }


                    this.$refs[`${module_name}-${model_action}`].computedValue = true

                    value = !value
                }




                if (sub_category_name) {

                    let submodule_index = this.role_abilities[module_index]['sub_categories'].findIndex(
                        e => e.name == sub_category_name
                    )

                    this.$set(this.role_abilities[module_index]['sub_categories'][submodule_index].privileges[model_action], 'granted', value)
                } else {
                    this.$set(this.role_abilities[module_index].privileges[model_action], 'granted', value)
                }

                this.requests = []
                this.submitted_form = false
            })
        },

        putPrivilege(privilege_id, grant_actions){
            if (privilege_id) {

                this.submitted_form = true
                let data_form = {
                    privilege: {
                        ...grant_actions
                    }
                }

                let request = new Promise((resolve, reject) => {
                    this.http.put(`/administration/roles/${this.role.id}/privileges/${privilege_id}`, data_form).then(result => {
                        if (!result.successful) {
                            this.alert(result.error.message,'danger')
                        }
                        resolve()
                    }).catch(error => {
                        console.log(error)
                        reject()
                    })
                })

                this.requests.push(request)
            } else {

            }

        },

        searchRoles(text){
            this.filters.search = text
        }
    },

    computed: {
        filteredRoles(){
            let search_field = this.filters.search.toLowerCase().trim()
            this.pagination.current_page = 1

            if (search_field.length > 0) {
                return this.role_abilities.filter((role_ability)=>{
                    return (
                        this.translations.roles[`module_${role_ability.name}_title` || role_ability.name].toLowerCase().includes(search_field)
                    )
                })
            } else {
                return this.role_abilities
            }
        },

        curentRolesPage(){
            if(this.filteredRoles.length <= this.pagination.per_page){
                return this.filteredRoles
            }else{
                let data = this.filteredRoles.slice(
                    (this.pagination.current_page - 1) * this.pagination.per_page,
                    (this.pagination.current_page) * this.pagination.per_page
                )
                return data
            }
        }
    },

    watch: {
        privileges(values){
            this.parsePrivileges(values)
        }
    }
}
</script>

<template>
    <section>
        <component-header
            :buttons="false"
            :title="translations.users[`column_enum_role_${(role.name || '').toLowerCase()}`] || role.name"
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
                <b-button class="button" @click.stop="url.go(`/crm/roles/${role.id}?view_type=logs`)">
                    <b-icon icon="history" size="is-small" />
                    <span>{{ translations.shared.view_btn_logs }}</span>
                </b-button>
            </div>
        </component-header>

        <component-toolbar
            v-if="ready"
            :initialValue="filters.search"
            :search-text="translations.shared.search_placeholder"
            @search="searchRoles">
        </component-toolbar>

        <div class="card">
            <div class="card-content">
                <b-table
                    v-if="ready"
                    :data="filteredRoles"
                    :hoverable="true"
                    custom-detail-row
                    detailed
                    detail-key="name"
                    focusable
                >
                    <template v-slot="props">
                        <b-table-column field="name" label="Name" >
                            <strong> {{ translations.roles[`module_${props.row.name}_title`] || `${props.row.name}` }} </strong>
                        </b-table-column>

                        <b-table-column field="grant_index" centered  :label="translations.roles.table_header_grant_index" >
                            <b-switch
                                :rounded="true"
                                :ref="props.row.name + '-index'"
                                v-if="props.row.privileges.hasOwnProperty('index')"
                                v-model="props.row.privileges.index.granted"
                                @change.native="event => putPrivileges(props.row.privileges.index, props.row.name, 'index', event)"
                            />
                        </b-table-column >

                        <b-table-column field="grant_create" centered  :label="translations.roles.table_header_grant_create" >
                            <b-switch
                                :rounded="true"
                                :ref="props.row.name + '-create'" v-if="props.row.privileges.hasOwnProperty('create')"
                                v-model="props.row.privileges.create.granted"
                                @change.native="event => putPrivileges(props.row.privileges.create, props.row.name, 'create', event)"
                            />
                        </b-table-column >

                        <b-table-column field="grant_update" centered  :label="translations.roles.table_header_grant_update" >
                            <b-switch
                                :rounded="true"
                                :ref="props.row.name + '-update'"
                                v-if="props.row.privileges.hasOwnProperty('update')"
                                v-model="props.row.privileges.update.granted"
                                @change.native="event => putPrivileges(props.row.privileges.update, props.row.name, 'update', event)"
                            />
                        </b-table-column >

                        <b-table-column field="grant_show" centered  :label="translations.roles.table_header_grant_show" >
                            <b-switch
                                :rounded="true"
                                :ref="props.row.name + '-show'"
                                v-if="props.row.privileges.hasOwnProperty('show')"
                                v-model="props.row.privileges.show.granted"
                                @change.native="event => putPrivileges(props.row.privileges.show, props.row.name, 'show', event)"
                            />
                        </b-table-column >

                        <b-table-column field="grant_destroy" centered  :label="translations.roles.table_header_grant_destroy" >
                            <b-switch
                                :rounded="true"
                                :ref="props.row.name + '-destroy'"
                                v-if="props.row.privileges.hasOwnProperty('destroy')"
                                v-model="props.row.privileges.destroy.granted"
                                @change.native="event => putPrivileges(props.row.privileges.destroy, props.row.name, 'destroy', event)"
                            />
                        </b-table-column >

                        <b-table-column field="grant_search" centered  :label="translations.roles.table_header_grant_search" >
                            <b-switch
                                :rounded="true"
                                :ref="props.row.name + '-search'" v-if="props.row.privileges.hasOwnProperty('search')"
                                v-model="props.row.privileges.search.granted"
                                @change.native="event => putPrivileges(props.row.privileges.search, props.row.name, 'search', event)"
                            />
                        </b-table-column>

                    </template>

                    <template slot="detail" slot-scope="props">
                        <tr v-for="sub_category in props.row.sub_categories" :key="`${props.row.name}-${sub_category.name}`">
                            <td> </td>
                            <td> &nbsp; &nbsp; {{ translations.roles[`module_${sub_category.name}_title`] || `${sub_category.name}` }} </td>
                            <td class="has-text-centered">
                                <b-switch
                                    :rounded="true"
                                    :ref="sub_category.name + '-index'"
                                    v-if="sub_category.privileges.hasOwnProperty('index')"
                                    v-model="sub_category.privileges.index.granted"
                                    @change.native="event => putPrivileges(sub_category.privileges.index, props.row.name, 'index', event, sub_category.name,)"
                                />
                            </td>

                            <td class="has-text-centered">
                                <b-switch
                                    :rounded="true"
                                    :ref="sub_category.name + '-create'"
                                    v-if="sub_category.privileges.hasOwnProperty('create')"
                                    v-model="sub_category.privileges.create.granted"
                                    @change.native="event => putPrivileges(sub_category.privileges.create, props.row.name, 'create', event, sub_category.name)"
                                />
                            </td>

                            <td class="has-text-centered">
                                <b-switch
                                    :rounded="true"
                                    :ref="props.row.name + '-update'"
                                    v-if="sub_category.privileges.hasOwnProperty('update')"
                                    v-model="sub_category.privileges.update.granted"
                                    @change.native="event => putPrivileges(sub_category.privileges.update, props.row.name, 'update', event, sub_category.name)"
                                />
                            </td>

                            <td class="has-text-centered">
                                <b-switch
                                    :rounded="true"
                                    :ref="sub_category.name + '-show'"
                                    v-if="sub_category.privileges.hasOwnProperty('show')"
                                    v-model="sub_category.privileges.show.granted"
                                    @change.native="event => putPrivileges(sub_category.privileges.show, props.row.name, 'show', event, sub_category.name)"
                                />
                            </td>

                            <td class="has-text-centered">
                                <b-switch
                                    :rounded="true"
                                    :ref="sub_category.name + '-destroy'"
                                    v-if="sub_category.privileges.hasOwnProperty('destroy')"
                                    v-model="sub_category.privileges.destroy.granted"
                                    @change.native="event => putPrivileges(sub_category.privileges.destroy, props.row.name, 'destroy', event, sub_category.name)"
                                />
                            </td>

                            <td class="has-text-centered">
                                <b-switch
                                    :rounded="true"
                                    :ref="sub_category.name + '-search'"
                                    v-if="sub_category.privileges.hasOwnProperty('search')"
                                    v-model="sub_category.privileges.search.granted"
                                    @change.native="event => putPrivileges(sub_category.privileges.search, sub_category.name, 'search', event, sub_category.name)"
                                />
                            </td>
                        </tr>
                    </template>
                </b-table>
                <hr>
            </div>
        </div>
    </section>
</template>
