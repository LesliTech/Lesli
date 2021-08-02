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

import componentFormBasicInformation from "../components/form-basic-information.vue"
import componentFormContactInformation from "../components/form-contact-information.vue"
import componentFormPublicInformation from "../components/form-public-information.vue"
import componentFormDatetimeFormats from "../components/form-datetime-formats.vue"
import componentFormPasswordFormats from "../components/form-password-formats.vue"
import componentFormInviteUsers from "../components/form-invite-users.vue"


export default {

    components: {
        'component-form-basic-information': componentFormBasicInformation,
        'component-form-contact-information': componentFormContactInformation,
        'component-form-public-information': componentFormPublicInformation,
        'component-form-datetime-formats': componentFormDatetimeFormats,
        'component-form-password-formats': componentFormPasswordFormats,
        'component-form-invite-users': componentFormInviteUsers,
    },

    data() {
        return {
        }
    },

    mounted() {
    }
}
</script>
<template>
    <section class="application-component">

        <b-steps type="is-info" icon-pack="fas">
            <b-step-item icon="building">
                <component-form-basic-information></component-form-basic-information>
            </b-step-item>
            <b-step-item icon="account-key">
                <component-form-contact-information></component-form-contact-information>
            </b-step-item>
            <b-step-item icon="account-key">
                <component-form-public-information></component-form-public-information>
            </b-step-item>
            <b-step-item icon="account-key">
                <component-form-datetime-formats></component-form-datetime-formats>
            </b-step-item>
            <b-step-item icon="account-key">
                <component-form-password-formats></component-form-password-formats>
            </b-step-item>
            <b-step-item icon="account-key">
                <component-form-invite-users></component-form-invite-users>
            </b-step-item>
        </b-steps>

    </section>
</template>


