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


// · Import pinia tools
import { defineStore } from "pinia"


// · Import firebase tools
import { getFirestore } from "firebase/firestore"
import { getApp, initializeApp, getApps } from "firebase/app"
import { getAuth, signInWithEmailAndPassword } from "firebase/auth"


// · 
export const useFirebase = defineStore("core.firebase", () => {

    var user = null
    
    // · When the store is created, the firebase app is initialized
    if (getApps().length === 0) initializeApp(lesli.cloud_talk.firebase.config)


    // try to login if user is empty
    if (!user) {

        // if user is not logged, try to login
        signInWithEmailAndPassword(
            getAuth(), 
            lesli.cloud_talk.firebase.user.email, 
            lesli.cloud_talk.firebase.user.password
        ).then((result) => {
            user = result
        }).catch((error) => {
            user = null
        })

    }


    // prepare the minimum information required to work with firebase
    let currentuser =  { 
        id: lesli.current_user.id, 
        email: lesli.current_user.email, 
        full_name: lesli.current_user.full_name, 
        locale: lesli.current_user.settings.find((setting) => setting.name === "locale")?.value || "de",
        instance: "mw-dev", // TODO: add the context to the data partial
        context: "mw-dev"
    }


    // · Getters
    return {
        firebase: getApp(),
        firestore: getFirestore(),
        currentUser: currentuser
    }

})
