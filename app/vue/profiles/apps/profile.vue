<script>
/**
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
import componentInformationCard from "Lesli/vue/users/components/card-information.vue"
import componentInformationForm from "Lesli/vue/users/components/form-information.vue"
import componentSecurityForm from "Lesli/vue/users/components/form-security.vue"


// · 
export default {
    components: {
        'component-information-card': componentInformationCard,
        'component-information-form': componentInformationForm,
        'component-security-form': componentSecurityForm
    },
    data() {
        return {
            user_id: null,
            user: {
                detail_attributes: {}
            },
            options: [],
            ready: false,
            active_tab: 0,
            translations: {
                core: {
                    users: I18n.t('core.users'),
                    shared: I18n.t('core.shared')
                }
            },
        }
    },
    mounted() {
        this.user_id = this.lesli.current_user.id
        this.getUser()
        this.getOptions()
        if (this.$route.hash == "#security") {
            this.active_tab = 1
        }
    },
    methods: {

        getUser() {
            this.http.get("/administration/profile.json").then(result => {
                if (!result.successful) {
                    this.alert(result.error.message,'danger')
                    return
                }
                this.data.user = result.data
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
        <component-information-card :actions="false"></component-information-card>
        <b-tabs v-model="active_tab">
            <b-tab-item :label="translations.core.users.view_tab_title_information">
                <component-information-form></component-information-form>
            </b-tab-item>
            <b-tab-item :label="translations.core.users.view_tab_title_security">
                <component-security-form></component-security-form>
            </b-tab-item>
        </b-tabs>
    </section>
</template>
