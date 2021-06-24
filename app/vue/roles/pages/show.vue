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
import componentForm from '../components/forms/form.vue'
import componentFormSimple from '../components/forms/form-simple.vue'
import componentFormAdvanced from '../components/forms/form-advanced.vue'
import componentFormLogs from '../components/forms/form-logs.vue'
// · 
// · ~·~     ~·~     ~·~     ~·~     ~·~     ~·~     ~·~     ~·~     ~·~     ~·~     ~·~     ~·~


export default {
    props: {

    },
    
    components: {
        'component-form': componentForm,
        'component-form-simple': componentFormSimple,
        'component-form-advanced': componentFormAdvanced,
        'component-form-logs': componentFormLogs,
    },

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
            }
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
                this.$set(this.data, 'view_type', this.$route.query.view_type)
            } else {
                this.$set(this.data, 'view_type', 'simple')
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
        <component-form 
            v-if="role.id && data.view_type === 'edit'"
            :role="role"
        >
        </component-form>
        <component-form-logs
            v-if="role.id && data.view_type === 'logs'"
            :role="role"
        >
        </component-form-logs>
        <component-form-simple 
            v-if="role.id && data.view_type === 'simple'" 
            :role="role" 
        >
        </component-form-simple>
        <component-form-advanced
            v-if="role.id && data.view_type === 'advanced'" 
            :role="role" 
        >
        </component-form-advanced>
    </section>
</template>
