<script>
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


// · Import frameworks, libraries and tools
import ApexCharts from "apexcharts"


// · 
export default {
    props: {
        title: {
            type: String,
            required: false
        },
        type: {
            type: String,
            required: true
        },
        dataSources: {
            type: Array,
            required: true
        },
        dataLabels: {
            type: Array,
            required: true
        },
        optionsBase: {
            type: Object,
            required: false
        },
        options: {
            type: Object,
            required: false
        }
    },
    data() {
        return {
            chart: null,
            options_watcher_enabled: true,
            chart_options: {
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
                    type: this.type,
                    toolbar: {
                        show: false
                    }
                },
                title: {
                    text: ''
                },
                legend: {
                    show: true,
                    position: 'top',
                    horizontalAlign: 'center'
                },
                dataLabels: {
                    enabled: true,
                },
                colors: this.lesli.colors("charts"),
                stroke: { },
                plotOptions: { },
                xaxis: {
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
                    show: false,
                }
            }
        }
    },
    mounted() {

        // merge general options with the specific options of wrapper chart component
        this.chart_options = { 
            ...this.chart_options,
            ...this.optionsBase
        }

        this.initChart()

    },
    methods: {

        initChart() {

            // labels and data series are empty by default due child (wrapper) components 
            // may set this arrays dynamically, so we have to always listen for changes on
            // these arrays
            this.chart_options.labels = []
            this.chart_options.series = []

            // start chart with unique html id
            this.chart = new ApexCharts(document.querySelector("#chart-"+this._uid), this.chart_options)

            this.chart.render()

            // update chart with component custom options
            if (this.options) {
                this.chart.updateOptions(this.options)
            }

            // If the information is available from the start, we update the labels and sources
            if (this.dataLabels) {
                this.chart.updateOptions({ labels: this.dataLabels })
            }

            if (this.dataSources) {
                this.chart.updateSeries(this.dataSources)
            }

        }

    },
    watch: {

        // watch for changes on labels of data series
        dataLabels() {
            this.chart.updateOptions({
                labels: this.dataLabels
            })
        },

        // watch for changes on data series
        dataSources() {
            this.chart.updateSeries(this.dataSources)
        },

        // watch for changes on options, so we can change the behavior of the chart on real time
        options: {

            // watch for every change on the options object
            deep: true, 
            handler: function(val) {
                console.log(val)

                try {

                    // This condition prevents an infinite loop in the watcher
                    if(this.options_watcher_enabled){

                        this.options_watcher_enabled = false
                        this.chart.updateOptions(val)

                        this.$nextTick(()=>{
                            this.options_watcher_enabled = true
                        })

                    }

                } catch(error) {
                    
                    console.log("there is an error with general chart options watcher: ", error)

                }

            }

        }

    }

}
</script>
<template>
    <section>
        <div :id="'component-chart-'+_uid"></div>
    </section>
</template>
