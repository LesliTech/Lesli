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


//  · Loading core framework and libraries
// ~·~        ~·~        ~·~        ~·~        ~·~        ~·~        ~·~        ~·~        ~·~
import dayjs from 'dayjs'


//  · Loading apps, modules and components
// ~·~        ~·~        ~·~        ~·~        ~·~        ~·~        ~·~        ~·~        ~·~
//import VueApexCharts from 'vue-apexcharts'


// · LesliCloud app
// · ~·~     ~·~     ~·~     ~·~     ~·~     ~·~     ~·~     ~·~     ~·~     ~·~     ~·~
export default {

    mounted() {
        let data = []
        let labels = []
        let d = [0,1,2,3,4,5,6,7,8,9]

        d.forEach(i => {
            data.push(i*75+3)
            labels.push(dayjs().add(i, 'day').format())
        })

        this.chart.series[0].data = data
        this.chart.options = { labels: labels }

    },
    data() {
        return {
            chart: {
                series: [{
                    data: [0]
                }],
                options: {
                    labels: [],
                    annotations: {
                        yaxis: [{
                            y: 420,
                            borderColor: '#00E396',
                            label: {
                                text: 'Support',
                                borderColor: '#00E396',
                                style: {
                                    color: '#fff',
                                    background: '#00E396',
                                },
                            }
                        }, {
                            y: 20,
                            y2: 250,
                            borderColor: '#FEB019',
                            opacity: 0.1,
                            label: {
                                text: 'Y-axis range',
                                borderColor: '#333',
                                style: {
                                    fontSize: '10px',
                                    color: '#333',
                                    background: '#FEB019',
                                },
                            }
                        }],
                        xaxis: [{
                            x: dayjs().add(1, 'day').valueOf(),
                            strokeDashArray: 0,
                            borderColor: '#775DD0',
                            label: {
                                text: 'Anno Test',
                                borderColor: '#775DD0',
                                style: {
                                    color: '#fff',
                                    background: '#775DD0',
                                },
                                
                            }
                        }, {
                            x: dayjs().add(2, 'day').valueOf(),
                            x2: dayjs().add(3, 'day').valueOf(),
                            borderColor: '#B3F7CA',
                            opacity: 0.5,
                            label: {
                                offsetY: -10,
                                text: 'X-axis range',
                                borderColor: '#B3F7CA',
                                style: {
                                    fontSize: '10px',
                                    color: '#fff',
                                    background: '#00E396',
                                },
                            }
                        }],
                        points: [{
                            x: dayjs().add(5, 'day').valueOf(),
                            y: 507.55,
                            marker: {
                                size: 8,
                                fillColor: '#fff',
                                strokeColor: 'red',
                                radius: 2,
                                cssClass: 'apexcharts-custom-class'
                            },
                            label: {
                                text: 'Point Annotation',
                                borderColor: '#FF4560',
                                offsetY: 0,
                                style: {
                                    color: '#fff',
                                    background: '#FF4560',
                                },
                            }
                        }]
                    },
                    chart: {
                        height: 350,
                        type: 'line',
                        id: 'areachart-2'
                    },
                    dataLabels: {
                        enabled: false
                    },
                    stroke: {
                        curve: 'straight'
                    },
                    grid: {
                        padding: {
                            right: 30,
                            left: 20
                        }
                    },
                    title: {
                        text: 'Line with Annotations',
                        align: 'left'
                    },
                    
                    xaxis: {
                        type: 'datetime',
                    }
                }
            }
        }
    }
}
</script>
<template>
    
</template>
<style scoped>

</style>
