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
            submitting_form: false,
            loading: false,
            category: 'index',
            privilege_group_actions_list: [],
            privilege_group_actions: [],
            options: [],
            filters: {
                search_constrollers_list: '',
            },
            requests: [],
            checkedRows: {},
            checkedCategoryRows: []
        }
    },

    mounted() {
        this.getData()
    },

    methods: {
        submitForm(event){
            if (event) { event.preventDefault() }

            this.updatePrivilegeGroupActions()
        },

        updatePrivilegeGroupActions() {
            this.submitting_form = true
            this.copyCheckedCategoryRows(this.category)
            console.log(this.checkedRows)
            
            for(let index in this.checkedRows) {        
                console.log(index)        
                let rows  = this.checkedRows[index]
                for(let action of rows) {
                    let privilege_action = this.privilege_group_actions.find(
                        e => e.controller === action.controller  &&
                            e.action_id === action.action_id &&
                            e.category === index
                    )
                    
                    if (!privilege_action) {
                        this.postPrivilegeGroupAction(action, index)
                    }
                }
                
                for(let privilege_group_action of this.privilege_group_actions) {
                    if (!rows.find(e => 
                        (privilege_group_action.action_id == e.action_id)
                    )) {
                        if (privilege_group_action.status) {
                            console.log(1)
                            console.log(privilege_group_action)
                            // this.putPrivilegeGroupAction(privilege_group_action.id, false)
                        }
                    } else {
                        if (!privilege_group_action.status) {
                            console.log(2)
                            console.log(privilege_group_action)
                            // this.putPrivilegeGroupAction(privilege_group_action.id, true)   
                        }
                    }
                }
            }
        
            Promise.all(this.requests).then(() => {
                this.requests = []
                this.msg.success(this.translations.main.messages_success_privileges_updated)            
                this.submitting_form = false
                
                this.getPrivilegeActions() // reload privileges
                Promise.all(this.requests).then(() => {
                    console.log('ENTRA AQUI')
                    this.requests = []
                    
                    // reload form
                    this.privilege_group_actions_list = []
                    this.checkedRows = []
                    this.checkedCategoryRows = []
                    
                    // fetch new data
                    this.parseData(this.category)
                })
            })   
        },

        postPrivilegeGroupAction(route, category, status = true) {
            let data = { 
                account_privilege_group_action: { 
                    status: status, 
                    category: category,
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
            this.getPrivilegeActions()
            this.getOptions()
            
            this.loading = true
            Promise.all(this.requests).then(() => {
                this.requests = []
                this.loading = false,
                this.parseData(this.category)
            })
        },

        copyCheckedRows(category){
            this.checkedCategoryRows = []
            this.checkedCategoryRows = this.checkedRows[category].slice()
        },
        
        copyCheckedCategoryRows(category){
            this.checkedRows[category] = []
            this.checkedRows[category] = this.checkedCategoryRows.slice()
        },
        
        parseData(category){                        
            // copy the configuration
            if (!this.checkedRows[category]) this.checkedRows[category] = []
            if (!this.privilege_group_actions_list[category]) {
                this.privilege_group_actions_list[category] = []
            } else {
                this.copyCheckedRows(category)
                return 
            }
            
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
            
            this.copyCheckedRows(category)
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
                                        
                    console.log(this.privilege_group_actions)
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
            
            let resource_index = this.privilege_group_actions_list[this.category].findIndex(
                e => e.controller === controller
            )
    
            this.checkedCategoryRows = this.checkedCategoryRows.filter((e) =>{
                return e.controller !== controller
            })
               
            if (value) {
                for(let action of this.privilege_group_actions_list[this.category][resource_index]['actions']) {
                    this.checkedCategoryRows.push({ controller: controller, action_id: action.id})
                }
            }
        },
        
        setControllerActions(controller,  action_id, event){  
            let value = event.target.checked     
            
            if (value) {
                this.checkedCategoryRows.push({ controller: controller, action_id: action_id, value: })
            } else {
                this.checkedCategoryRows = this.checkedCategoryRows.filter((e) => {
                    return  e.action_id  !== action_id
                })
                
                let resource_index = this.privilege_group_actions_list[this.category].findIndex(
                    e => e.controller === controller
                )
            
                this.$set(this.privilege_group_actions_list[this.category][resource_index], 'all', false)
            }  
        }
    },

    computed: {
        filteredControllers(){
            let search_field = this.filters.search_constrollers_list.toLowerCase().trim()

            if (search_field.length > 0) {
                return this.privilege_group_actions_list[this.category].filter((action)=>{
                    return (
                        action.controller.toLowerCase().includes(search_field)
                    )
                })
            } else {
                return this.privilege_group_actions_list[this.category]
            }
        }
    },

    watch: {
        category(newValue, oldValue){
            this.copyCheckedCategoryRows(oldValue)
            this.parseData(newValue)
        }
    }
}

</script>
<template>
    <div class="card">
        <div class="card-content">
            <component-data-loading v-if="loading" />
            <template v-else>
                <div class="card-content">
                    <form @submit.prevent="submitForm">
                        <fieldset :disabled="submitting_form">
                            <div class="columns">
                                <div class="column is-10">
                                    <b-field>
                                        <b-input
                                            :placeholder="translations.core.view_toolbar_filter_placeholder_search"
                                            v-model="filters.search_constrollers_list"
                                            type="text"
                                            icon="search"
                                            icon-right="close-circle"
                                            icon-right-clickable
                                            @icon-right-click="filters.search_constrollers_list = ''">
                                        </b-input>
                                    </b-field>
                                </div>
                                <div class="column">
                                    <b-field>
                                        <b-select v-model="category" expanded placeholder="Select a category">
                                            <option
                                                v-for="category in options.categories"
                                                :value="category.value"
                                                :key="category.value">
                                                {{ category.text }}
                                            </option>
                                        </b-select>
                                    </b-field>
                                </div>
                            </div>

                            <b-table
                                v-if="privilege_group_actions_list[category]"
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
                                    <b-table-column field="controller" label="Resource" >
                                        <strong> {{ `${props.row.controller}` }} </strong>
                                    </b-table-column>

                                    <b-table-column field="all" label="All" >
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
                            
                            <div class="field is-grouped">
                                <div class="control">
                                    <button class="button is-primary">
                                        <span v-if="submitting_form">
                                            <b-icon icon="circle-notch" custom-class="fa-spin" size="is-small" />
                                            &nbsp;
                                            {{translations.core.view_btn_saving}}
                                        </span>
                                        <span v-else>
                                            <b-icon icon="save" size="is-small" />
                                            &nbsp;
                                            {{translations.core.view_btn_save}}
                                        </span>
                                    </button>
                                </div>
                            </div>
                        </fieldset>
                    </form>
                </div>
            </template>
        </div>
    </div>
</template>