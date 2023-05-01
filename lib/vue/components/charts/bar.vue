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
import componentChartGeneral from "Leslicomponents/charts/general.vue"


// · defining props
const props = defineProps({
    title: String,
    series: {
        type: Array,
        required: true
    },  
    labels: {
        type: Array,
        required: false,
        default: []
    }
})


// · specific options to print a proper line chart
const barOptions = {
    chart: {
        height: '350px',
    },
    plotOptions: {
        bar: {
        borderRadius: 10,
        dataLabels: {
            position: 'top', // top, center, bottom
        },
        }
    },
    dataLabels: {
        enabled: true,
        offsetY: -20,
        style: {
            fontSize: '14px',
            colors: ["#304758"]
        }
    },
    xaxis: {
        categories: [],
        position: 'bottom',
        axisTicks: {
            show: false
        },
        tooltip: {
            enabled: true,
        }
    }
};


const parsedSeries = ref([{ data: [] }])


// 
function updateSeries(data) {
    parsedSeries.value = [{ 
        data: props.series
    }]
}

onMounted(() => {
    updateSeries()
})

watch(() => props.series, () => {
    updateSeries()
})

</script>
<template>
    <componentChartGeneral 
        type="bar"
        :title="title"
        :series="parsedSeries"
        :labels="labels"
        :options="barOptions">
    </componentChartGeneral>
</template>
