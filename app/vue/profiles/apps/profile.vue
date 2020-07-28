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
import componentInformationCard from "../components/card-information.vue"
import componentInformationForm from "../components/form-information.vue"
import componentSecurityForm from "../components/form-security.vue"


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
            options: null,
            ready: false,
            user: {
                detail_attributes: {}
            },
            translations: {
                users: I18n.t('core.users'),
                shared: I18n.t('core.shared')
            },
        }
    },
    mounted() {
        this.user_id = lesli.current_user.id
        this.getUser()
    },
    methods: {
        getUser() {
            this.http.get(`/users/${this.user_id}.json`).then(result => {
                if (result.successful) {
                    this.user = result.data
                    this.getOptions()
                }else{
                    this.alert(result.error.message,'danger')
                }
            }).catch(error => {
                console.log(error)
            })
        },

        getOptions(){
            let url = `/users/options.json`

            this.http.get(url).then(result => {
                if (result.successful) {
                    this.options = result.data
                    this.ready = true
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
            <b-tab-item :label="translations.users.tab_information">
                <component-information-form v-if="user && ready" :user="user" :options="options"></component-information-form>
            </b-tab-item>
            <b-tab-item :label="translations.users.tab_security" v-if="user.is_editable">
                <component-security-form v-if="user && ready" :user="user" :options="options"></component-security-form>
            </b-tab-item>
        </b-tabs>
    </section>
</template>
