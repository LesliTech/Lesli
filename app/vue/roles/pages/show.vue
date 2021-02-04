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
import componentLogs from '../components/logs.vue'
import componentFormNormal from '../components/forms/form-normal.vue'


// · 
export default {
    props: {

    },
    
    components: {
        'component-form-normal': componentFormNormal,
        'component-logs': componentLogs,
    },

    // @return [Object] Data used by this component's methods
    // @description Returns the data needed for this component to work properly
    // @data_variable main_route [String] the main route to which this component connects to the lesli API
    // @data_variable role [Object] An object representing a Role, with
    //      the same params as the associated rails model
    // @data_variable role_id [String|Integer] The id of the Role, as
    //      obtained from the route using the *Vue-router* *params* 
    data(){
        return {
            main_route: '/administration/roles',
            role_id: null,
            role: {},
            privileges: {},
            modal:{
                active: false
            },
            translations: {
                roles: I18n.t('deutscheleibrenten.roles'),
                shared: I18n.t('deutscheleibrenten.shared'),
                users: I18n.t('deutscheleibrenten.users')
            },
            view_type: 'show',
            role_ready: false,
            ready: false
        }
    },

    // @return [void]
    // @description Executes the necessary methods needed to initialize this component
    mounted(){
        this.setRole()
        this.setViewType()
        this.getRole()
        this.getPrivileges()
    },

    methods: {

        // @return [void]
        // @description Retrieves the id of the Role and stores it in the data variable role_id
        // @example
        //      console.log(this.role_id) // will display null
        //      this.setRole()
        //      console.log(this.role_id) // will display a number, like 5
        setRole(){
            this.role_id = this.$route.params.id
        },

        // @return [void]
        // @description overrides the view_type for render the component
        // @example
        //      console.log(this.role_id) // will display a string, like "logs"
        setViewType(){
            if (this.$route.query.view_type) {
                this.view_type = this.$route.query.view_type
            }
        },

        // @return [void]
        // @description Connects to the backend using HTTP and retrieves the Role associated to
        //      the variable *Role_id*. If the HTTP request fails, an error message is shown
        // @example
        //      console.log(this.role) // will display null
        //      this.getRole()
        //      console.log(this.role) // will display an object representation of the Role
        getRole(){
            let url = `${this.main_route}/${this.role_id}.json`
            this.http.get(url).then(result => {
                if (result.successful) {
                    this.role = result.data
                    this.role_ready = true
                }else{
                    this.alert(result.error.message, 'danger')
                }
            }).catch(error => {
                console.log(error)
            })
        },

        getPrivileges() {
            this.http.get(`${this.main_route}/${this.role_id}/privileges.json`).then(result => {
                if (result.successful) {
                    let privileges = result.data
                    for (let privilege of privileges) {
                        let actions = []

                        if (privilege.grant_create) actions.push("create")
                        if (privilege.grant_destroy) actions.push("destroy")
                        if (privilege.grant_edit) actions.push("edit")
                        if (privilege.grant_index) actions.push("index")
                        if (privilege.grant_new) actions.push("new")
                        if (privilege.grant_options) actions.push("options")
                        if (privilege.grant_resources) actions.push("resources")
                        if (privilege.grant_search) actions.push("search")
                        if (privilege.grant_show) actions.push("show")
                        if (privilege.grant_update) actions.push("update")
                        if (privilege.grant_list) actions.push("list")

                        this.privileges[privilege.grant_object] = {
                            ...privilege,
                            actions: actions
                        }
                    }

                    this.ready = true
                }
            }).catch(error => {
                console.log(error)
            })
        },

        confirmDialogRestore() {
            this.$buefy.dialog.confirm({
                title: this.translations.roles.dialog_configuration_title,
                message: this.translations.shared.dialog_confirm_question + ' <b>' + this.translations.roles.dialog_confirm_restore_configuration_message + '</b>?',
                confirmText: this.translations.roles.dialog_confirm_restore_configuration,
                type: 'is-warning',
                hasIcon: true,
                onConfirm: () => this.restoreDefaultConfiguration()
            })
        },

        confirmDialogSet() {
            this.$buefy.dialog.confirm({
                title: this.translations.roles.dialog_configuration_title,
                message: this.translations.shared.dialog_confirm_question + ' <b>' + this.translations.roles.dialog_confirm_set_configuration_message + '</b>?',
                confirmText: this.translations.roles.dialog_confirm_set_configuration,
                type: 'is-warning',
                hasIcon: true,
                onConfirm: () => this.setDefaultConfiguration()
            })
        }
    }
}
</script>
<template>
    <section class="application-component">
        <component-form-normal 
            v-if="role.id && ready" 
            :role="role" 
            :privileges="privileges" 
            :translations="translations">
        </component-form-normal>
    </section>
</template>
