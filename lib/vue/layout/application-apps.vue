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
            apps: { show: false },
            translations: {}
        }
    },
    mounted() {
        this.mountListeners()
    },
    methods: {

        mountListeners() {
            this.bus.subscribe("show:/core/layout/apps#panel", () => {
                
                // toggle notification panel
                if (this.apps.show == true) {
                    this.apps.show = false
                    return
                }
                this.apps.show = true
                this.apps.timer = setTimeout(() => this.apps.show = false, 400000)
            })

        }

    }
}
</script>
<template>
    <section class="application-apps">
        <div :class="[{ 'is-active': apps.show }, 'quickview']">
            <header class="quickview-header" @click="apps.show = false">
                <b>Lesli ecosystem</b>
                <i class="fas fa-arrow-right"></i>
            </header>
            <div class="quickview-body">
                <div class="quickview-block">
                    <div class="columns">
                        <div class="column">
                            <slot name="left"></slot>
                        </div>
                        <div class="column">
                            <slot name="right"></slot>
                        </div>
                    </div>
                </div>
            </div>
        </div>
    </section>
</template>
