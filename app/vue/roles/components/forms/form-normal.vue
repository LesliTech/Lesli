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
            ready: false,
            groups: []
        }
    },
    mounted() {
        this.getRoleGroups()
    },

    methods: {    
        getRoleGroups() {
            let url = this.url.admin(`roles/privilege_actions/options`)
            this.http.get(url).then(result => {
                if (result.successful) {
                    let groups = []
                    for(let group of result.data.groups) {
                        if (group.account_privilege_groups_id) {
                            let parent_index = groups.findIndex(e => 
                                e.id ===  group.account_privilege_groups_id
                            )
                            
                            if (parent_index !== -1){
                                groups[parent_index]['subgroup'].push(group)   
                            }
                        } else {
                            groups.push({
                                ...group,
                                subgroup: []
                            })
                        }
                    }
                    
                    this.groups = groups
                    console.log(this.groups)
                } else {
                    this.msg.error(result.error.message)
                }
            }).catch(error => {
                console.log(error)
            })
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
                    this.http.put(`/administration/roles/${this.role.id}/privileges/${privilege_id}.json`, data_form).then(result => {
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
        },

        hasDetails(row){
            return Boolean(row.sub_categories)
        }
    },

    computed: {
        filteredRoles(){
            let search_field = this.filters.search.toLowerCase().trim()
            this.pagination.current_page = 1

            if (search_field.length > 0) {
                return this.role_abilities.filter((role_ability)=>{
                    return (
                        this.translations.roles[`view_text_${role_ability.name}_title` || role_ability.name].toLowerCase().includes(search_field)
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
            </div>
        </div>
    </section>
</template>
