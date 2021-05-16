<script>
/*

Copyright (c) 2021, all rights reserved.

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
                core: {
                    shared: I18n.t('core.shared'),
                    account: {
                        settings: I18n.t("core.account/settings"),
                    }
                }
            },
            color: '#64baff'
        }
    },
    methods: {
        postTheme() {
            this.http.put(this.url.admin("account/settings"), {
                settings: {
                    "theme_primary_color": this.color
                }
            }).then(result => {
                if (!result.successful) {
                    this.msg.error(result.error.message)
                    return
                }
                this.msg.info(this.translations.core.account.settings.messages_info_color_saved_successfully)
            })
        }
    },
    watch: {
        color() {
            this.postTheme()
        }
    }

}
</script>
<template>
    <div class="box settings-theme">
        <div class="field">
            <label class="label">{{ translations.core.account.settings.view_text_theme_primary_color }} {{ color }}</label>
            <div class="control">
                <input v-model="color" class="input" type="color" placeholder="Select color">
            </div>
        </div>
    </div>
</template>
