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
import componentForm from '../components/form.vue'

export default {

    components: {
        'component-form': componentForm
    },

    data(){
        return {
            role: {
                detail_attributes: {}
            },
            role_id: null,
            translations: {
                core: {
                    shared: I18n.t('core.shared'),
                    roles: I18n.t('core.roles'),
                }
            }
        }
    },

    mounted(){
        this.setRole()
        this.getRole()
    },

    methods: {
        // @return [void]
        // @description Retrieves the id of the ExernalLeadss and stores it in the data variable role_id
        // @example
        //      console.log(this.role_id) // will display null
        //      this.setRole()
        //      console.log(this.role_id) // will display a number, like 5
        setRole(){
            this.role_id = this.$route.params.id
        },

        // @return [void]
        // @description Connects to the backend using HTTP and retrieves the ExernalLeadss associated to
        //      the variable *ExernalLeadss_id*. If the HTTP request fails, an error message is shown
        // @example
        //      console.log(this.role) // will display null
        //      this.getRole()
        //      console.log(this.role) // will display an object representation of the ExernalLeadss
        getRole(){
            this.http.get(this.url.admin("roles/:id", { id: this.role_id })).then(result => {
                if (result.successful) {
                    this.role = result.data
                }else{
                    this.msg.error(result.error.message)
                }
            }).catch(error => {
                console.log(error)
            })
        }
    }
}
</script>

<template>
    <section class="application-component">
        <component-header :title="translations.core.roles.view_title_edit_role + ': ' + role.name">
            <div class="buttons">
                <router-link class="button" tag="button" to="/">
                    <span class="icon">
                        <i class="fas fa-list"></i>
                    </span>
                    <span>{{ translations.core.shared.view_btn_list }}</span>
                </router-link>
            </div>
        </component-header>
        <component-form :role="role" :edit="true">
        </component-form>
    </section>
</template>
