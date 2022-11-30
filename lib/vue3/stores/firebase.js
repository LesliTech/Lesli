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
import { collection, query, where, onSnapshot, documentId, doc } from "firebase/firestore"


// · 
export const useFirebase = defineStore("core.firebase", {

    state: () => {
        
        // check if we have at least a valid structure of credentials for firebase
        if (
            !lesli.providers.firebase.config || 
            !lesli.providers.firebase.user.email || 
            !lesli.providers.firebase.user.password
        ) {
            return debug.error("No valid provider credentials found for firebase")
        }

        var user = null
    
        // · When the store is created, the firebase app is initialized
        if (getApps().length === 0) {
            initializeApp(lesli.providers.firebase.config)
        }
    
    
        // try to login if user is empty
        if (!user) {
    
            // if user is not logged, try to login
            signInWithEmailAndPassword(
                getAuth(), 
                lesli.providers.firebase.user.email, 
                lesli.providers.firebase.user.password
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

            console.log("aqui :)")
            // here we expect to receive only one document due we want to work only with one user
            let data = querySnapshot?.docs.at(0)?.data()

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
        },

        /**
         * Return a reference to a firestore doc
         * @param  {...any} docPath 
         * @returns firebase doc
         * @example
         *      getDoc("chatrooms", chatroom.id)
         */
        getDoc(...docPath) {
            return doc(this.firestore, "instances", this.implementation, ...docPath)
        }

    }

})
