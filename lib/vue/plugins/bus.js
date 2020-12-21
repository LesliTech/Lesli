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


// · Plugin initializing 
// · ~·~        ~·~        ~·~        ~·~        ~·~        ~·~        ~·~        ~·~        ~·~
export default {

    install (Vue, options) {


        // new vue instance as bus
        Vue.prototype.bus = new Vue()


        // · 
        Vue.prototype.alert = (text, type='info') => {
            console.log(text)
            Vue.prototype.bus.publish("show:/lesli/layout/alert", text, type)
        }
        

        // · 
        Vue.prototype.notification = (text, type='info') => {
            Vue.prototype.bus.publish("show:/lesli/layout/notification", text, type)
        }


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
