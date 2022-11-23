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
import { ref } from "vue"
import { defineStore } from "pinia"


// · Import firebase tools
import { getFirestore } from "firebase/firestore"
import { getApp, initializeApp, getApps } from "firebase/app"
import { getAuth, signInWithEmailAndPassword } from "firebase/auth"
import { collection, orderBy, query, where, onSnapshot, documentId, getDocs, addDoc, doc, updateDoc } from "firebase/firestore"


// · 
export const useFirebase = defineStore("core.firebase", {

    state: () => {

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
                console.log(error)
                user = null
            })
    
        }
    

        // initialize the firestore client
        const firestore = getFirestore()


        // initialize the user with static information
        const currentUser = ref({ 
            id: lesli.current_user.id.toString(), 
            email: lesli.current_user.email, 
            full_name: lesli.current_user.full_name, 
            locale: lesli.current_user.settings.find((setting) => setting.name === "locale")?.value || "en",
            active: true,
            implementation: lesli.implementation
        })

        
        // get the users docs and keep listening for any change
        onSnapshot(query(
            collection(firestore, "instances", lesli.implementation, "users"),
            where(documentId(), "==", lesli.current_user.id.toString())
        ), querySnapshot => {

            // here we expect to receive only one document due we want to work only with one user
            let data = querySnapshot.docs[0].data()

            // if you need to add more information to the currentUser
            // this is the place to add those custom properties
            currentUser.value.locale = data?.locale || currentUser.locale
            currentUser.value.full_name = data?.full_name || currentUser.full_name

        })


        // return the state of the app :) 
        return {
            firebase: getApp(),
            firestore: firestore,
            currentUser: currentUser,
            implementation: lesli.implementation,
            users: []
        }
    },

    actions: {
        
        /**
         * Return a reference to a firestore collection
         * @param  {...any} collectionPath 
         * @returns firebase collection
         * @example
         *      getCollection("users")
         *      getCollection("chatrooms")
         *      getCollection("chatrooms", chatroom.id, "message")
         */
        getCollection(...collectionPath) {
            return collection(this.firestore, "instances", this.implementation, ...collectionPath)
        }

    }

})
