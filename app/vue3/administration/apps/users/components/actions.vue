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
import { useUser } from "LesliVue/stores/user"


// · implement stores
const storeUser = useUser()


</script>
<template>
    <div>
        <div class="mb-4">
            <button class="button is-link is-light is-outlined" @click="storeUser.doRequestPasswordChange">
                <span class="icon">
                    <span class="material-icons">
                        lock_reset
                    </span>
                </span>
                <span>Request password</span>
            </button>
        </div>

        <div class="mb-4">
            <button class="button is-link is-light is-outlined" @click="storeUser.doPasswordReset">
                <span class="icon">
                    <span class="material-icons">
                        key
                    </span>
                </span>
                <span>Reset password</span>
            </button>
        </div>

        <div class="mb-4">
            <button class="button is-link is-light is-outlined" @click="storeUser.doRevokeAccess">
                <span class="icon">
                    <span class="material-icons">
                        lock_outline
                    </span>
                </span>
                <span>Revoke access</span>
            </button>
        </div>

        <div class="mb-4">
            <button class="button is-link is-light is-outlined" @click="storeUser.doLogout">
                <span class="icon">
                <span class="material-icons">
                    logout
                </span>
                </span>
                <span>Forced logout</span>
            </button>
        </div>

        <div class="mb-4">
            <button class="button is-danger is-light is-outlined" @click="storeUser.markUserAsDeleted">
                <span class="icon">
                    <span class="material-icons">
                        delete_forever
                    </span>
                </span>
                <span>Mark as deleted</span>
            </button>
        </div>
    </div>
</template>
