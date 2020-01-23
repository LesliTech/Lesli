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

LesliCloud - Your Smart Business Assistant

Powered by https://www.lesli.tech
Building a better future, one line of code at a time.

@license  Propietary - all rights reserved.
@version  0.1.0-alpha

// · ~·~     ~·~     ~·~     ~·~     ~·~     ~·~     ~·~     ~·~     ~·~     ~·~     ~·~     ~·~
// · 
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

        // · Global event helpers
        Vue.prototype.notification = (message, type) => {
            Vue.prototype.bus.publish('show:/cloud/layout/notify#notification', message, type)
        }

        Vue.prototype.alert = (message, type) => {
            Vue.prototype.bus.publish('show:/cloud/layout/notify#alert', message, type)
        }

        // · Global DOM event listeners

        // emit when ctrl + s is pressed
        document.addEventListener("keydown", e => {

            if ((window.navigator.platform.match("Mac") ? e.metaKey : e.ctrlKey)  && e.keyCode == 83) {
                e.preventDefault()
                Vue.prototype.bus.publish("keyboard-ctrl-save")
            }

        }, false)

        // · Rails cable client
        let cable = createConsumer('/cable')

        cable.subscriptions.create("LesliChannel", {

            connected() {
            },

            received(data) {
                Vue.prototype.bus.publish(data.channel, data)
            },

            disconnected() {
            }
            
        })

    }
    
}
