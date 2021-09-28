<script>
import dayjs from 'dayjs'

/*

Copyright (c) 2021, all rights reserved.

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



export default {
    props: {
        component: Object
    },
    data() {
        return {
            times: []
        }
    },
    mounted() {

        // init times
        this.getTimes()

        // refresh time every 90 seconds
        setInterval(() => { this.getTimes() }, 90000);

    },
    methods: {

        getTimes() {
            this.times = []
            this.component.custom_configuration.time_zones.forEach(config => {
                let time = (new Date()).toLocaleString('en-US', { timeZone: config })
                this.times.push({
                    time_zone: config,
                    time: dayjs(time).format('ddd, DD/MM/YYYY HH:mm')
                })
            })
        }

    }
}
</script>
<template>
    <div class="card">
        <div class="card-header">
            <h3 class="card-header-title">{{ component.name }}</h3>
        </div>
        <div class="card-content">
            <table class="table is-fullwidth">
                <tbody>
                    <tr v-for="(time, index) in times" :key="index">
                        <td>{{ time.time_zone }}</td>
                        <td>{{ time.time }}</td>
                    </tr>
                </tbody>
            </table>
        </div>
    </div>
</template>
