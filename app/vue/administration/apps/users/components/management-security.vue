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
                icon="lock_reset"
                @click="storeUser.doRequestPassword">
                {{ translations.users.view_btn_request_password || "Request password" }}
            </lesli-button>
        </fieldset>

        <fieldset class="mb-4">
            <legend>Generate a new password for the user</legend>
            <lesli-button
                icon="key"
                @click="storeUser.doPasswordReset">
                {{ translations.users.view_btn_password_reset || "Password reset" }}
            </lesli-button>
        </fieldset>

        <fieldset class="mb-4">
            <legend>Close all the active sessions of the user</legend>
            <lesli-button
                icon="logout"
                @click="storeUser.doLogout">
                {{ translations.users.view_btn_logout }}
            </lesli-button>
        </fieldset>

        <fieldset class="mb-4">
            <legend>Remove all user access</legend>
            <lesli-button
                danger
                icon="lock_outline"
                @click="storeUser.doRevokeAccess">
                {{ translations.users.view_btn_revoke_access }}
            </lesli-button>
        </fieldset>

        <br><br>

        <fieldset class="mb-4">
            <lesli-button
                danger
                icon="delete_forever"
                @click="storeUser.deleteUser">
                {{ translations.users.view_btn_delete_user }}
            </lesli-button>
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
