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
