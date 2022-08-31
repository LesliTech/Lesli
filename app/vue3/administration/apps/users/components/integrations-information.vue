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
    <section class="application-component">
        <lesli-header title="Integrations">
        </lesli-header>
        <div class="field is-horizontal">
            <div class="field-label is-normal">
                <label class="label">Google account</label>
            </div>
            <div class="field-body">
                <lesli-button icon="google">
                    <a href="/auth/google_oauth2">Connect</a>
                </lesli-button>
            </div>
        </div>
    </section>
</template>
