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

// ~·~     ~·~     ~·~     ~·~     ~·~     ~·~     ~·~     ~·~     ~·~     ~·~     ~·~     ~·~
//  · 
*/


//  · Loading frameworks, libraries and tools
// ~·~     ~·~     ~·~     ~·~     ~·~     ~·~     ~·~     ~·~     ~·~     ~·~     ~·~     ~·~
import axios from 'axios'


//  · Plugin initializing 
// ~·~     ~·~     ~·~     ~·~     ~·~     ~·~     ~·~     ~·~     ~·~     ~·~     ~·~     ~·~
export default {

    install (Vue, _options) {

        // Get authentication token from rails
        let meta = document.querySelector('meta[name="csrf-token"]')
        let token = ''

        if (meta) {
            token = meta.getAttribute('content')
        }
    
        let http = axios.create({
            headers: { 'X-CSRF-Token': token }
        })

        http.interceptors.response.use(response => {

            if (window.debug) {
                window.debug(response.data, "api method: " + response.request.responseURL)
            }

            if(response.data.successful){

                return {
                    successful: response.data.successful,
                    data: response.data.data
                }

            }

            return {
                successful: response.data.successful,
                error: response.data.error
            }

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

        Vue.prototype.http = http

    }
    
}
