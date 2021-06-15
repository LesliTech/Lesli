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
            filters: {
                search: ''
            },
            requests: [],
            options: {},
            ready: false
        }
    },
    mounted() {
        this.getRoleGroups()
    },

    methods: {   
        getRoleGroups(){
            let url = this.url.admin(`roles/:role_id/privilege_groups`, {role_id: this.role.id})
            this.http.get(url).then(result => {
                if (result.successful) {
                    this.getRoleGroupOptions(result.data)
                } else {
                    this.msg.error(result.error.message)
                }
            }).catch(error => {
                console.log(error)
            })
        },
        
        getRoleGroupOptions(role_groups) {
            let url = this.url.admin(`roles/privilege_actions/options`)
            this.http.get(url).then(result => {
                if (result.successful) {
                    let groups = []
                    for(let group of result.data.groups) {                        
                        for(let index in group.actions) {
                            let role_group = role_groups.find(e => 
                                e.account_privilege_groups_id === group.id &&
                                e.category === index                                
                            )    
                            
                            if (role_group){                                
                                group.actions[index] = {
                                    ...group.actions[index],
                                    status: true,
                                    role_group_id: role_group.id 
                                }
                            }
                        }
                        
                                            
                        if (group.account_privilege_groups_id) {
                            let parent_index = groups.findIndex(e => 
                                e.id ===  group.account_privilege_groups_id
                            )
                            
                            if (parent_index !== -1){
                                groups[parent_index]['subgroups'].push(group)   
                            }
                        } else {
                            groups.push({
                                ...group,
                                subgroups: []
                            })
                        }
                    }
                
                    
                    this.options = {
                        groups: groups,
                        categories: result.data.categories
                    }
                    
                    this.ready = true
                } else {
                    this.msg.error(result.error.message)
                }
            }).catch(error => {
                console.log(error)
            })
        },

        handleSubmit(category, group_privilege, event, group_privilege_parent = null){            
            let value = event.target.checked
            
            if  (value) {
                this.postRolePrivilegeGroup(category, group_privilege, group_privilege_parent)
            } else {
                this.destroyRolePrivilegeGroup(category, group_privilege) 
            }
        },
        
        postRolePrivilegeGroup(category, group_privilege, group_privilege_parent){
            console.log(group_privilege)
            
            let data = {
                role_privilege_group: {
                    account_privilege_groups_id: group_privilege.id,
                    category: category   
                }
            }
            
            let url = this.url.admin('roles/:role_id/privilege_groups', {role_id: this.role.id})
            this.http.post(url, data).then(result => {
                if (!result.successful) {
                    this.msg.error(result.error.message)
                    return
                }
                
                if (parent) {
                    let parent_index = this.options.groups.findIndex(
                        e => e.id === group_privilege_parent.id
                    )
                    
                    let index = this.options.groups[parent_index]['subgroups'].findIndex(
                        e => e.id === group_privilege.id
                    )
                
                    this.$set(this.options.groups[parent_index]['subgroups'][index].actions[category], 'status', true)
                    this.$set(this.options.groups[parent_index]['subgroups'][index].actions[category], 'role_group_id', result.data.id)    
                } else {
                    let index = this.options.groups.findIndex(
                        e => e.id === group_privilege.id
                    )
                
                    this.$set(this.options.groups[index].actions[category], 'status', true)
                    this.$set(this.options.groups[index].actions[category], 'role_group_id', result.data.id)
                }
                
                this.msg.success('GREAT 1')
            }).catch(error => {
                console.log(error)

            })
        },

        destroyRolePrivilegeGroup(category, group_privilege){
            console.log(group_privilege.actions[category])
            let url = this.url.admin('roles/:role_id/privilege_groups/:id', 
                {role_id: this.role.id, 
                id: group_privilege.actions[category].role_group_id
            })
            
            this.http.delete(url).then(result => {
                if (!result.successful) {
                    this.msg.error(result.error.message)
                    return
                }
                
                this.msg.success('GREAT')
            }).catch(error => {
                console.log(error)

            })
        },
        
        searchRoles(text){
            this.filters.search = text
        },

        hasDetails(row){
            return (row.subgroups.length > 0)
        }
    },

    computed: {
        filteredRoles(){
            let search_field = this.filters.search.toLowerCase().trim()
            this.pagination.current_page = 1

            if (search_field.length > 0) {
                return this.options.groups.filter((role_ability)=>{
                    return (
                        role_ability.name.toLowerCase().includes(search_field)
                    )
                })
            } else {
                return this.options.groups
            }
        }
    }
}
</script>

<template>
    <section>
        <component-header
            :buttons="false"
            :title="translations.users[`column_enum_role_${(role.name || '').toLowerCase()}`] || role.name"
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
            :initialValue="filters.search"
            :search-text="translations.shared.search_placeholder"
            @search="searchRoles"
            v-if="ready"    
        >
        </component-toolbar>

        <div class="card">
            <div class="card-content">
                <b-table
                    v-if="ready"
                    :data="filteredRoles"
                    :hoverable="true"
                    custom-detail-row
                    :has-detailed-visible="hasDetails"
                    detailed
                    detail-key="name"
                    focusable
                >
                    <template v-slot="props">
                        <b-table-column field="name" label="Name" >
                            <strong> {{  props.row.name }} </strong>
                        </b-table-column>
                        
                        <b-table-column v-for="category in options.categories" :field="category" :label="category" >
                            <b-switch
                                :rounded="true"
                                :ref="props.row.name + '-' + category"
                                v-if="props.row.actions[category]['actions'].length > 0"
                                :value="props.row.actions[category]['status']"
                                @change.native="event => handleSubmit(category, props.row, event)"
                            />
                        </b-table-column>
                    </template>

                    <template slot="detail" slot-scope="props">
                        <tr v-for="subgroup in props.row.subgroups" :key="`${props.row.name}-${subgroup.name}`">
                            <td> </td>
                            <td> &nbsp; &nbsp; {{ subgroup.name }} </td>
                            <td v-for="category in options.categories" :field="category" :label="category" >
                                <b-switch
                                    :rounded="true"
                                    :ref="subgroup.name + '-' + category"
                                    v-if="subgroup.actions[category]['actions'].length > 0"
                                    :value="subgroup.actions[category]['status']"
                                    @change.native="event => handleSubmit(category, subgroup, event, props.row)"
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
