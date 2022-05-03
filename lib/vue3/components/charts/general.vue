<script setup>
/*
Copyright (c) 2022, all rights reserved.

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
import ApexCharts from "apexcharts"


// · defining props
const props = defineProps({
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


// · define variables
var chart = reactive({})


// specific options for apexcharts
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
        height: "auto",
        type: "line", 
        toolbar: {
            show: false
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
        enabled: false,
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
            },
        }
    },
    yaxis: {
        show: true,
    },
    tooltip: {
        shared: false,
        intersect: true
    }
}


// unique id for the chart container
const chartId = `component-chart-${Math.floor(Math.random() * 10000)}`


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

})


// watch for changes on prop series to update chart options
watch(() => props.series, (newSeries) => chart.updateSeries(newSeries))

// watch for changes on prop labels to update chart options
watch(() => props.labels, (newLabels) => chart.updateOptions({ labels: newLabels }))

</script>
<template>
    <section>
        <div class="box">
            <h3 v-if="!!title">{{ title }}</h3>
            <p v-if="!!subtitle">{{ subtitle }}</p>
            <div :id="chartId"></div>
        </div>
    </section>
</template>
