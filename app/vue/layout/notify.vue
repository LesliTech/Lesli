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


// · Loading core framework and libraries
// · ~·~        ~·~        ~·~        ~·~        ~·~        ~·~        ~·~        ~·~        ~·~
import { createConsumer } from "@rails/actioncable"


// · LesliCloud component
// · ~·~     ~·~     ~·~     ~·~     ~·~     ~·~     ~·~     ~·~     ~·~     ~·~     ~·~
export default {
    data() {
        return {
            isActive: true,
            type: "is-danger"
        }
    },
    mounted() {
        var self = this
        let consumer = createConsumer('http://0.0.0.0:3000/courier/cable')
        consumer.subscriptions.create("CloudCourier::WebNotificationsChannel", {
            received(data) {
                console.log('notify component', data)
                self.isActive = true
                console.log(self.type)
            }
        })
    }
}
</script>
<template>
    <section class="component_notify">
        <b-notification 
            :active.sync="isActive" 
            :type="type" 
            :duration="4000" 
            auto-close 
            aria-close-label="Close notification">
            Lorem ipsum dolor sit amet, consectetur adipiscing elit. Fusce id fermentum quam. Proin sagittis, nibh id hendrerit imperdiet, elit sapien laoreet elit
        </b-notification>
    </section>
</template>


