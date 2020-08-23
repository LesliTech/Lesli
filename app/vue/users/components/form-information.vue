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
export default {
    data() {
        return {
            translations: {
                users: I18n.t('core.users'),
                shared: I18n.t('core.shared')
            },
            options: {},
            user: {
                detail_attributes: {}
            }
        }
    },
    methods: {
        putUser() {
            this.http.put(`/users/${this.user.id}.json`, {
                user: this.user
            }).then(result => {
                if (result.successful) {
                    this.alert(this.translations.users.notification_user_updated, 'success')
                }else{
                    this.alert(result.error.message,'danger')
                }
            }).catch(error => {
                console.log(error)
            })
        }
    },
    watch: {
        "store.data.user": function(user) {
            this.user = user
        },
        "store.data.options": function(data) {
            this.options = data
        }
    }
}
</script>

<template>
    <form @submit.prevent="putUser()">
        <fieldset>
            <div class="column is-half">
                <div class="field">
                    <label class="label">
                        {{ translations.shared.text_salutation }}
                    </label>
                    <b-radio
                        v-for="option in options.salutations"
                        :key="option.value"
                        v-model="user.detail_attributes.salutation"
                        type="is-info"
                        :native-value="option.value">
                        {{ translations.shared[`salutation_${option.text}`] }}
                    </b-radio>
                </div>
                <div class="field">
                    <label class="label"> {{ translations.shared.text_first_name}} </label> 
                    <div class="control">
                        <input v-model="user.detail_attributes.first_name" required="required" type="text" class="input">
                    </div>
                </div>
                <div class="field">
                    <label class="label"> {{ translations.shared.text_last_name }} </label> 
                    <div class="control">
                        <input v-model="user.detail_attributes.last_name" required="required" class="input">
                    </div>
                </div>
                <div class="field">
                    <label class="label"> {{ translations.shared.text_title }} </label> 
                    <div class="control">
                        <input v-model="user.detail_attributes.title" class="input">
                    </div>
                </div>
                <div class="field">
                    <label class="label"> {{ translations.shared.text_telephone }} </label> 
                    <div class="control">
                        <input v-model="user.detail_attributes.telephone" class="input">
                    </div>
                </div>
                <p class="control">
                    <button class="button is-primary">{{ translations.shared.btn_save }}</button>
                </p>
            </div>
        </fieldset>
    </form>
</template>
