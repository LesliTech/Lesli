<script>
/*
Copyright (c) 2021, all rights reserved.

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
        privilege_group: {
            required: true
        }
    },

    data() {
        return {
            translations: {
                core: I18n.t('core.shared'),
                main: I18n.t('core.account/privilege_groups')
            },
            loading: false,
            privilege_group_actions_list: [],
            privilege_group_actions: [],
            options: {},
            filters: {
                search_constrollers_value: '',
                search_constrollers_list: {},
            },
            requests: [],
            checkedRows: {},
            checkedCategoryRows: [],
            active_tab: 0
        }
    },

    mounted() {
        this.getData()
    },

    methods: {
        submitActions(actions, value){
            for(let action of  actions) {
                this.handleSubmit(action, value)
            }
            
            Promise.all(this.requests).then(() => {
                this.requests = []
                this.msg.success(this.translations.main.messages_success_privilege_group_actions_updated)    
            })
        },
        
        handleSubmit(action, value){
            let privilege_action = this.privilege_group_actions.find(
                e => e.controller === action.controller  &&
                    e.action_id === action.action_id &&
                    e.category === this.getCategory()
            )
            
            if (!privilege_action) {
                this.postPrivilegeGroupAction(action)
            } else {
                this.putPrivilegeGroupAction(privilege_action.id, value)
            }
        },
        
        postPrivilegeGroupAction(route, status = true) {
            let data = { 
                account_privilege_group_action: { 
                    status: status, 
                    category: this.getCategory(),
                    system_controller_actions_id: route.action_id,
                    account_privilege_groups_id: this.privilege_group.id
                }
            }
            
            let request = new Promise((resolve, reject) => {
                let url = this.url.admin('account/privilege_group_actions')
                this.http.post(url, data).then(result => {
                    if (!result.successful) {
                        this.msg.error(result.error.message)
                    }
                
                    this.privilege_group_actions.push({
                        id: result.data.id,
                        controller: route.controller,
                        action_id: route.action_id,
                        category: result.data.category
                    })
                    
                    resolve()
                }).catch(error => {
                    console.log(error)

                    reject()
                })
            })
                
            this.requests.push(request)
        },
        
        putPrivilegeGroupAction(privilege_group_action_id, status) {  
            let data = { 
                account_privilege_group_action: { 
                    status: status,
                    account_privilege_groups_id: this.privilege_group.id
                }
            }
            
            let request = new Promise((resolve, reject) => {
                let url = this.url.admin('account/privilege_group_actions/:id', { id: privilege_group_action_id})
                this.http.put(url, data).then(result => {
                    if (!result.successful) {
                        this.msg.error(result.error.message)
                    }
                    resolve()
                }).catch(error => {
                    console.log(error)

                    reject()
                })
            })
    
        },

        getData(){
            this.getOptions()
            this.getPrivilegeActions()
            
            this.loading = true
            Promise.all(this.requests).then(() => {
                this.requests = []
                this.loading = false,
                this.parseData()
            })
        },

        copyCheckedCategoryRows(category){
            this.checkedRows[category] = []
            this.checkedRows[category] = this.checkedCategoryRows.slice()
        },
        
        copyCheckedRows(category){
            this.checkedCategoryRows = []
            this.checkedCategoryRows = this.checkedRows[category].slice()
        },
        
        parseData(){                        
            for(let category of this.options.categories) {
                category = category.value 
                
                if (!this.checkedRows[category]) this.checkedRows[category] = []
                if (!this.privilege_group_actions_list[category]) this.privilege_group_actions_list[category] = []
                if (!this.filters.search_constrollers_list[category]) this.filters.search_constrollers_list[category] = ''
                
                for (let route of this.options.system_controllers){
                    let active = false                
                    if (this.privilege_group_actions.find(e => 
                        (route.controller_id === e.controller_id) &&
                        (route.action_id === e.action_id) &&
                        (e.category === category) &&
                        e.status
                    )) {
                        active = true
                        this.checkedRows[category].push({controller: route.controller, action_id: route.action_id})
                    }
                    
                let index = this.privilege_group_actions_list[category].findIndex(e => e.controller === route.controller)

                    if  (index === -1){
                        this.privilege_group_actions_list[category].push(
                            {
                                all: active,
                                controller: route.controller,
                                actions: [{name: route.action, id: route.action_id}]
                            }
                        )
                    } else {
                        this.privilege_group_actions_list[category][index]['all'] = this.privilege_group_actions_list[category][index]['all'] && active
                        this.privilege_group_actions_list[category][index]['actions'].push({name: route.action, id: route.action_id})
                    }
                }
            }
            
            
            this.copyCheckedRows(this.getCategory()) // initial checked rows of index
        },
        
        getPrivilegeActions(){
            let url = this.url.admin('account/privilege_groups/:id/resources/actions', {id: this.privilege_group.id})

            let request = new Promise((resolve, reject) => {
                this.http.get(url, { account_privilege_group: this.privilege_group }).then(result => {
                    if (!result.successful) {
                        this.msg.error(result.error.message)
                    } else {
                        this.privilege_group_actions = result.data
                    }
                                        
                    resolve()
                }).catch(error => {
                    console.log(error)

                    reject()
                })
            })

            this.requests.push(request)
        },

        getOptions(){
            let url = this.url.admin('account/privilege_group_actions/options')

            let request = new Promise((resolve, reject) => {
                this.http.get(url, { account_privilege_group: this.privilege_group }).then(result => {
                    if (!result.successful) {
                        this.msg.error(result.error.message)
                    } else {
                        this.options = result.data
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
            
            let resource_index = this.privilege_group_actions_list[this.getCategory()].findIndex(
                e => e.controller === controller
            )
    
            let actions = this.checkedCategoryRows.filter((e) =>{
                return e.controller === controller
            })
              
            this.checkedCategoryRows = this.checkedCategoryRows.filter((e) =>{
                return e.controller !== controller
            })
               
            if (value) { 
                actions = []
                
                for(let action of this.privilege_group_actions_list[this.getCategory()][resource_index]['actions']) {
                    let new_action =  { controller: controller, action_id: action.id}
                    
                    actions.push(new_action)
                    this.checkedCategoryRows.push(new_action)
                }
            }
            
            this.submitActions(actions, value)
        },
        
        setControllerActions(controller,  action_id, event){  
            let value = event.target.checked     
            let action = { controller: controller, action_id: action_id}
                            
            if (value) {
                this.checkedCategoryRows.push(action)
            } else {
                this.checkedCategoryRows = this.checkedCategoryRows.filter((e) => {
                    return  e.action_id  !== action_id
                })
                
                let resource_index = this.privilege_group_actions_list[this.getCategory()].findIndex(
                    e => e.controller === controller
                )
            
                this.$set(this.privilege_group_actions_list[this.getCategory()][resource_index], 'all', false)
            }
            
            this.submitActions([action], value)
        },
        
        getCategory(index){
            if (!(index >= 0)) {
                index = this.active_tab
            }
            
            return this.options.categories[index].value
        },
        
        copyFilters(text){
            this.filters.search_constrollers_list[this.getCategory()] = this.filters.search_constrollers_value
        }
    },

    computed: {
        filteredControllers(){
            let search_field = this.filters.search_constrollers_value
            this.copyFilters(search_field)
            
            search_field = search_field.toLowerCase().trim()
            if (search_field.length > 0) {
                return this.privilege_group_actions_list[this.getCategory()].filter((action)=>{
                    return (
                        (action.controller || '').toLowerCase().includes(search_field)
                    )
                })
            } else {
                return this.privilege_group_actions_list[this.getCategory()]
            }
        }
    },

    watch: {
        active_tab(newValue, oldValue){
            this.filters.search_constrollers_value = this.filters.search_constrollers_list[this.getCategory(newValue)]           
            this.copyCheckedCategoryRows(this.getCategory(oldValue))
            this.copyCheckedRows(this.getCategory(newValue))
            
        }
    }
}

</script>
<template>
    <section>
    <component-data-loading v-if="loading" />
    <template v-else>
        <b-tabs expanded v-model="active_tab">
            <b-tab-item 
                v-for="category in options.categories"
                :label="object_utils.translateEnum(translations.main, 'column_enum_category', category.text)"
            >
                <div class="card">
                    <div class="card-header">
                        <p class="card-header-title">
                            {{ translations.main[`view_text_description_${category.value}`]}}
                        </p>
                    </div>
                    <div class="card-content">
                        <form>
                            <fieldset>
                                <div class="columns">
                                    <div class="column is-full">
                                        <b-field>
                                            <b-input
                                                :placeholder="translations.core.view_toolbar_filter_placeholder_search"
                                                v-model="filters.search_constrollers_value"
                                                type="text"
                                                icon="search"
                                                icon-right="close-circle"
                                                icon-right-clickable
                                                @icon-right-click="filters.search_constrollers_value = ''">
                                            </b-input>
                                        </b-field>
                                    </div>
                                </div>

                                <b-table
                                    v-if="privilege_group_actions_list[getCategory()]"
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
                                        <b-table-column field="controller" :label="translations.main.view_text_resource" >
                                            <strong> {{ `${props.row.controller}` }} </strong>
                                        </b-table-column>

                                        <b-table-column field="all" :label="translations.view_text_all_actions" >
                                            <b-switch
                                                :rounded="false"
                                                :ref="props.row.controller + '-all'"
                                                v-model="props.row.all"
                                                @change.native="event => selectAllControllerActions(props.row.controller,event)"
                                            />
                                        </b-table-column>
                                    </template>

                                    <template slot="detail" slot-scope="props">
                                        <tr v-for="(item, index) in props.row.actions" :key="`${props.row.controller}-${index}`">
                                            <td></td>
                                            <td> {{ item.name }} </td>
                                            <td>
                                                <b-switch
                                                    :rounded="false"
                                                    :value="checkedCategoryRows.findIndex(e => e.controller === props.row.controller && e.action_id === item.id) === -1 ? false : true"
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
            </b-tab-item>
        </b-tabs>
    </template>
    </section>
</template>
