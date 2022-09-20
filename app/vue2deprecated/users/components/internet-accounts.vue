<script>
/*
Copyright (c) 2020, all rights reserved.

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

export default {
    data() {
        return {
            translations: {
                users: I18n.t("core.users"),
                shared: I18n.t("core.shared")
            },
        }
    },
    methods: {
        connectGoogle() {
            let url = this.url.go('auth/google_oauth2')
        },
    },
}

</script>

<template>
    <div class="card">
        <div class="card-content">
            <h4 class='is-size-4 mb-4'>{{ translations.users.view_title_account_linking }}</h4>
            <div class="field is-horizontal">
                <div class="field-label is-normal">
                    <label class="label">{{ translations.users.view_text_google_account }}</label>
                </div>
                <div class="field-body">
                    <button class="button" @click="connectGoogle()">
                        <span class="icon">
                            <i class="fab fa-google"></i>
                        </span>
                        <span>{{ translations.users.view_btn_connect }}</span>
                    </button>
                </div>
            </div>
        </div>
    </div>
</template>
