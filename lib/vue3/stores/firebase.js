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

// · Import vue tools
import { computed } from "vue";

// · Import pinia tools
import { defineStore } from "pinia"

// · Import firebase tools
import { getApp, initializeApp, getApps } from "firebase/app"
import { getFirestore } from "firebase/firestore"
import { getAuth } from "firebase/auth"



export const useFirebase = defineStore("core.firebase", () => {
    
    // · When the store is created, the firebase app is initialized
    if (getApps().length === 0) initializeApp(lesli.cloud_talk.firebase.config)

    return {
        // · Getters
        firebase: computed(() => getApp()),
        firestore: computed(() => getFirestore()),
        auth: computed(() => getAuth())
    }
})
