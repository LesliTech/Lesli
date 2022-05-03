<script setup>
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


// · import vue tools
import { ref, reactive, onMounted, watch } from "vue"


// · import & define local components
import componentChartGeneral from "LesliVue/components/charts/general.vue"


// · defining props
const props = defineProps({
    title: String,
    series: {
        type: Array,
        required: true
    },
    labels: {
        type: Array,
        required: true
    }
})


// · specific options to print a proper line chart
const pieOptions2 = {
    chart: {
        height: 300,
        width: 380,
    },
    stroke: {
        show: true,
        curve: 'straight',
        lineCap: 'round',
        strokeWidth: [0, 0, 4]
    }
}

const pieOptions = {    
    chart: {
        width: 380,
    },
    responsive: [{
        breakpoint: 480,
        options: {
            chart: {
                width: 200
            },
            legend: {
                position: 'bottom'
            }
        }
    }]
}

</script>
<template>
    <componentChartGeneral 
        type="pie"
        :title="title"
        :series="series"
        :labels="labels"
        :options="pieOptions">
    </componentChartGeneral>
</template>
