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
            privilege_group_actions_assigned: [],
            privilege_group_actions_list: [],
            privilege_group_actions: [],
            options: [],
            filters: {
                search_constrollers_list: '',
                search_controllers_assigned: ''
            },
            requests: [],
            checkedRowsAvailable: [],
            checkedRowsAssigned: [],
        }
    },

    mounted() {
        this.getData()
    },

    methods: {
        addActions(event){

        },

        removeActions(event){

        },

        postPrivilegeGroupAction() {
            this.submitting_form = true

            let url = this.url.admin(`account/privilege_group_actions`)

            this.http.post(url, { account_privilege_group: this.privilege_group }).then(result => {
                this.submitting_form = false

                if (!result.successful) {
                    this.msg.error(result.error.message)
                    return
                }

                this.msg.success(this.translations.main.messages_success_created)

                this.$router.push(`${result.data.id}`)
            }).catch(error => {
                console.log(error)
            })
        },

        putPrivilegeGroupAction() {
            this.submitting_form = true

            let url = this.url.admin('account/privilege_group_actions/:id', { id: this.privilege_group.id})
            this.http.put(url, { account_privilege_group: this.privilege_group }).then(result => {
                this.submitting_form = false

                if (!result.successful) {
                    this.msg.error(result.error.message)
                    return
                }

                this.msg.success(this.translations.main.messages_success_updated)
            }).catch(error => {
                console.log(error)
            })
        },

        getData(){
            this.getPrivilegeActions()
            this.getOptions()

            this.loading = true
            Promise.all(this.requests).then(() => {
                this.requests = []
                this.loading = true


                let list = []

                console.log(this.privilege_group_actions)

                for (let route of this.options.system_controllers){
                    if (!this.privilege_group_actions.find(e => {
                        (route.controller_id == e.controller_id) &&
                        (route.action_id ==  e.action_id)
                        && e.value
                    })) {
                        list.push(route)
                    } else {
                        let index = this.privilege_group_actions_assigned.findIndex(e => e.controller === route.controller)

                        if  (index === -1){
                            this.privilege_group_actions_assigned.push(
                                {
                                    controller: route.controller,
                                    actions: [{selected: false, name: route.action, id: route.action_id}],
                                    selected: false
                                }
                            )
                        } else {
                            this.privilege_group_actions_assigned[index]['actions'].push({selected: false, name: route.action})
                        }
                    }
                }

                for(let route of list) {
                    let index = this.privilege_group_actions_list.findIndex(e => e.controller === route.controller)

                    if  (index === -1){
                        this.privilege_group_actions_list.push(
                            {
                                controller: route.controller,
                                actions: [{selected: false, name: route.action, id: route.action_id}],
                                selected: false
                            }
                        )
                    } else {
                        this.privilege_group_actions_list[index]['actions'].push({selected: false, name: route.action})
                    }
                }
            })
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
        }
    },

    computed: {
        filteredControllersAvailable(){
            let search_field = this.filters.search_constrollers_list.toLowerCase().trim()

            if (search_field.length > 0) {
                return this.privilege_group_actions_list.filter((action)=>{
                    return (
                        action.controller.toLowerCase().includes(search_field)
                    )
                })
            } else {
                return this.privilege_group_actions_list
            }
        },

        filteredControllersAssigned(){
            let search_field = this.filters.search_controllers_assigned.toLowerCase().trim()

            if (search_field.length > 0) {
                return this.privilege_group_actions_assigned.filter((action)=>{
                    return (
                        action.controller.toLowerCase().includes(search_field)
                    )
                })
            } else {
                return this.privilege_group_actions_assigned
            }
        }
    },

    watch: {
        checkedRowsAvailable(value){
            console.log(value)
        }
    }
}

</script>
<template>
    <div class="card">
        <div class="card-content">
            <div class="columns">
                <div class="column is-5">
                    <div class="card">
                        <div class="card-content">
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

                            <b-table
                                :data="filteredControllersAvailable"
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
                                        <b-checkbox :native-value="{controller: props.row.controller, value: 'all', ids: props.row.actions.map(e => {return e.id})}" v-model="checkedRowsAvailable"></b-checkbox>
                                    </b-table-column>
                                </template>

                                <template slot="detail" slot-scope="props">
                                    <tr v-for="(item, index) in props.row.actions" :key="`${item.name}-${index}`">
                                        <td></td>
                                        <td> {{ item.name }} </td>
                                        <td v-if="checkedRowsAvailable.find(e => e.controller === props.row.controller && e.value === item.id)">
                                            <b-checkbox disabled :value="true">
                                            </b-checkbox>
                                        </td>
                                        <td v-else>
                                            <b-checkbox :native-value="{controller: props.row.controller, value: item.name, id: item.id}" v-model="checkedRowsAvailable" >
                                            </b-checkbox></td>
                                        </td>
                                    </tr>
                                </template>
                            </b-table>
                        </div>
                    </div>
                </div>
                <div class="column is-vcentered is-offset-1">
                    <b-button class="is-centered" @click.stop="removeActions" :disabled="checkedRowsAssigned.length === 0" type="is-primary"><<</b-button>
                    <br>
                    <br>
                    <b-button class="is-centered" @click.stop="addActionos" :disabled="checkedRowsAvailable.length === 0" type="is-primary">>></b-button>
                </div>
                <div class="column is-5">
                    <div class="card">
                        <div class="card-content">
                            <b-field>
                                <b-input
                                    :placeholder="translations.core.view_toolbar_filter_placeholder_search"
                                    v-model="filters.search_controllers_assigned"
                                    type="text"
                                    icon="search"
                                    icon-right="close-circle"
                                    icon-right-clickable
                                    @icon-right-click="filters.search_controllers_assigned = ''">
                                </b-input>
                            </b-field>

                            <b-table
                                :data="filteredControllersAssigned"
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
                                        <b-checkbox :native-value="{controller: props.row.controller, value: 'all'}" v-model="checkedRowsAssigned"></b-checkbox>
                                    </b-table-column>
                                </template>

                                <template slot="detail" slot-scope="props">
                                    <tr v-for="(item, index) in props.row.actions" :key="`${item.name}-${index}`">
                                        <td></td>
                                        <td> {{ item.name }} </td>
                                        <td v-if="checkedRowsAssigned.find(e => e.controller === props.row.controller && e.value === 'all')">
                                            <b-checkbox disabled :value="true">
                                            </b-checkbox>
                                        </td>
                                        <td v-else>
                                            <b-checkbox :native-value="{controller: props.row.controller, value: item.name}" v-model="checkedRowsAssigned" >
                                            </b-checkbox></td>
                                        </td>
                                    </tr>
                                </template>
                            </b-table>
                        </div>
                    </div>
                </div>
            </div>
        </div>
    </div>
</template>