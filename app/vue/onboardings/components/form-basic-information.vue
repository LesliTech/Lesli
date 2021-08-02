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

    components: {},

    data() {
        return {
            translations: {
                core: {
                    users: I18n.t("core.users"),
                    roles: I18n.t("core.roles"),
                    shared: I18n.t("core.shared")
                }
            },
        }
    },

    watch: {
    },

    methods: {
    }

}
</script>
<template>
    <div class="card">
        <div class="card-content">
            <form>
                <h1><strong>Welcome to Lesli configuration wizard</strong></h1>
                <br />
                <h1>Here you will be able to set information about your account and other configuration. Let's start with basic information...</h1>
                <br />
                <br />
                <div class="columns is-marginless has-border-bottom">
                    <div class="column is-3">
                        <label class="label">
                            Company Name
                            <sup class="has-text-danger">*</sup>
                        </label>
                    </div>
                    <div class="column">
                        <b-input name="company-name" required></b-input>
                    </div>
                </div>

                <div class="columns is-marginless has-border-bottom">
                    <div class="column is-3">
                        <label class="label">
                            Company Name Legal
                        </label>
                    </div>
                    <div class="column">
                        <b-input name="company-name-legal"></b-input>
                    </div>
                </div>

                <div class="columns is-marginless has-border-bottom">
                    <div class="column is-3">
                        <label class="label">
                            Company Tag Line
                        </label>
                    </div>
                    <div class="column">
                        <b-input name="company-tag-line"></b-input>
                    </div>
                </div>
            </form>
        </div>
    </div>
</template>
