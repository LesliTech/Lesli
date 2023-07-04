<script setup>
/*

Lesli

Copyright (c) 2023, Lesli Technologies, S. A.

This program is free software: you can redistribute it and/or modify
it under the terms of the GNU General Public License as published by
the Free Software Foundation, either version 3 of the License, or
(at your option) any later version.

This program is distributed in the hope that it will be useful,
but WITHOUT ANY WARRANTY; without even the implied warranty of
MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the
GNU General Public License for more details.

You should have received a copy of the GNU General Public License
along with this program. If not, see http://www.gnu.org/licenses/.

Lesli · Your Smart Business Assistant. 

Made with ♥ by https://www.lesli.tech
Building a better future, one line of code at a time.

@contact  hello@lesli.tech
@website  https://lesli.tech
@license  GPLv3 http://www.gnu.org/licenses/gpl-3.0.en.html

// · ~·~     ~·~     ~·~     ~·~     ~·~     ~·~     ~·~     ~·~     ~·~     ~·~     ~·~     ~·~
// · 

*/



// · import vue tools
import { ref, reactive, onMounted, watch } from "vue"


// · import & define local components
import componentChartGeneral from "Lesli/components/charts/general.vue"


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
