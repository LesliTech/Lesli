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
    props: {
        user: {}
    },
    data() {
        return {
            options: {}
        }
    },
    methods: {
        putUser() {
            this.http.put(`/users/${this.user.id}.json`, {
                user: this.user
            }).then(result => {
                console.log(result)
            }).catch(error => {

            })
        }
    }

}
</script>

<template>
    <form @submit.prevent="putUser()">
        <div class="column is-half">
            <div class="field">
                <label class="label">Anrede</label>
                <label class="b-radio radio">
                    <input v-model="user.detail_attributes.salutation" type="radio" value="mr">
                    <span class="check is-info"></span>
                    <span class="control-label">
                        Herrn
                    </span>
                </label>
                <label class="b-radio radio">
                    <input v-model="user.detail_attributes.salutation" type="radio" value="mrs">
                    <span class="check is-info"></span>
                    <span class="control-label">
                        Frau
                    </span>
                </label>
            </div>
            <div class="field">
                <label class="label">Vorname</label> 
                <div class="control">
                    <input v-model="user.detail_attributes.first_name" required="required" type="text" class="input">
                </div>
            </div>
            <div class="field">
                <label class="label">Name</label> 
                <div class="control">
                    <input v-model="user.detail_attributes.last_name" required="required" class="input">
                </div>
            </div>
            <div class="field">
                <label class="label">Titel</label> 
                <div class="control">
                    <input v-model="user.detail_attributes.title" class="input">
                </div>
            </div>
            <div class="field">
                <label class="label">Telefon</label> 
                <div class="control">
                    <input v-model="user.detail_attributes.telephone" class="input">
                </div>
            </div>

            <p class="control">
                <button class="button is-primary">Speichern</button>
            </p>
        </div>
    </form>
</template>
