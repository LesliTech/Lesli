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



/*
import { createConsumer } from "@rails/actioncable"
let consumer = createConsumer("ws://0.0.0.0:3000/cable")
consumer.subscriptions.create({ channel: "LesliChannel"}, { received(data) { console.log(data) }})
// */



// · Plugin initializing 
// · ~·~        ~·~        ~·~        ~·~        ~·~        ~·~        ~·~        ~·~        ~·~
export default {

    install (Vue, options) {

        // Create WebSocket connection.
        const socket = new WebSocket("ws://0.0.0.0:3000/cable", "actioncable-v1-json");

        // Connection opened
        socket.addEventListener("open", function (event) {

            socket.send(JSON.stringify({
                "command": "subscribe",
                "identifier": JSON.stringify({
                    channel:"LesliChannel"
                }) 
            }))

            /*
            setInterval(() => {
                socket.send(JSON.stringify({
                    command: "message", 
                    identifier: "LesliChannel", 
                    data: {
                        name: "ldonis"
                    }
                }))
            }, 1000);
            */

        });


        // Listen for messages
        socket.addEventListener("message", function (event) {

            let data = JSON.parse(event.data)

            if (data.type == "ping") {
                return 
            }

            console.log("Message from server ", JSON.parse(event.data));

        });


    }
    
}
