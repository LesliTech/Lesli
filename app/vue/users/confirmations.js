/*
Copyright (c) 2020, all rights reserved.

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


// · 
app({
    data: {
        seconds_left_to_redirect: 10
    },
    mounted() {
        setInterval(() => {
            this.seconds_left_to_redirect -= 1
            if (this.seconds_left_to_redirect <= 0) {
                //this.url.go("/login")
            }
        }, 1000);
    }

 })
