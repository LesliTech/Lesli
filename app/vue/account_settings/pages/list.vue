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
import componentFormTheme from "../components/form-theme.vue"
import componentFormGeneral from "../components/form-general.vue"
import componentFormBranding from "../components/form-branding.vue"


// · 
export default {
    components: {
        "component-form-theme": componentFormTheme,
        "component-form-general": componentFormGeneral,
        "component-form-branding": componentFormBranding
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
                <component-form-general></component-form-general>
            </b-tab-item>
            <b-tab-item icon-pack="fas" icon="palette" label="Branding">
                <component-form-branding></component-form-branding>
            </b-tab-item>
            <b-tab-item icon-pack="fas" icon="paint-brush" label="Theme">
                <component-form-theme></component-form-theme>
            </b-tab-item>
        </b-tabs>
    </section>
</template>
