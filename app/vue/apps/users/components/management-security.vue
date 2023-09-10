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
