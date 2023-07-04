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
import { ref, reactive, onMounted, watch, getCurrentInstance } from "vue"


// · defining emits
const emit = defineEmits(['markerClick']);


// · import & define local components
import ApexCharts from "apexcharts"


// · defining props
const props = defineProps({
    type: {
        type: String,
        required: true
    },
    title: {
        type: String
    },
    subtitle: {
        type: String
    },
    series: {
        type: Array,
        required: true
    },
    labels: {
        type: Array,
        required: true
    },
    options: {
        type: Object,
        default() {
            return {}
        }
    }
})


// · 
const instance = getCurrentInstance()


// · define variables
var chart = reactive({})


// · specific options for apexcharts
const generalOptions = {
    series: [],
    labels: [],
    grid: {
        show: false,
        padding: {
            top: 0,
            right: 0,
            bottom: 0,
            left: 0
        }
    },
    chart: {
        type: props.type, 
        height: "auto",
        toolbar: {
            show: false
        },
        events: {
            markerClick: function(event, chartContext, { seriesIndex, dataPointIndex }) {
                emit("markerClick", { seriesIndex, dataPointIndex })
            }
        }
    },
    title: {
        text: ""
    },
    legend: {
        show: true,
        position: 'top',
        horizontalAlign: 'center'
    },
    dataLabels: {
        enabled: true,
    },
    //colors: this.lesli.colors("charts"),
    stroke: { },
    plotOptions: { },
    xaxis: {
        categories: [],
        tickPlacement: 'between',
        labels: {
            show: true,
            rotate: -65,
            rotateAlways: false,
            trim: false,
            offsetY: 5,
            style: {
                fontSize: '15px'
            }
        }
    },
    yaxis: {
        show: true,
    }
}


// · unique id for the chart container
const chartId = `component-chart-${Math.floor(Math.random() * 10000)}`


// · 
onMounted(() => {

    // labels and data series are empty by default due child (wrapper) components 
    // may set this arrays dynamically, so we have to always listen for changes on
    // these arrays
    generalOptions.labels = []
    generalOptions.series = []

    // start chart with unique html id
    chart = new ApexCharts(document.querySelector("#"+chartId), generalOptions);

    // render an empty chart
    chart.render();

    // If the information is available from the start, we update the labels and sources
    if (props.options) { chart.updateOptions(props.options) }
    if (props.series) { chart.updateSeries(props.series) }
    if (props.labels) { chart.updateOptions({ labels: props.labels }) }

})


// · watch for changes on prop series to update chart options
watch(() => props.series, (newSeries) => chart.updateSeries(newSeries))


// · watch for changes on prop labels to update chart options
watch(() => props.labels, (newLabels) => {

    // special options for bar charts
    if (['bar'].includes(props.type)) {
        chart.updateOptions({ xaxis: { categories: newLabels }})
        return 
    }

    chart.updateOptions({ labels: newLabels })
    
})

</script>
<template>
    <div class="component-chart">
        <h3 v-if="!!title">{{ title }}</h3>
        <p v-if="!!subtitle">{{ subtitle }}</p>
        <div :id="chartId"></div>
    </div>
</template>
