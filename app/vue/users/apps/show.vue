<script>
/**
Lesli

Copyright (c) 2020, Lesli Technologies, S. A.

All the information provided by this website is protected by laws of Guatemala related 
to industrial property, intellectual property, copyright and relative international laws. 
Lesli Technologies, S. A. is the exclusive owner of all intellectual or industrial property
rights of the code, texts, trade mark, design, pictures and any other information.
Without the written permission of Lesli Technologies, S. A., any replication, modification,
transmission, publication is strictly forbidden.
For more information read the license file including with this software.

Lesli - Your Smart Business Assistant

Powered by https://www.lesli.tech
Building a better future, one line of code at a time.

@contact  <hello@lesli.tech>
@website  <https://lesli.tech>
@license  Propietary - all rights reserved.

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
            translations: {
                core: {
                    users: I18n.t('deutscheleibrenten.users'),
                    shared: I18n.t('deutscheleibrenten.shared')
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
            this.http.get(`/users/${this.user_id}.json`).then(result => {
                if (result.successful) {
                    this.user = result.data
                    this.store.data.user = result.data
                }else{
                    this.alert(result.error.message,'danger')
                }
            }).catch(error => {
                console.log(error)
            })
        },
        getOptions(){
            this.http.get('/users/options.json').then(result => {
                if (result.successful) {
                    /*
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
                    */
                    this.store.data.options = result.data
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
        <component-information-card :user="user"></component-information-card>
        <b-tabs>
            <b-tab-item :label="translations.core.users.tab_information">
                <component-information-form></component-information-form>
            </b-tab-item>
            <b-tab-item :label="translations.core.users.tab_security">
                <component-security-form></component-security-form>
            </b-tab-item>
        </b-tabs>
    </section>
</template>
