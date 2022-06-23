<script setup>

import { useProfile } from "LesliCore/administration/stores/users/profile"

const storeProfile = useProfile()

const translations = {
    core: {
        roles: I18n.t("core.roles"),
        users: I18n.t("core.users"),
        shared: I18n.t("core.shared")
    }
}
</script>
<template>
    <div class="card">
        <div class="card-content">
            <h4 class='is-size-4 mb-4'>{{ translations.core.users.view_title_account_linking }}</h4>
            <div class="field is-horizontal">
                <div class="field-label is-normal">
                    <label class="label">{{ translations.core.users.view_text_google_account }}</label>
                </div>
                <div class="field-body">
                    <!-- <button class="button" @click="storeProfile.connectGoogle()">
                        <span>{{ translations.core.users.view_btn_connect }}</span>
                    </button> -->
                    <a href="/auth/google_oauth2" >{{translations.core.users.view_btn_connect}}</a>
                </div>
            </div>
        </div>
    </div>
</template>
