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
import componentSecurityForm from "Lesli/vue/users/components/form-security.vue"
import componentInformationCard from "Lesli/vue/users/components/card-information.vue"
import componentInformationForm from "Lesli/vue/users/components/form-information.vue"
import componentRolesPrivilegesForm from "Lesli/vue/users/components/form-roles-privileges.vue"
import componentAccessManagementForm from "Lesli/vue/users/components/form-access-management.vue"
import componentSessionManagement from "Lesli/vue/users/components/session-management.vue"



// · 
export default {
    components: {
        "component-security-form": componentSecurityForm,
        "component-information-card": componentInformationCard,
        "component-information-form": componentInformationForm,
        "component-roles-privileges-form": componentRolesPrivilegesForm,
        "component-access-management-form": componentAccessManagementForm,
        'component-session-management': componentSessionManagement,
    },
    data() {
        return {
            user_id: null,
            active: 0,
            user: {
                detail_attributes: {}
            },
            options: [],
            ready: false,
            translations: {
                core: {
                    users: I18n.t("core.users"),
                    shared: I18n.t("core.shared")
                }
            },
        }
    },
    mounted() {
        this.user_id = this.$route.params.id
        this.getUser()
        this.getOptions()
    },
    methods: {
        getUser() {
            this.http.get(`/administration/users/${this.user_id}.json`).then(result => {
                if (result.successful) {
                    this.data.user = result.data
                }else{
                    this.alert(result.error.message,"danger")
                }
            }).catch(error => {
                console.log(error)
            })
        },
        getOptions(){
            this.http.get("/administration/users/options.json").then(result => {
                if (result.successful) {
                    this.data.options = result.data
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
        <component-information-card></component-information-card>
        <b-tabs v-model="active">
            <b-tab-item :label="translations.core.users.view_tab_title_information">
                <component-information-form></component-information-form>
            </b-tab-item>
            <b-tab-item :label="translations.core.users.view_tab_title_security" :disabled="user.editable_security">
                <component-security-form></component-security-form>
            </b-tab-item>
            <b-tab-item :label="translations.core.users.view_tab_title_access_management">
                <component-access-management-form></component-access-management-form>
            </b-tab-item>
            <b-tab-item :label="translations.core.users.view_tab_title_roles_and_privileges">
                <component-roles-privileges-form></component-roles-privileges-form>
            </b-tab-item>
            <b-tab-item label="Session Management">
                <component-session-management v-if="user_id" :user_id="user_id"></component-session-management>
            </b-tab-item>
        </b-tabs>
    </section>
</template>
