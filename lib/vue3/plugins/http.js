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
import axios from "axios"


// · 
export default {
    
    install: (app, options) => {

        // Get authentication token from rails
        let meta = document.querySelector('meta[name="csrf-token"]')

        let token = ''

        if (meta) {
            token = meta.getAttribute('content')
        }
    
        app.config.globalProperties.http = axios.create({
            headers: { 'X-CSRF-Token': token }
        })

        app.config.globalProperties.http.interceptors.request.use(function (config) {

            config.url = config.url.toString(true)

            return config

        }, function (error) {
            
            return Promise.reject(error)

        })

        app.config.globalProperties.http.interceptors.response.use(response => {

            if (window.debug) {
                window.debug(response.data, "api method: " + response.request.responseURL)
            }

            return response.data

        }, error => {

            let message = ""
            
            if (error.response.data.error && error.response.data.error.message) {
                message = error.response.data.error.message
            }else{
                message = `Ajax ${error.config.method} to url ${error.config.url} ${error.message}`
            }

            return {
                success: false,
                error: {
                    error: error.response.statusText,
                    message: message
                }
            }

        })

    }
}
