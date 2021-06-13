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


// · List of Imported Components
// · ~·~     ~·~     ~·~     ~·~     ~·~     ~·~     ~·~     ~·~     ~·~     ~·~     ~·~     ~·~
import componentFormNormal from '../components/forms/form-normal.vue'
import componentLogs from '../components/logs.vue'
// · 
// · ~·~     ~·~     ~·~     ~·~     ~·~     ~·~     ~·~     ~·~     ~·~     ~·~     ~·~     ~·~


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
            modal:{
                active: false
            },
            translations: {
                roles: I18n.t('deutscheleibrenten.roles'),
                shared: I18n.t('deutscheleibrenten.shared'),
                users: I18n.t('deutscheleibrenten.users')
            },
            view_type: 'show',
        }
    },
    
    mounted(){
        this.setRole()
        this.setViewType()
        this.getRole()
    },

    methods: {
        setRole(){
            this.role_id = this.$route.params.id
        },

        setViewType(){
            if (this.$route.query.view_type) {
                this.view_type = this.$route.query.view_type
            }
        },

        getRole(){
            let url = `${this.main_route}/${this.role_id}.json`
            this.http.get(url).then(result => {
                if (result.successful) {
                    this.role = result.data
                }else{
                    this.alert(result.error.message, 'danger')
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
        <component-logs
            v-if="role.id && view_type === 'logs'"
            :role="role"  
        >
        </component-logs>
        <component-form-normal 
            v-else-if="role.id" 
            :role="role" 
            :translations="translations">
        </component-form-normal>
    </section>
</template>
