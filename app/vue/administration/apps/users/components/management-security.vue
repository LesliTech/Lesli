<script setup>
/*

Copyright (c) 2023, all rights reserved.

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


// · import lesli stores
import { useUser } from "LesliApp/administration/stores/user"


// · implement stores
const storeUser = useUser()


// · translations
const translations = {
    users: I18n.t("core.users"),
    shared: I18n.t("core.shared")
}


</script>
<template>
    <div>
        <fieldset class="mb-4">
            <legend>Force the user to change the password</legend>
            <lesli-button
                primary
                outlined
                icon="lock_reset"
                @click="storeUser.doRequestPasswordChange">
                {{ translations.users.view_btn_request_password_change }}
            </lesli-button>
        </fieldset>

        <fieldset class="mb-4">
            <button class="button is-link is-light is-outlined" @click="storeUser.doPasswordReset">
                <span class="icon">
                    <span class="material-icons">
                        key
                    </span>
                </span>
                <span>{{ translations.users.view_btn_password_reset || "Password request" }}</span>
            </button>
        </fieldset>

        <fieldset class="mb-4">
            <button class="button is-link is-light is-outlined" @click="storeUser.doLogout">
                <span class="icon">
                    <span class="material-icons">
                        logout
                    </span>
                </span>
                <span>{{ translations.users.view_btn_logout }}</span>
            </button>
        </fieldset>

        <hr />

        <fieldset class="mb-4">
            <button class="button is-danger is-light is-outlined" @click="storeUser.doRevokeAccess">
                <span class="icon">
                    <span class="material-icons">
                        lock_outline
                    </span>
                </span>
                <span>{{ translations.users.view_btn_revoke_access }}</span>
            </button>
        </fieldset>

        <fieldset class="mb-4">
            <button class="button is-danger is-light is-outlined" @click="storeUser.markUserAsDeleted">
                <span class="icon">
                    <span class="material-icons">
                        delete_forever
                    </span>
                </span>
                <span>{{ translations.users.view_btn_delete_user }}</span>
            </button>
        </fieldset>
    </div>
</template>
<style scoped>
    fieldset {
        padding: 1.6rem;
        border: 1px solid #ccc;
        border-radius: 4px;
    }
    legend {
        color: #555;
    }
</style>
