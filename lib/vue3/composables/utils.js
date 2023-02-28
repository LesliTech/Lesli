/*
Copyright (c) 2023, all rights reserved.

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
export function useUtils() {

    function singularize(string) {
        if(string.match(/^[0-9]+$/)){
            return string
        }
        if(string.endsWith('ies')){
            return string.slice(0, -3).concat('y')
        }
        
        return string.slice(0, -1)

    }

    return {
        singularize: (string) => singularize(string)
    }

}
