/*
Lesli

Copyright (c) 2019, Lesli Technologies, S. A.

All the information provided by this website is protected by laws of Guatemala related 
to industrial property, intellectual property, copyright and relative international laws. 
Lesli Technologies, S. A. is the exclusive owner of all intellectual or industrial property
rights of the code, texts, trade mark, design, pictures and any other information.
Without the written permission of Lesli Technologies, S. A., any replication, modification,
transmission, publication is strictly forbidden.
For more information read the license file including with this software.

LesliCloud - Your Smart Business Assistant

Powered by https://www.lesli.tech
Building a better future, one line of code at a time.

@author   Luis Donis <ldonis@lesli.tech>
@license  Propietary - all rights reserved.
@version  GIT: 1.0.0 alpha
*/


// · Loading frameworks, libraries and tools
// · ~·~          ~·~          ~·~          ~·~          ~·~          ~·~          ~·~
import mqtt from 'mqtt'


// · Plugin initializing 
// · ~·~          ~·~          ~·~          ~·~          ~·~          ~·~          ~·~
export default {

    install (Vue, options) {

        Vue.prototype.mqtt = mqtt.connect('ws://' + options.config.raven.ws, { rejectUnauthorized:false })
        Vue.prototype.mqtt.tools = {

            packet(packet) {

                packet = this.binary(packet)

                //switch(packet.format) 
                switch (packet.format) {
                    case 'csvr':
                        packet.data = this.csvr(packet.data)            
                        break;
            
                }

                return packet

            },

            // · 
            csvr(packet) {

                packet = this.csv(packet)

                let key = ""
                let val = ""
                let data = {}

                for (let i=0; i < packet.length; i++) {

                    // TODO add trim function here
                    key = packet[i].substring(0,1).toString()
                    val = packet[i].substring(1).toString()
                    data[key] = val
                }

                return data

            },

            // · 
            csv(packet) {

                try {
                    packet = packet.split(',')
                }catch(e) {
                    packet = [packet]
                }

                return packet

            },

            // · 
            binary(packet) {

                packet = packet.toString()

                packet = packet.split('|')

                return {
                    format: packet[0],
                    data: packet[1]
                }

            }

        }

    }
    
}
