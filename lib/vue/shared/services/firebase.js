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



// · Import pinia tools
import { ref } from "vue"
import { defineStore } from "pinia"


// · Import firebase tools
import { getFirestore } from "firebase/firestore"
import { getApp, initializeApp, getApps } from "firebase/app"
import { getAuth, signInWithEmailAndPassword } from "firebase/auth"
import { collection, query, where, onSnapshot, documentId, doc } from "firebase/firestore"
import { getStorage } from "firebase/storage"



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

        // Create a root reference to firebase storage
        const storage = getStorage()

        // initialize the user with static information
        const currentUser = ref({ 
            id: lesli.current_user.id.toString(), 
            email: lesli.current_user.email, 
            roles: lesli.current_user.roles,
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
            storage: storage,
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
