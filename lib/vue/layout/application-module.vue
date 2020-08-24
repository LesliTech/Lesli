<script>
/*
Lesli

Copyright (c) 2020, Lesli Technologies, S. A.

All the information provided by this website is protected by laws of Guatemala related 
to industrial property, intellectual property, copyright and relative international laws. 
Lesli Technologies, S. A. is the exclusive owner of all intellectual or industrial property
rights of the code, texts, trade mark, design, pictures and any other information.
Without the written permission of Lesli Technologies, S. A., any replication, modification,
transmission, publication is strictly forbidden.
For more information read the license file including with this software.

Lesli - Your Smart Business Assistant

Powered by https://www.lesli.tech
Building a better future, one line of code at a time.

@contact  <hello@lesli.tech>
@website  <https://lesli.tech>
@license  Propietary - all rights reserved.

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
