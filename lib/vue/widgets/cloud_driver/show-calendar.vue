<script>
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


import VCalendar from 'v-calendar/lib/components/calendar.umd'




// · 
export default {
    components: {
        'v-calendar': VCalendar
    },
    data() {
        const date = new Date();
        const year = date.getFullYear();
        const month = date.getMonth();
        return {
            attrs: [
                {
                key: 'today',
                highlight: true,
                dates: new Date(),
                },
                {
                highlight: {
                color: 'purple',
                fillMode: 'solid',
                contentClass: 'italic',
                },
                //dates: new Date(year, month, 12),
                },
                {
                highlight: {
                color: 'purple',
                fillMode: 'light',
                },
                dates: new Date(year, month, 13),
                },
                {
                highlight: {
                color: 'purple',
                fillMode: 'outline',
                },
                dates: new Date(year, month, 14),
                },
                {
                highlight: {
                start: { fillMode: 'outline' },
                base: { fillMode: 'light' },
                end: { fillMode: 'outline' },
                },
                dates: { start: new Date(year, month, 4), end: new Date(year, month,6) },
                },
                {
                highlight: {
                start: { fillMode: 'outline' },
                base: { fillMode: 'light' },
                end: { fillMode: 'outline' },
                },
                dates: { start: new Date(year, month, 7), end: new Date(year, month,8) },
                },
                {
                dot: true,
                dates: new Date(year, month, 1),
                },
                {
                dot: true,
                dates: new Date(year, month, 3),
                },
                {
                dot: true,
                //dates: new Date(year, month, 4),
                },
                {
                dot: true,
                //dates: new Date(year, month, 18),
                },
                {
                dot: true,
                dates: new Date(year, month, 18),
                },
                {
                dot: true,
                //dates: new Date(year, month, 19),
                },
                {
                dot: true,
                //dates: new Date(year, month, 19),
                },
                {
                dot: true,
                //dates: new Date(year, month, 19),
                },
                {
                popover: {
                label: "event description",
                },
                bar: true,
                dates: [
                //new Date(year, month, 1), // Jan 1st
                //new Date(year, month, 10), // Jan 10th
                new Date(year, month, 22), // Jan 22nd
                ],
                },
                {
                    popover: {
                label: "event description",
                },
                bar: 'red',
                dates: [
                //new Date(year, month, 4), // Jan 4th
                //new Date(year, month, 10), // Jan 10th
                new Date(year, month, 15), // Jan 15th
                ],
                },
                {
                    popover: {
                label: "event description",
                },
                bar: {
                style: {
                backgroundColor: 'brown',
                },
                },
                dates: [
                new Date(year, month, 12), // Jan 12th
                //new Date(year, month, 26), // Jan 26th
                new Date(year, month, 15), // Jan 15th
                ],
                },
            ],
        };
    },
    mounted() {

    }
}
</script>
<template>
    <v-calendar is-expanded :attributes="attrs"></v-calendar>
</template>
