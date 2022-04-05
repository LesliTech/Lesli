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
import ky from "ky";


// · 
export default {
    install: (app, options) => {

        // Get CSRF token from rails
        let meta = document.querySelector('meta[name="csrf-token"]')

        let token = ""

        if (meta) {
            token = meta.getAttribute("content")
        }

        app.config.globalProperties.http = ky.create({
            prefixUrl: "http://localhost:3000",
            headers: { "X-CSRF-Token": token },
            hooks: {
                beforeRequest: [ ],
                afterResponse: [
                    response => {
                        console.log(response)
                    }
                ]
            }
        });

    }
}
