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

Lesli · Your Smart Business Assistant. 

Made with ♥ by https://www.lesli.tech
Building a better future, one line of code at a time.

@contact  hello@lesli.tech
@website  https://lesli.tech
@license  GPLv3 http://www.gnu.org/licenses/gpl-3.0.en.html

// · ~·~     ~·~     ~·~     ~·~     ~·~     ~·~     ~·~     ~·~     ~·~     ~·~     ~·~     ~·~
// · 

*/



// · import vue tools
import { onMounted, inject } from "vue"


// · import lesli stores
import { useUser } from "LesliApp/administration/stores/user"


// · import vue router composable
import { useRouter, useRoute } from "vue-router"


// · implement stores
const storeUser = useUser()


// · initialize/inject plugins
const router = useRouter()
const route = useRoute()
const url = inject("url")


// · 
const translations = {
    users: I18n.t("core.users"),
    shared: I18n.t("core.shared")
}

</script>
<template>
    <form class="information" @submit.prevent="storeUser.putUser()">
        <div class="field is-horizontal">
            <div class="field-label">
                <label class="label"> {{ translations.shared.view_text_salutation}} </label>
            </div>
            <div class="field-body">
                <div class="field is-narrow">
                    <div class="control">
                        <label :for="salutation.value" class="radio" v-for="salutation in storeUser.options.salutations" :key="salutation">
                            <input name="user_salutation" type="radio" :id="salutation.value" :value="salutation.value" v-model="storeUser.user.detail_attributes.salutation" />
                            {{salutation.text}}
                        </label>  
                    </div>
                </div>
            </div>
        </div>

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
                        <input name="user_email" v-model="storeUser.user.email" required="required" type="email" class="input">
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
                        <input name="first_name" v-model="storeUser.user.first_name" type="text" class="input">
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
                        <input name="last_name" v-model="storeUser.user.last_name" class="input">
                    </div>
                </div>
            </div>
        </div>

        <div class="field is-horizontal">
            <div class="field-label is-normal">
                <label class="label"> {{ translations.shared.view_text_alias }} </label>
            </div>
            <div class="field-body">
                <div class="field">
                    <div class="control">
                        <input name="user_alias" v-model="storeUser.user.alias" class="input">
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
                        <input name="user_number" v-model="storeUser.user.telephone" class="input">
                    </div>
                </div>
            </div>
        </div>

        <div class="field is-horizontal">
            <div class="field-label is-normal">
                <label class="label"> {{ translations.users.view_text_title }} </label>
            </div>
            <div class="field-body">
                <div class="field">
                    <div class="control">
                        <input name="user_title" v-model="storeUser.user.detail_attributes.title" class="input">
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
    </form>
</template>
