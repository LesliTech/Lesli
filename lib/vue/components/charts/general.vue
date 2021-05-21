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


// · Import frameworks, libraries and tools
import ApexCharts from 'apexcharts'


// · 
export default {
    props: {
        enableDataLabels: {
            type: Boolean,
            default: false
        },
        strokeWidth: {
            type: Array,
            default: ()=>{
                return [0,0,4]
            }
        },
        colors: {
            type: Array,
            default: ()=>{
                return [
                    "rgb(0, 83, 128)",
                    "rgb(32, 168, 216)",
                    "rgb(10,10,10)"
                ]
            }
        },
        dataSources: {
            type: Array,
            required: true
        },
        dataLabels: {
            type: Array,
            required: true
        },
        height: {
            default: "auto"            
        },
        padding: {
            default() {
                return {
                    top: 0,
                    right: 0,
                    bottom: 0,
                    left: 0
                }
            }
        }
    },
    data() {
        return {
            chart: null,
            chart_options: {
                series: [],
                labels: [],
                grid: {
                    show: false,
                    padding: this.padding
                },
                chart: {
                    stacked: true,
                    height: this.height,
                    toolbar: {
                        show: false,
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
                    enabled: this.enableDataLabels,
                    offsetY: -10,
                    enabledOnSeries: [2]
                },
                colors: this.colors,
                stroke: {
                    show: true,
                    curve: "straight",
                    lineCap: 'round',
                    width: this.strokeWidth
                },
                plotOptions: {
                    bar: {
                        columnWidth: '99%',
                        barHeight: '100%'
                    }
                },
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
                    //max: 800
                }
            }
        }
    },
    mounted() {
        this.initChart()
    },
    methods: {
        initChart() {
            this.chart_options.labels = []
            this.chart_options.series = []
            this.chart = new ApexCharts(document.querySelector("#chart-"+this._uid), this.chart_options)
            this.chart.render()
            // If the information is available from the start, we update the labels and sources
            if(this.dataLabels){
                this.chart.updateOptions({
                    labels: this.dataLabels
                })
            }
            if(this.dataSources){
            this.chart.updateSeries(this.dataSources)
            }
        }
    },
    watch: {
        dataLabels() {
            this.chart.updateOptions({
                labels: this.dataLabels
            })
        },
        dataSources() {
            this.chart.updateSeries(this.dataSources)
        }
    }
}
</script>
<template>
    <section>
        <div :id="'chart-'+_uid"></div>
    </section>
</template>
