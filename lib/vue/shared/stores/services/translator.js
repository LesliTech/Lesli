
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

// This store is used to manage the traslations

import { defineStore } from "pinia"

import { ref } from "vue"


import axios from "axios"

export const useServiceTranslator = defineStore("services.translator", () => {

    const httpClient = axios.create({ baseURL: "https://www.googleapis.com" })
    
    const loading = ref(false)
    
    function getTranslation(message, source, target) {

        if (!(message || source)) return

        var translatedMessage = {
            translatedText: message,
            originalLang: target
        }

        if (source == target) {
            return translatedMessage
        }
        
        return httpClient.get("/language/translate/v2", {
            params: {
                q: message,
                target,
                source,
                key: lesli.providers.google_translate.api_key
            },
            headers: {
                'Content-Type': 'application/json',
                'Accept': 'application/json',
            }
        }).then((response) => {
            translatedMessage.translatedText = response.data.data.translations[0].translatedText
            return translatedMessage
        }).catch((error) => {
            console.error(error)
        })
        
    }

    return {
        loading,
        getTranslation,
    }
})
