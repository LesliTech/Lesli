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


// · Plugin initializing 
// · ~·~          ~·~          ~·~          ~·~          ~·~          ~·~          ~·~
export default {

    install (Vue, options) {
    
        Vue.prototype.url = {

            get() {
                return window.location
            },

            // · HTTP url redirection
            go(url='') {

                /*
                url = options.lesliRequest.http.root + url
                window.location.replace(url);
                window.location.href = url;
                */
                return

            },

            // · 
            to(module=false, app=false) {

                if (!module) {
                    module = options.lesliRequest.website.module
                }

                let url = options.lesliRequest.http.root + module

                if (app) {
                    return url + '/' + app
                }

                return url

            }

        }

    }
    
}
