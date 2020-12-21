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
            open: false,
            right: false,
            overlay: false,
            fullwidth: false,
            fullheight: true,
            translations: {}
        }
    },
    mounted() {
        this.mountListeners()
    },
    methods: {
        mountListeners() {
            this.bus.subscribe("show:/core/layout/apps#panel", side => {
                this.open = true
                this.right = side == 'right'
            })
        }
    }
}
</script>
<template>
    <section>
        <b-sidebar
            class="application-modules"
            :fullheight="fullheight"
            :fullwidth="fullwidth"
            :overlay="overlay"
            :right="right"
            :open.sync="open"
        >
            <div class="header">
                <slot name="header"></slot>
            </div>
            <div class="content">
                <slot></slot>
            </div>
        </b-sidebar>
    </section>
</template>
