<script>
/*
Lesli

Copyright (c) 2019, Lesli Technologies, S. A.

All the information provided by this website is protected by laws of Guatemala related 
to industrial property, intellectual property, copyright and relative international laws. 
Lesli Technologies, S. A. is the exclusive owner of all intellectual or industrial property
rights of the code, texts, trade mark, design, pictures and any other information.
Without the written permission of Lesli Technologies, S. A., any replication, modification,
transmission, publication is strictly forbidden.
For more information read the license file including with this software.

LesliCloud - Your Smart Business Assistant

Powered by https://www.lesli.tech
Building a better future, one line of code at a time.

@author   LesliTech <hello@lesli.tech>
@license  Propietary - all rights reserved.
@version  0.1.0-alpha

// · ~·~     ~·~     ~·~     ~·~     ~·~     ~·~     ~·~     ~·~     ~·~     ~·~     ~·~     ~·~
// · 
*/



// · Import frameworks, libraries and tools
// · ~·~     ~·~     ~·~     ~·~     ~·~     ~·~     ~·~     ~·~     ~·~     ~·~     ~·~     ~·~
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
                colors: ["rgb(0, 83, 128)", "rgb(32, 168, 216)", "rgb(10,10,10)"],
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
            
            //this.chart_options.labels = this.dataLabels
            //this.chart_options.series = this.dataSources

            this.chart_options.labels = []
            this.chart_options.series = []

            this.chart = new ApexCharts(document.querySelector("#chart-"+this._uid), this.chart_options)
            this.chart.render()

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
