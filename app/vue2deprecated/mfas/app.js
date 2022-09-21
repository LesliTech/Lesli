/*
Copyright (c) 2022, all rights reserved.

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
import app from "LesliVue/public" 

// · 
app({
    data: {
        mfa: {
            t: ""
        },
        notification: {
            message: "",
            show: false,
            type: "is-danger"
        }
    },

    methods: {

        build_redirect_url(default_path = null) {

            // redirect to the root of the domain by default
            let redirect_url = "/"

            try {

                // search for a redirection route in the url params
                redirect_url = Object.fromEntries(new URLSearchParams(window.location.search)).r

            } catch (error) {   

            }

            // redirect to the default path if: 
            //      - there is no query params with redirection
            if (!redirect_url && default_path) {
                redirect_url = default_path   
            }
            
            // redirect to the root if: 
            //      - error parsing redirection route
            //      - there is no query params with redirection
            if (!redirect_url) {
                redirect_url = "/" 
            }

            return redirect_url
             
        },

        postMFA(event) {
            event.preventDefault()

            let key = encodeURIComponent((new URLSearchParams(window.location.search)).get("key"))

            if(!key){
                this.showNotification("Error")
                return
            }

            let endpoint = this.url.to(`/mfa/verify?key=${key}`)
            let data = {
                mfa: {
                    t: this.mfa.t
                }
            }

            this.http.post(endpoint, data).then(response => {

                if( !response.successful ){
                    this.showNotification(response.error.message)
                    return
                }

                this.url.go(this.build_redirect_url(response.data.default_path))
                return

            }).catch(error => {
                console.log(error)
            })
        },

        showNotification(message, type="is-danger"){
            this.notification.message = message
            this.notification.type = type
            this.notification.show = true
        }

    }

})
