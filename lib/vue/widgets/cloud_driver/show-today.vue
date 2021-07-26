<script>
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


// · 
import dayjs from 'dayjs'


// · 
export default {
    data() {
        return {
            date: null,
            month: null
        }
    },
    mounted() {
        this.date = dayjs().date()
        this.month = (new Date()).toLocaleString(I18n.locale, { month: 'long' })
    }
}
</script>
<template>
    <div class="today">
        <p class="day">{{ date }}</p>
        <p class="month">{{ month }}</p>
    </div>
</template>
<style lang="scss" scoped>

    .today.widget-component {
        display: flex;
        flex-direction: column;
        justify-content: center;
        padding: 1rem 0 1.5rem;
        border-radius: 5px;
        text-align: center;
        background: #e66b6b;
        color: #fff;

        .day {
            line-height: 1;
            font-size: 4rem;
            font-weight: 900;
        }

        .month {
            line-height: 1;
            font-size: 2.8rem;
            text-transform: lowercase;
        }

    }

</style>
