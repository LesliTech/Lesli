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
                <h1>And public information.</h1>
                <br />
                <br />
                <div class="columns is-marginless has-border-bottom">
                    <div class="column is-3">
                        <label class="label">
                            Website
                            <sup class="has-text-danger">*</sup>
                        </label>
                    </div>
                    <div class="column">
                        <b-input name="website" required></b-input>
                    </div>
                </div>

                <div class="columns is-marginless has-border-bottom">
                    <div class="column is-3">
                        <label class="label">
                            Public Email
                            <sup class="has-text-danger">*</sup>
                        </label>
                    </div>
                    <div class="column">
                        <b-input name="public-email" required></b-input>
                    </div>
                </div>

                <div class="columns is-marginless has-border-bottom">
                    <div class="column is-3">
                        <label class="label">
                            Github
                        </label>
                    </div>
                    <div class="column">
                        <b-input name="github"></b-input>
                    </div>
                </div>

                <div class="columns is-marginless has-border-bottom">
                    <div class="column is-3">
                        <label class="label">
                            Twitter
                        </label>
                    </div>
                    <div class="column">
                        <b-input name="twitter"></b-input>
                    </div>
                </div>

                <div class="columns is-marginless has-border-bottom">
                    <div class="column is-3">
                        <label class="label">
                            Youtube
                        </label>
                    </div>
                    <div class="column">
                        <b-input name="youtube"></b-input>
                    </div>
                </div>

                <div class="columns is-marginless has-border-bottom">
                    <div class="column is-3">
                        <label class="label">
                            LinkedIn
                        </label>
                    </div>
                    <div class="column">
                        <b-input name="linkedin"></b-input>
                    </div>
                </div>

                <div class="columns is-marginless has-border-bottom">
                    <div class="column is-3">
                        <label class="label">
                            Facebook
                        </label>
                    </div>
                    <div class="column">
                        <b-input name="facebook"></b-input>
                    </div>
                </div>
            </form>
        </div>
    </div>
</template>
