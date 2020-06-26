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
            apps: { 
                showLeft: false,
                showRight: false
            },
            translations: {}
        }
    },
    mounted() {
        this.mountListeners()
    },
    methods: {

        mountListeners() {
            this.bus.subscribe("show:/core/layout/apps#panel", side => {

                if (side == 'right') {
                    if (this.apps.showRight == true) {
                        this.apps.showRight = false
                        return
                    }
                    this.apps.showRight = true
                    this.apps.showLeft = false
                }

                if (side == 'left') {
                    if (this.apps.showLeft == true) {
                        this.apps.showLeft = false
                        return
                    }
                    this.apps.showLeft = true
                    this.apps.showRight = false
                }

                setTimeout(() => this.apps.showRight = false, 400000)
                setTimeout(() => this.apps.showLeft = false, 400000)

            })

        }

    }
}
</script>
<template>
    <section class="application-apps">
        <div :class="[{ 'is-active': apps.showRight }, 'quickview', 'is-left is-active']">
            <header class="quickview-header" @click="apps.showRight = false">
                <b><slot name="title"></slot></b>
                <i class="fas fa-arrow-left"></i>
            </header>
            <div class="quickview-body">
                <div class="quickview-block">
                    <slot></slot>
                </div>
            </div>
        </div>

        <div :class="[{ 'is-active': apps.showLeft }, 'quickview']">
            <header class="quickview-header" @click="apps.showRight = false">
                <b><slot name="title"></slot></b>
                <i class="fas fa-arrow-left"></i>
            </header>
            <div class="quickview-body">
                <div class="quickview-block">
                    <slot></slot>
                </div>
            </div>
        </div>
    </section>
</template>
