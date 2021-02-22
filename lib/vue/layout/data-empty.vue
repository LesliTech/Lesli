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
    props: {
        text: {
            required: false,
            type: String,
            default: null
        },
    },
    data() {
        return {
            translations: {
                shared: {
                    view_text_no_data_found: I18n.t('core.shared.view_text_no_data_found')
                }
            },
        }
    },
}
</script>
<template>
    <section class="component-data-empty">
        <div class="">
            <svg class="empty-box" viewBox="0 0 128 128" xmlns="http://www.w3.org/2000/svg">
                <g style="isolation: isolate">
                    <g data-name="Layer 1" id="Layer_1">
                        <polygon points="9.409 29.525 64 12.821 118.591 29.525 64 51.464 9.409 29.525" style="fill: #ebe0c7"/>
                        <polygon points="64 12.821 64 49.306 68.591 51.464 116.926 32.143 118.591 29.525 64 12.821" style="fill: #231f20;opacity: 0.07"/>
                        <polygon points="64 115.179 118.591 95.398 118.591 29.525 62.274 49.931 64 115.179" style="fill: #e2d6c0"/>
                        <polygon points="64 115.179 9.409 93.692 9.409 29.525 64 49.306 64 115.179" style="fill: #f8ecd2"/>
                        <polygon points="0 58.55 54.892 79.528 64 49.306 9.409 29.525 0 58.55" style="fill: #f8ecd2"/>
                        <polygon points="0 58.55 54.892 79.528 64 49.306 9.409 29.525 0 58.55" style="fill: #fff;opacity: 0.35000000000000003;mix-blend-mode: lighten"/>
                        <polygon points="128 58.55 73.108 79.528 64 49.306 118.591 29.525 128 58.55" style="fill: #e2d6c0"/>
                        <polygon points="128 58.55 73.108 79.528 64 49.306 118.591 29.525 128 58.55" style="fill: #231f20;opacity: 0.1"/>
                    </g>
                </g>
            </svg>
            <p v-if="this.text">{{ this.text }}</p>
            <p v-else>{{ this.translations.shared.view_text_no_data_found }}</p>
        </div>
    </section>
</template>
