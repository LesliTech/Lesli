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


// ·
export default {
    data() {
        return {
            user: { },
            translations: {
                shared: I18n.t("core.shared")
            },
        }
    },
    methods: {
        putSettings() {

        }
    },
    watch: {
        "data.user": function(user) {
            this.user = user
        }
    }
}
</script>

<template>
    <div class="box">
        <h4 class="is-size-4">Notifications</h4>
            <form @submit.prevent="putSettings()">
                <fieldset>
                    <div class="column is-half">

                        <div class="field">
                            <label class="label"></label>
                            <div class="control">
                                <input  required="required" type="text" class="input">
                            </div>
                        </div>
                        <p class="control">
                            <button class="button is-primary">{{ translations.shared.view_btn_save }}</button>
                        </p>
                    </div>
                </fieldset>
            </form>

    </div>
</template>
