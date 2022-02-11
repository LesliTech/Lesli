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
            translations: {
                notifications: I18n.t("bell.notifications")
            },
            open: false,
            loading: false,
            document: {}
        }
    },
    watch: {
        'data.global.show_panel_document_viewer': function (val) {
            this.document = val
            this.loading = true
            if (!this.document.name || !this.document.url) { return this.open = false; }
            this.open = true
        },
    }
    
}
</script>
<template>
    <b-sidebar
        class="application-panel-document-viewer"
        :open.sync="open"
        :right="true"
        :fullheight="true"
        :overlay="true"
        :on-cancel="() => document = {}">
        <div class="panel-title is-size-5">
            <h4>{{ document.name }}</h4>
            <span class="icon is-large hover" @click="open = false">
                <i class="fas fa-lg fa-chevron-right"></i>
            </span>
        </div>
        <component-data-loading v-if="loading"></component-data-loading>
        <iframe v-if="document.url" v-show="!loading" ref="framei" :src="document.url" @load="loading=false" frameborder="0"></iframe>
    </b-sidebar>
</template>
<style>
iframe {
    display: block;
    width: 100%;
    height: 100%;
}
</style>
