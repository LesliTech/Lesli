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
        }
    },

    data() {
        return {
            translations: {
                main: I18n.t('core.roles'),
                core: I18n.t('core.shared'),
                users: I18n.t('deutscheleibrenten.users'),
                shared: I18n.t('deutscheleibrenten.shared'),
                privilege_actions: I18n.t('core.role/privilege_actions'),
                privilege_groups: I18n.t('core.account/privilege_groups')
            },
            loading: false,
            role_privilege_actions_list: [],
            role_privilege_actions: [],
            filters: {
                search: ''
            },
            requests: [],
            checkedRows: [],
            active_tab: 0,
            errors: [] 
        }
    },

    mounted() {
        this.getData()
    },

    methods: {
        submitActions(actions, value){
            for(let action of  actions) {
                this.putPrivilegeGroupAction(action.id, value)
            }
            
            Promise.all(this.requests).then(() => {
                if (this.errors.length > 0) {
                    this.msg.error(this.errors.join('. '))
                } else {
                    this.msg.success(this.translations.privilege_actions.messages_success_actions_updated)
                }  
                
                this.requests = []
                this.errors = []  
            })
        },
        
        putPrivilegeGroupAction(role_privilege_action_id, status) {  
            let data = { 
                role_privilege_action: { 
                    status: status,
                }
            }
            
            let request = new Promise((resolve, reject) => {
                let url = this.url.admin('roles/:role_id/privilege_actions/:id', { role_id: this.role.id, id: role_privilege_action_id})
                this.http.put(url, data).then(result => {
                    if (!result.successful) {
                        this.errors.push(result.error.message)
                        
                        if (status) {
                            this.checkedRows = this.checkedRows.filter(e => e.id !== role_privilege_action_id) // disabled in the view
                        } else {
                            let route = this.role_privilege_actions.find(e => e.id === role_privilege_action_id)
                            this.checkedRows.push({controller: route.controller, id: route.id}) // enable in the view
                        }
                    }
                    resolve()
                }).catch(error => {
                    console.log(error)

                    reject()
                })
            })
            
            this.requests.push(request)
        },

        getData(){
            this.getPrivilegeActions()
            
            this.loading = true
            Promise.all(this.requests).then(() => {
                this.requests = []
                this.loading = false
                this.parseData()
            })
        },
        
        parseData(){                                                    
            for (let route of this.role_privilege_actions){              
                if (route.status) {
                    this.checkedRows.push({controller: route.controller, id: route.id})
                }
                
                let index = this.role_privilege_actions_list.findIndex(e => e.controller === route.controller)
                
                if  (index === -1){
                    this.role_privilege_actions_list.push(
                        {
                            all: status,
                            controller: route.controller,
                            actions: [{name: route.action_name, id: route.id}]
                        }
                    )
                } else {
                    this.role_privilege_actions_list[index]['all'] = this.role_privilege_actions_list[index]['all'] && status
                    this.role_privilege_actions_list[index]['actions'].push({name: route.action_name, id: route.id})
                }
            }
        },
        
        getPrivilegeActions(){
            let url = this.url.admin('roles/:id/privilege_actions', {id: this.role.id})

            let request = new Promise((resolve, reject) => {
                this.http.get(url, { account_privilege_group: this.privilege_group }).then(result => {
                    if (!result.successful) {
                        this.msg.error(result.error.message)
                    } else {
                        this.role_privilege_actions = result.data
                    }
                                        
                    resolve()
                }).catch(error => {
                    console.log(error)

                    reject()
                })
            })

            this.requests.push(request)
        },

        hasDetails(row){
            return (row.actions.length > 0)
        },
        
        selectAllControllerActions(controller, event){
            let value = event.target.checked  
            
            let resource_index = this.role_privilege_actions_list.findIndex(
                e => e.controller === controller
            )
    
            let actions = this.checkedRows.filter((e) =>{
                return e.controller === controller
            })
              
            this.checkedRows = this.checkedRows.filter((e) =>{
                return e.controller !== controller
            })
               
            if (value) { 
                actions = []
                
                for(let action of this.role_privilege_actions_list[resource_index]['actions']) {
                    let new_action =  { controller: controller, id: action.id}
                    
                    actions.push(new_action)
                    this.checkedRows.push(new_action)
                }
            }
            
            this.submitActions(actions, value)
        },
        
        setControllerActions(controller,  id, event){  
            let value = event.target.checked     
            let action = { controller: controller, id: id}
                            
            if (value) {
                this.checkedRows.push(action)
            } else {
                this.checkedRows = this.checkedRows.filter((e) => {
                    return  e.id  !== id
                })
                
                let resource_index = this.role_privilege_actions_list.findIndex(
                    e => e.controller === controller
                )
            
                this.$set(this.role_privilege_actions_list[resource_index], 'all', false)
            }
            
            this.submitActions([action], value)
        },
        
        searchActions(text){
            this.filters.search = text
        }
    },

    computed: {
        filteredControllers(){
            let search_field = this.filters.search
            
            search_field = search_field.toLowerCase().trim()
            if (search_field.length > 0) {
                return this.role_privilege_actions_list.filter((action)=>{
                    return (
                        (action.controller || '').toLowerCase().includes(search_field)
                    )
                })
            } else {
                return this.role_privilege_actions_list
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
                <b-button class="button" @click.stop="$set(data, 'view_type', 'edit')">
                    <b-icon icon="edit" size="is-small" />
                    <span>{{ translations.shared.btn_edit }}</span>
                </b-button>
                <b-button class="button" @click.stop="$set(data, 'view_type', 'logs')">
                    <b-icon icon="history" size="is-small" />
                    <span>{{ translations.shared.view_btn_logs }}</span>
                </b-button>
                <b-button class="button" @click.stop="$set(data, 'view_type', 'simple')">
                    <b-icon icon="eye" size="is-small" />
                    <span>{{ translations.main.view_btn_simple }}</span>
                </b-button>
            </div>
        </component-header>
        
        <component-toolbar
            :search-text="translations.shared.search_placeholder"
            @search="searchActions"  
        >
        </component-toolbar>
                                    
        <component-data-loading v-if="loading" />
        <template v-else>
            <div class="card">
                <div class="card-content">
                    <form>
                        <fieldset>
                            <b-table
                                v-if="role_privilege_actions_list"
                                :data="filteredControllers"
                                :hoverable="true"
                                custom-detail-row
                                :has-detailed-visible="hasDetails"
                                :bordered="true"
                                :striped="true"
                                detailed
                                :paginated="true"
                                :per-page="15"
                                detail-key="controller"
                            >
                                <template v-slot="props">
                                    <b-table-column field="controller" :label="translations.privilege_groups.view_text_resource" >
                                        <strong> {{ `${props.row.controller}` }} </strong>
                                    </b-table-column>

                                    <b-table-column field="all" :label="translations.view_text_all_actions" >
                                        <b-switch
                                            :rounded="false"
                                            :ref="props.row.controller + '-all'"
                                            :value="(checkedRows.filter(e => e.controller === props.row.controller)||[]).length === (role_privilege_actions.filter(e => e.controller === props.row.controller)).length"
                                            @change.native="event => selectAllControllerActions(props.row.controller,event)"
                                        />
                                    
                                        <span>
                                            <b-tag rounded type="is-default">
                                                <strong>
                                                    {{ '(' + (checkedRows.filter(e => e.controller === props.row.controller)||[]).length + '/' + (role_privilege_actions.filter(e => e.controller === props.row.controller)).length + ')'}}
                                                </strong> 
                                            </b-tag rounded>
                                        </span>
                                    </b-table-column>
                                </template>

                                <template slot="detail" slot-scope="props">
                                    <tr v-for="(item, index) in props.row.actions" :key="`${props.row.controller}-${index}`">
                                        <td></td>
                                        <td> {{ item.name }} </td>
                                        <td>
                                            <b-switch
                                                :rounded="false"
                                                :value="checkedRows.findIndex(e => e.controller === props.row.controller && e.id === item.id) === -1 ? false : true"
                                                @change.native="event => setControllerActions(props.row.controller, item.id, event)"
                                            />
                                        </td>
                                    </tr>
                                </template>
                            </b-table>
                        </fieldset>
                    </form>
                </div>
            </div>
        </template>
    </section>
</template>
