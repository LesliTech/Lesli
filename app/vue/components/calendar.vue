<script>
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

@dev      Luis Donis <ldonis@lesli.tech>
@author   LesliTech <hello@lesli.tech>
@license  Propietary - all rights reserved.
@version  GIT: 0.1.0 alpha

//  · 
// ~·~        ~·~        ~·~        ~·~        ~·~        ~·~        ~·~        ~·~        ~·~
*/


//  · Loading core framework and libraries
// ~·~        ~·~        ~·~        ~·~        ~·~        ~·~        ~·~        ~·~        ~·~
import dayjs from 'dayjs'


//  · Loading apps, modules and components
// ~·~        ~·~        ~·~        ~·~        ~·~        ~·~        ~·~        ~·~        ~·~


// · LesliCloud app
// · ~·~     ~·~     ~·~     ~·~     ~·~     ~·~     ~·~     ~·~     ~·~     ~·~     ~·~
export default {
    data() {
        return {
            attributes: [{
                key: 'today',
                dates: new Date(),
                highlight: 'red'
            }, {
                highlight: true,
                dates: [{ 
                    start: dayjs().add(1, 'day').format(), 
                    end: dayjs().add(5, 'day').format() 
                }]
            }, {
                dot: 'red',
                dates: [
                    dayjs().add(7, 'day').format()
                ]
            }, {
                dot: 'blue',
                dates: [
                    dayjs().add(8, 'day').format()
                ]
            }, {
                bar: 'green',
                dates: [
                    dayjs().add(10, 'day').format(),
                    dayjs().add(11, 'day').format(),
                    dayjs().add(12, 'day').format()
                ]
            }]
        }
    }
}
</script>
<template>
    <v-calendar :attributes="attributes" color="blue" is-expanded></v-calendar>
</template>
<style scoped>
    .vc-container {
        border-radius: 2px;
    }
</style>
