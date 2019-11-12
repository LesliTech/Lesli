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
@version  0.1.0-alpha

// ~·~     ~·~     ~·~     ~·~     ~·~     ~·~     ~·~     ~·~     ~·~     ~·~     ~·~     ~·~
//  · 
*/


//  · Plugin initializing 
// ~·~     ~·~     ~·~     ~·~     ~·~     ~·~     ~·~     ~·~     ~·~     ~·~     ~·~     ~·~
export default {

    install (Vue, router) {
    
        Vue.prototype.url = {

            // · Redirect to specific url
            go(url=null) {
                // · defined in /app/views/layouts/partials/_application-data.html.haml
                url = new URL(url, leslicloud_request.root_url)
                window.location.href = url.href;
                //console.log(url)

            },

            // · Get well formated url
            to(engine=null, module=null, app=null) {
                //  · Filter allows to ignore null values
                return new URL([engine, module, app].filter(item=>item).join('/'), leslicloud_request.root_url)

            }

        }

    }
    
}
