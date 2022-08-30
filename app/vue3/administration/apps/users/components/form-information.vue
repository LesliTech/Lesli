<script setup>
/*
Copyright (c) 2022, all rights reserved.

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


// · import vue tools
import { inject, onMounted, ref } from "vue"

// · import lesli stores
import { useUser } from "LesliVue/stores/user"

// · import vue router composable
import { useRouter } from "vue-router"

// · implement stores
const storeUser = useUser()

// · initialize/inject plugins
const router = useRouter()
const url = inject("url")

// · defining props
const props = defineProps({
    isEditable: {
        type: Boolean,
        required: false,
        default: false,
    },
})

// · 
const translations = {
    users: I18n.t("core.users"),
    shared: I18n.t("core.shared")
}

const options = {}

/**
 * @description This function is used to update the user information
 */
const onUpdate = () => {
    storeUser.updateInformation()
}

/**
 * @description This function is used to create a new user
 */
const onCreate = () => {
    storeUser.newUser()
    router.push(url.admin('users').toString())
}

const userRole = ref({ label:"", value:"" })

function updateRole(){
    storeUser.user.roles_id = userRole.value.value
}

onMounted(() => {
    storeUser.getOptions()
})

</script>
<template>
    <form class="information" @submit.prevent="
            isEditable
                ? onUpdate()
                : onCreate()
    ">

        <div class="field is-horizontal">
            <div class="field-label is-normal">
                <label class="label"> {{translations.shared.view_text_email}} </label>
            </div>
            <div class="field-body">
                <div class="field">
                    <div class="control">
                        <input v-model="storeUser.user.email" required="required" type="text" class="input">
                    </div>
                </div>
            </div>
        </div>

        <div class="field is-horizontal">
            <div class="field-label is-normal">
                <label class="label"> {{ translations.shared.view_text_first_name }} </label>
            </div>
            <div class="field-body">
                <div class="field">
                    <div class="control">
                        <input v-model="storeUser.user.detail_attributes.first_name" required="required" type="text" class="input">
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
                        <input v-model="storeUser.user.detail_attributes.last_name" required="required" class="input">
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
                        <input v-model="storeUser.user.alias" class="input">
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
                        <input v-model="storeUser.user.detail_attributes.telephone" class="input">
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
                        <input v-model="storeUser.user.detail_attributes.title" class="input">
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
                                :options="storeUser.options.roles"
                                v-model="userRole"
                                @change="updateRole"
                            >
                            </lesli-select>
                        </div>
                    </div>
                </div>
            </div>
        </div>

        <div class="field is-horizontal">
            <div class="field-label">
                <label class="label"> {{ translations.shared.view_text_salutation}} </label>
            </div>
            <div class="field-body">
                <div class="field is-narrow">
                    <div class="control">
                        <label :for="salutation.value" class="radio" v-for="salutation in storeUser.options.salutations" :key="salutation">
                            <input type="radio" :id="salutation.value" :value="salutation.value" v-model="storeUser.user.detail_attributes.salutation" />
                            {{salutation.text}}
                        </label>  
                    </div>
                </div>
            </div>
        </div>

        <div class="field is-grouped is-grouped-centered">
            <div class="control">
                <lesli-button icon="save">
                    {{ translations.shared.view_btn_save }}
                </lesli-button>
            </div>
        </div>

    </form>

</template>
