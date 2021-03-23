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

import { createConsumer } from "@rails/actioncable"

export default {

    install(Vue, options) {

        if(!options.cable) {
            return 
        }

        let consumer = createConsumer("ws://0.0.0.0:3000/cable")

        let channel = consumer.subscriptions.create("WebNotificationsChannel", { 

            connected() {

            },

            disconnected() {
            
            },

            received(data) {
                console.log(data.notification)
                Vue.prototype.store.global.cloud_bell_notification = data.notification
                Vue.prototype.store.global.cloud_bell_notifications = data.notifications
            }

        })
        
    }

}

/*
// Create WebSocket connection.
const socket = new WebSocket("ws://0.0.0.0:3000/cable", "actioncable-v1-json");

// Connection opened
socket.addEventListener("open", function (event) {

    socket.send(JSON.stringify({
        "command": "subscribe",
        "identifier": JSON.stringify({
            channel:"WebNotificationsChannel"
        }) 
    }))

    setInterval(() => {
        socket.send(JSON.stringify({
            command: "message", 
            identifier: "WebNotificationsChannel", 
            data: {
                name: "ldonis"
            }
        }))
    }, 5000);

});


// Listen for messages
socket.addEventListener("message", function (event) {

    let data = JSON.parse(event.data)

    if (data.type == "ping") {
        return 
    }

    console.log("Message from server ", JSON.parse(event.data));

});
*/


//ActionCable.ConnectionMonitor.staleThreshold = 5;

/*
import { createConsumer } from "@rails/actioncable"

let consumer = createConsumer("ws://0.0.0.0:3000/cable")

let channel = consumer.subscriptions.create("WebNotificationsChannel", { 

    connected() {
        console.log("client conected")
    },

    disconnected() {
    
    },

    received(data) {
        console.log("data received", data)
    }

})


setInterval(() => {
    channel.send({ mensaje: "hola desde js"})
}, 10000);

*/
