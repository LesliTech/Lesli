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
import debug from "lesli-js/debug/browser"


// · 
export function useAxios() {


    // Get authentication token from head meta tag
    let meta = document.querySelector('meta[name="csrf-token"]')


    // initialize the token variable
    let token = ""


    // if meta tag was found
    if (meta) {
        token = meta.getAttribute("content")
    }


    // create the vue 3 global property
    var axiosClient = axios.create({
        headers: { 
            'Content-Type': 'application/json;charset=UTF-8',
            'X-CSRF-Token': token 
        }
    })


    // request interceptor, here we can modify the request before send it to the server
    axiosClient.interceptors.request.use(function (config) {

        config.url = config.url.toJsonString()

        return config

    }, function (error) {
        
        return Promise.reject(error)

    })


    // response interceptor, here we can modify the response received from the server
    axiosClient.interceptors.response.use(response => {

        return response.data

    }, error => {

        let message = ""
        
        if (error.response.data.error && error.response.data.error.message) {
            message = error.response.data.error.message
        }else{
            message = `Ajax ${error.config.method} to url ${error.config.url} ${error.message}`
        }

        // Show a pretty error message in the console on every error
        //debug.warn(response.data, "api method: " + response.request.responseURL)
        debug.warn(message)

        return {
            success: false,
            error: {
                error: error.response.statusText,
                message: message
            }
        }

    })

    return axiosClient

}
