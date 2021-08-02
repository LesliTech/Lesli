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
                <h1>Datetime formats.</h1>
                <br />
                <br />
                <div class="columns is-marginless has-border-bottom">
                    <div class="column is-3">
                        <label class="label">
                            Time Zone
                            <sup class="has-text-danger">*</sup>
                        </label>
                    </div>
                    <div class="column">
                        <b-input name="time-zone" required></b-input>
                    </div>
                </div>

                <div class="columns is-marginless has-border-bottom">
                    <div class="column is-3">
                        <label class="label">
                            Start week on
                            <sup class="has-text-danger">*</sup>
                        </label>
                    </div>
                    <div class="column">
                        <b-input name="start-week-on" required></b-input>
                    </div>
                </div>

                <div class="columns is-marginless has-border-bottom">
                    <div class="column is-3">
                        <label class="label">
                            Date Format
                        </label>
                    </div>
                    <div class="column">
                        <b-input name="date-format"></b-input>
                    </div>
                </div>

                <div class="columns is-marginless has-border-bottom">
                    <div class="column is-3">
                        <label class="label">
                            Time Format
                        </label>
                    </div>
                    <div class="column">
                        <b-input name="time-format"></b-input>
                    </div>
                </div>

                <div class="columns is-marginless has-border-bottom">
                    <div class="column is-3">
                        <label class="label">
                            Datetime Format
                        </label>
                    </div>
                    <div class="column">
                        <b-input name="datetime-format"></b-input>
                    </div>
                </div>

                <div class="columns is-marginless has-border-bottom">
                    <div class="column is-3">
                        <label class="label">
                            Date Words
                        </label>
                    </div>
                    <div class="column">
                        <b-input name="date-words"></b-input>
                    </div>
                </div>

                <div class="columns is-marginless has-border-bottom">
                    <div class="column is-3">
                        <label class="label">
                            Datetime words
                        </label>
                    </div>
                    <div class="column">
                        <b-input name="datetime-words"></b-input>
                    </div>
                </div>
            </form>
        </div>
    </div>
</template>
