
// · Plugin initializing 
// · ~·~        ~·~        ~·~        ~·~        ~·~        ~·~        ~·~        ~·~        ~·~
export default {

    install (Vue, store) {

        Vue.prototype.store = {

            data: Vue.observable(store)

        }

    }

}
