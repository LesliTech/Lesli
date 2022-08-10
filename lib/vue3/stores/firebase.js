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
import { defineStore } from "pinia"
import { initializeApp } from "firebase/app"
import { getFirestore } from "firebase/firestore"


// · 
export const useFirebase = defineStore("core.firebase", {
    state: () => {
        return {
            _firebase: null,
            _firestore: null
        }
    },
    getters: {
        firebase: (state) => {

            if (!state._firebase) {
                state._firebase = initializeApp(lesli.cloud_talk.frbswb)
            }

            return state._firebase 

        },

        firestore: (state) => {

            if (!state._firestore) { 
                state._firestore = getFirestore(state.firebase)
            }

            return state._firestore

        }
    }
})
