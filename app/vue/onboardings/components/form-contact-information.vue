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
                <br />
                <h1>Now some contact information...</h1>
                <br />
                <br />
                <div class="columns is-marginless has-border-bottom">
                    <div class="column is-3">
                        <label class="label">
                            Country
                            <sup class="has-text-danger">*</sup>
                        </label>
                    </div>
                    <div class="column">
                        <b-input name="country" required></b-input>
                    </div>
                </div>

                <div class="columns is-marginless has-border-bottom">
                    <div class="column is-3">
                        <label class="label">
                            Address
                        </label>
                    </div>
                    <div class="column">
                        <b-input name="address"></b-input>
                    </div>
                </div>

                <div class="columns is-marginless has-border-bottom">
                    <div class="column is-3">
                        <label class="label">
                            Region
                        </label>
                    </div>
                    <div class="column">
                        <b-input name="region"></b-input>
                    </div>
                </div>

                <div class="columns is-marginless has-border-bottom">
                    <div class="column is-3">
                        <label class="label">
                            Phone Number 1
                            <sup class="has-text-danger">*</sup>
                        </label>
                    </div>
                    <div class="column">
                        <b-input name="phone-number-1" required></b-input>
                    </div>
                </div>

                <div class="columns is-marginless has-border-bottom">
                    <div class="column is-3">
                        <label class="label">
                            Phone Number 2
                        </label>
                    </div>
                    <div class="column">
                        <b-input name="phone-number-2"></b-input>
                    </div>
                </div>

                <div class="columns is-marginless has-border-bottom">
                    <div class="column is-3">
                        <label class="label">
                            Phone Number 3
                        </label>
                    </div>
                    <div class="column">
                        <b-input name="phone-number-3"></b-input>
                    </div>
                </div>

                <div class="columns is-marginless has-border-bottom">
                    <div class="column is-3">
                        <label class="label">
                            Phone Number 4
                        </label>
                    </div>
                    <div class="column">
                        <b-input name="phone-number-4"></b-input>
                    </div>
                </div>
            </form>
        </div>
    </div>
</template>
