<script setup>
/*
Lesli

Copyright (c) 2023, Lesli Technologies, S. A.

This program is free software: you can redistribute it and/or modify
it under the terms of the GNU General Public License as published by
the Free Software Foundation, either version 3 of the License, or
(at your option) any later version.

This program is distributed in the hope that it will be useful,
but WITHOUT ANY WARRANTY; without even the implied warranty of
MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the
GNU General Public License for more details.

You should have received a copy of the GNU General Public License
along with this program. If not, see http://www.gnu.org/licenses/.

Lesli · Ruby on Rails Development Platform.

Made with ♥ by https://www.lesli.tech
Building a better future, one line of code at a time.

@contact  hello@lesli.tech
@website  https://www.lesli.tech
@license  GPLv3 http://www.gnu.org/licenses/gpl-3.0.en.html

// · ~·~     ~·~     ~·~     ~·~     ~·~     ~·~     ~·~     ~·~     ~·~     ~·~     ~·~     ~·~
// · 
*/


// · import vue tools
import { onMounted, inject } from "vue"
import { useRouter, useRoute } from 'vue-router'


// · import lesli stores
import { useUsers } from "LesliAdmin/stores/users"
import { useRoles } from "LesliAdmin/stores/roles"


// · implement stores
const storeUsers = useUsers()
const storeRoles = useRoles()
const router = useRouter()
const route = useRoute()


// · implement composables
const url = inject("url")
const msg = inject("msg")


// · translations
const translations = {
    users: I18n.t("core.users"),
    shared: I18n.t("core.shared")
}


// · 
const onCreate = () => {
    storeUsers.postUsers().then(result => {
        storeUsers.user = {}
        msg.success(I18n.t("core.users.messages_success_operation"))
        router.push(url.admin("users/:id", result.id).toString())
    }).catch(error => {
        msg.danger(I18n.t("core.shared.messages_danger_internal_error"))
    })
}


// · 
onMounted(() => {
    console.log("works")
    storeRoles.fetchList()
})
</script>
<template>
    <lesli-application>
        <lesli-header title="Create User">
            <lesli-button icon="list" :to="url.admin('users')">
                All users
            </lesli-button>
        </lesli-header>

        <lesli-form @submit="onCreate()">
            <p>User information</p>
            <div class="field is-horizontal">
                <div class="field-label is-normal">
                    <label class="label"> 
                        {{translations.shared.view_text_email}}
                        <span class="is-danger">*</span>
                    </label>
                </div>
                <div class="field-body">
                    <div class="field">
                        <div class="control">
                            <input name="user_email" v-model="storeUsers.user.email" required="required" type="email" class="input">
                        </div>
                    </div>
                </div>
            </div>

            <div class="field is-horizontal">
                <div class="field-label is-normal">
                    <label class="label"> 
                        {{ translations.shared.view_text_first_name }}
                    </label>
                </div>
                <div class="field-body">
                    <div class="field">
                        <div class="control">
                            <input name="first_name" v-model="storeUsers.user.first_name" type="text" class="input">
                        </div>
                    </div>
                </div>
            </div>

            <div class="field is-horizontal">
                <div class="field-label is-normal">
                    <label class="label"> {{ translations.shared.view_text_last_name }} </label>
                </div>
                <div class="field-body">
                    <div class="field">
                        <div class="control">
                            <input name="last_name" v-model="storeUsers.user.last_name" class="input">
                        </div>
                    </div>
                </div>
            </div>

            <div class="field is-horizontal">
                <div class="field-label is-normal">
                    <label class="label"> {{ translations.shared.view_text_telephone }} </label>
                </div>
                <div class="field-body">
                    <div class="field">
                        <div class="control">
                            <input name="user_number" v-model="storeUsers.user.telephone" class="input">
                        </div>
                    </div>
                </div>
            </div>

            <div class="field is-horizontal">
                <div class="field-label is-normal">
                    <label class="label"> {{ translations.users.view_text_role }} </label>
                </div>
                <div class="field-body">
                    <div class="field is-narrow">
                        <div class="control">
                            <div class="select is-fullwidth">
                                <lesli-select
                                    :options="storeRoles.listOptions"
                                    v-model="storeUsers.user.roles_id">
                                </lesli-select>
                            </div>
                        </div>
                    </div>
                </div>
            </div>

            <div class="field is-horizontal">
                <div class="field-label is-normal">
                </div>
                <div class="field-body">
                    <div class="field">
                        <div class="control">
                            <lesli-button icon="save">
                                {{ translations.shared.view_btn_save }}
                            </lesli-button>                 
                        </div>
                    </div>
                </div>
            </div>
        </lesli-form>
    </lesli-application>
</template>
