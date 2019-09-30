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
            calendar: []
        }
    },
    mounted() {
        for (let i = 0; i<=10; i++) {
            this.calendar.push({
                date: dayjs().add(i,'day').format("DD/MMM")
            })
        }
    }
}
</script>
<template>
    <div class="card">
        <table class="table">
            <thead>
                <tr>
                    <th v-for="(date, index) in calendar" :key="index">
                        {{ date.date }}
                    </th>
                </tr>
            </thead>
            <tbody>
                <tr>
                    <td colspan="8">
                        <ol>
                            <li></li>
                            <li></li>
                        </ol>
                    </td>
                </tr>
                <tr>
                    <td></td>
                    <td></td>
                    <td></td>
                    <td colspan="6">
                        <ol>
                            <li></li>
                            <li></li>
                        </ol>
                    </td>
                </tr>
            </tbody>
        </table>
    </div>
</template>
<style scoped>


ol {
    width: 98%;
    display: flex;
    margin: 0 auto;
    padding: 2px 3px;
    border-radius: 10px;
    background-color: transparent;
    justify-content: space-between;
    border: 2px solid blue;
    border: 2px solid blue;
    background-color: blue;
}

li {
    width: 10px;
    height: 10px;
    border-radius: 50%;
    list-style-type: none;
    background-color: blue;
    border: 2px solid blue;
    transition: background-color .2s ease;
}

</style>
