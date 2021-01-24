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
import componentFormGeneral from "../components/form-general.vue"
import componentFormBranding from "../components/form-branding.vue"


// · 
import componentSettingsGeneral from "../components/settings-general.vue"



// · 
export default {
    components: {
<<<<<<< HEAD
        "component-form-general": componentFormGeneral,
        "component-form-branding": componentFormBranding
=======
        "component-settings-general": componentSettingsGeneral
>>>>>>> feat: remove not used components from settings
    },
    data() {
        return {
            tab: 1
        }
    },
    methods: {

    }
}
</script>
<template>
    <section class="application-component">
        <component-header title="Account settings"></component-header>
        <b-tabs v-model="tab">
            <b-tab-item icon-pack="fas" icon="cog" label="General">
<<<<<<< HEAD
                <component-form-general></component-form-general>
=======
                <component-settings-general></component-settings-general>
            </b-tab-item>
            <b-tab-item icon-pack="fas" icon="clock" label="Date & time">
>>>>>>> feat: remove not used components from settings
            </b-tab-item>
            <b-tab-item icon-pack="fas" icon="palette" label="Branding">
                <component-form-branding></component-form-branding>
            </b-tab-item>
            <b-tab-item icon-pack="fas" icon="paint-brush" label="Theme">
            </b-tab-item>
        </b-tabs>
    </section>
</template>
