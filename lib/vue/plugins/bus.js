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


/*

general bus path
rails_controller_method:/engine/controller#vue_method
rails_controller_method:/engine/controller#vue_action

example:
show:/driver/events
create:/driver/events#reload


// · core components
action:/lesli/component_path#vue_method

*/


// · Loading core framework and libraries
// · ~·~        ~·~        ~·~        ~·~        ~·~        ~·~        ~·~        ~·~        ~·~
import { createConsumer } from "@rails/actioncable"



// · Plugin initializing 
// · ~·~        ~·~        ~·~        ~·~        ~·~        ~·~        ~·~        ~·~        ~·~
export default {

    install (Vue, options) {


        // new vue instance as bus
        Vue.prototype.bus = new Vue()


        // · 
        Vue.prototype.alert = (message, type) => {
            Vue.prototype.bus.publish("show:/core/layout/notification#alert", message, type)
        }
        

        // · 
        Vue.prototype.notification = (text, type) => {
            Vue.prototype.bus.publish("show:/lesli/layout/notification#notification", message, type)
        }


        // · 
        Vue.prototype.message = (message, type) => {
            Vue.prototype.bus.publish("show:/lesli/layout/notification#message", message, type)
        }
        

        // · 
        Vue.prototype.toast = (message, type) => {
            Vue.prototype.bus.publish("show:/lesli/layout/notification#toast", message, type)
        }


        // Rails cable client
        let cable = createConsumer('/cable')


        // Suscribe to Lesli channel
        cable.subscriptions.create("LesliChannel", {

            connected() {
            },

            received(data) {
                Vue.prototype.bus.publish(data.channel, data)
            },

            disconnected() {
            }
            
        })


        // Vue bus aliases
        Object.defineProperties(Vue.prototype.bus, {
            subscribe: {
                get() {
                    return this.$on.bind(this)
                }
            },
            publish: {
                get() {
                    return this.$emit.bind(this)
                }
            }
        })


        // · Global DOM event listeners
        document.addEventListener("keydown", e => {

            // emit when ctrl + s is pressed
            if ((window.navigator.platform.match("Mac") ? e.metaKey : e.ctrlKey)  && e.keyCode == 83) {
                e.preventDefault()
                Vue.prototype.bus.publish("key:/save")
            }

        }, false)


    }
    
}
