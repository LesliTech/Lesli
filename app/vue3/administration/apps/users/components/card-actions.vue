<script setup>
// · import lesli stores
import { useUser } from "LesliVue/stores/user"

// · implement stores
const storeUser = useUser()

</script>
<template>
    <div class="level">
        <div class="level-left">
            <div class="level-item">
                <button class="button is-link is-light is-outlined" @click="storeUser.doRequestPasswordChange">
                    <span class="icon">
                        <span class="material-icons">
                            enhanced_encryption
                        </span>
                    </span>
                    <span>Request password change</span>
                </button>
            </div>
            <div class="level-item">
                <button class="button is-link is-light is-outlined" @click="storeUser.doLogout">
                    <span class="icon">
                    <span class="material-icons">
                        logout
                    </span>
                    </span>
                    <span>Forced logout</span>
                </button>
            </div>
            <div class="level-item">
                <button class="button is-link is-light is-outlined" @click="storeUser.doRevokeAccess">
                    <span class="icon">
                        <span class="material-icons">
                            lock_outline
                        </span>
                    </span>
                    <span>Revoke access</span>
                </button>
            </div>
        </div>
        <div class="level-right">
            <div class="level-item">
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
    </div>
</template>
