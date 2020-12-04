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
import componentInformationCard from "Lesli/vue/users/components/card-information.vue"
import componentInformationForm from "Lesli/vue/users/components/form-information.vue"
import componentSecurityForm from "Lesli/vue/users/components/form-security.vue"
import componentForm from "../components/form-new.vue"


// · 
export default {
    components: {
        'component-information-card': componentInformationCard,
        'component-information-form': componentInformationForm,
        'component-security-form': componentSecurityForm,
        'component-form': componentForm
    },
    data() {
        return {
            user_id: null,
            user: {
                detail_attributes: {}
            },
            options: [],
            ready: false,
            translations: {
                core: {
                    users: I18n.t('deutscheleibrenten.users'),
                    shared: I18n.t('deutscheleibrenten.shared')
                }
            },
        }
    },
    mounted() {
        this.data.user = this.user
        this.getOptions()
    },
    methods: {

        getOptions() {
            this.http.get("/administration/users/options.json").then(result => {
                this.data.options = result.data
                /*
                if (result.successful) {
                    this.options = result.data
                    let user_role = this.options.roles.find(e => e.value === this.user.roles_id)
                    this.options.roles = this.options.roles.filter(e => 
                        (
                            (e.text !== 'api' &&
                            e.text !== 'guest' &&
                            e.text !== 'callcenter' && 
                            e.text !== 'kop' &&
                            e.text !== 'owner' &&
                            e.text !== 'limited') ||
                            e.text == user_role.text
                        )
                    )
                    this.store.data.options = this.options
                    this.ready = true
                }
                */
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
        <component-form></component-form>
    </section>
</template>
