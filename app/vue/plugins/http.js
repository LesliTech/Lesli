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

@author   Luis Donis <ldonis@lesli.tech>
@license  Propietary - all rights reserved.
@version  GIT: 1.0.0 alpha
*/


// · Loading frameworks, libraries and tools
// · ~·~          ~·~          ~·~          ~·~          ~·~          ~·~          ~·~
import axios from 'axios'


// · Plugin initializing 
// · ~·~          ~·~          ~·~          ~·~          ~·~          ~·~          ~·~
export default {

    install (Vue, options) {
    
        let http = axios.create({ })
        http.defaults.baseURL = options.config.raven.api

        // if sessionStorage exists (browsers)
        if (sessionStorage) {

            // get authorization token from session storage
            let authorization = sessionStorage.getItem('lesli-token')

            if (authorization) {
                //authorization = atob(authorization)
                http.defaults.headers.common['Authorization'] = authorization
            }

        }

        http.interceptors.response.use(response => {

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
            
            if (error.response.data.error.message) {
                message = error.response.data.error.message
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
