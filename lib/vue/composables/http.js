/*

Lesli

Copyright (c) 2023, Lesli Technologies, S. A.

This program is free software: you can redistribute it and/or modify
it under the terms of the GNU General Public License as published by
the Free Software Foundation, either version 3 of the License, or
(at your option) any later version.

This program is distributed in the hope that it will be useful,
but WITHOUT ANY WARRANTY; without even the implied warranty of
MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the
GNU General Public License for more details.

You should have received a copy of the GNU General Public License
along with this program. If not, see http://www.gnu.org/licenses/.

Lesli · Your Smart Business Assistant. 

Made with ♥ by https://www.lesli.tech
Building a better future, one line of code at a time.

@contact  hello@lesli.tech
@website  https://lesli.tech
@license  GPLv3 http://www.gnu.org/licenses/gpl-3.0.en.html

// · ~·~     ~·~     ~·~     ~·~     ~·~     ~·~     ~·~     ~·~     ~·~     ~·~     ~·~     ~·~
// · 

*/




// · 
import axios from "axios"
import debug from "lesli-js/debug/browser"


// · 
export function useHTTP() {


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

        config.url = config.url.toString(".json")

        return config

    }, function (error) {
        
        return Promise.reject(error)

    })


    // response interceptor, here we can modify the response received from the server
    axiosClient.interceptors.response.use(response => {

        return response.data

    }, error => {

        // Return the action for "action requested errors"
        if (error.response.status == 490) {

            // Show a pretty error message in the console on every error
            debug.warn(error.config.url + ' : Action Required', `HTTP/${error.config.method.toUpperCase()}`)

            return Promise.reject({
                code: error.response.status,
                action: error.response.data.action,
                message: error.response.data.message
            })
        }

        let message = ""
        
        // check if custom message was sent
        if (error?.response?.data?.message && error?.response?.data?.message != "") {
            message = error?.response?.data?.message
        } else {
            message = `Ajax ${error.config.method} to url ${error.config.url} ${error.message}`
        }

        // return the formated message
        return Promise.reject({
            code: error.response.status,
            message: message,
            details: error?.response?.data?.details || []
        });

    })


    // does not work
    axiosClient.postFile = (url, formData) => {
        var headers = { 'Content-Type': 'multipart/form-data' };
        return axiosClient.post(url, formData, headers)
    }

    return axiosClient

}
