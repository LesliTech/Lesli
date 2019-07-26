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


// · Plugin initializing 
// · ~·~          ~·~          ~·~          ~·~          ~·~          ~·~          ~·~
export default {

    install (Vue) {
    
        Vue.prototype.util = {

            lesli_request: lesli_request,

            colors: {
                white: ['#ffffff'],
                red:   ['#ff8c82','#ed5353','#c6262e','#a10705','#7a0000'],
                orange:['#ffc27d','#ffa154','#f37329','#cc3b02','#a62100'],
                yellow:['#fff394','#ffe16b','#f9c440','#d48e15','#ad5f00'],
                green: ['#d1ff82','#9bdb4d','#68b723','#3a9104','#206b00'],
                blue:  ['#8cd5ff','#64baff','#3689e6','#0d52bf','#002e99'],
                purple:['#e4c6fa','#cd9ef7','#cd9ef7','#7239b3','#452981'],
                brown: ['#a3907c','#8a715e','#715344','#57392d','#3d211b'],
                gray:  ['#fafafa','#d4d4d4','#abacae','#7e8087','#555761'],
                black: ['#444444','#000000']
            },

            // · Show header alerts
            alert(text, type="info") {

                this.bus.$emit('header.alert', text, type)

            },

            // · Set global header title
            title(text) {
                if (!text) {
                    return
                }
                document.getElementById('header-title').innerText = text
            },

            // · Show header messages
            message(text, title, type="info") {

                this.bus.$emit('header.message', text, type)

            },

            debug(obj) {

                if (typeof obj == 'object' || typeof obj == 'array') {
                    console.log(JSON.parse(JSON.stringify(obj)))
                }

            }

        }

    }
    
}
