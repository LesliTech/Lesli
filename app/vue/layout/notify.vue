<script>
/*
Lesli

Copyright (c) 2019, Lesli Technologies, S. A.

All the information provided by this website is protected by laws of Guatemala related 
to industrial property, intellectual property, copyright and relative international laws. 
Lesli Technologies, S. A. is the exclusive owner of all intellectual or industrial property
rights of the code, texts, trade mark, design, pictures and any other information.
Without the written permission of Lesli Technologies, S. A., any replication, modification,
transmission, publication is strictly forbidden.
For more information read the license file including with this software.

LesliCloud - Your Smart Business Assistant

Powered by https://www.lesli.tech
Building a better future, one line of code at a time.

@dev      Luis Donis <ldonis@lesli.tech>
@author   LesliTech <hello@lesli.tech>
@license  Propietary - all rights reserved.
@version  GIT: 0.1.0 alpha

//  · 
// ~·~        ~·~        ~·~        ~·~        ~·~        ~·~        ~·~        ~·~        ~·~
*/


// · LesliCloud component
// · ~·~     ~·~     ~·~     ~·~     ~·~     ~·~     ~·~     ~·~     ~·~     ~·~     ~·~
export default {
    mounted() {

        this.bus.$on('component:notify#alert', (message, type='primary') => {
            this.$buefy.toast.open({
                queue: true,
                duration: 3500,
                position: 'is-bottom-right',
                message: message,
                type: `is-${ type }`
            })
        })

        this.bus.$on('component:notify#notification', (message, type='success') => {

            this.$buefy.notification.open({
                queue: true,
                duration: 2000,
                position: 'is-bottom-right',
                message: message,
                type: `is-${ type }`
            })

        })

        var self = this
        this.cable.subscriptions.create("CloudCourier::Bell::WebNotificationChannel", {
            received(data) {
                console.log(data)
            }
        })

    }
}
</script>
<template>
    <section>
    </section>
</template>


