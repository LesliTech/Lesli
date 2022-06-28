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
import { ref, reactive, onMounted, watch, computed } from "vue"


// · import lesli stores
import { useUser } from "LesliVue/stores/user"


// · implement stores
const storeUser = useUser()


// · 
const translations = {
    users: I18n.t("core.users"),
    shared: I18n.t("core.shared")
}

const options = {}

</script>
<template>
    <form class="information" @submit.prevent="storeUser.updateInformation">
        <div class="field">
            <label class="label"> {{ translations.shared.view_text_first_name }} </label>
            <div class="control">
                <input v-model="storeUser.user.detail_attributes.first_name" required="required" type="text" class="input">
            </div>
        </div>
        <div class="field">
            <label class="label"> {{ translations.shared.view_text_last_name }} </label>
            <div class="control">
                <input v-model="storeUser.user.detail_attributes.last_name" required="required" class="input">
            </div>
        </div>
        <div class="field">
            <label class="label"> {{ translations.shared.view_text_alias }} </label>
            <div class="control">
                <input v-model="storeUser.user.alias" class="input">
            </div>
        </div>
        <div class="field">
            <label class="label"> {{ translations.users.view_text_title }} </label>
            <div class="control">
                <input v-model="storeUser.user.detail_attributes.title" class="input">
            </div>
        </div>
        <div class="field">
            <label class="label"> {{ translations.shared.view_text_telephone }} </label>
            <div class="control">
                <input v-model="storeUser.user.detail_attributes.telephone" class="input">
            </div>
        </div>
        <p class="control">
            <button type="submit" class="button is-primary">{{ translations.shared.view_btn_save }}</button>
        </p>
    </form>
</template>
