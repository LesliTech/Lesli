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


// · 
import { ref, reactive, onMounted } from "vue"


// · Import frameworks, libraries and tools
import ApexCharts from "apexcharts"


// · 
export default {

    setup() {

        var options = {
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
                text: "hola grafica"
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
            }
        }

        var optionsBase = {
            chart: {
                height: 350, 
                type: 'line'
            },
            stroke: {
                show: true,
                curve: 'smooth',
                lineCap: 'round',
            }
        }

        options = {
            ...options,
            ...optionsBase
        }


        onMounted(() => {

            options.series = [{
                name: "Desktops",
                data: [10, 41, 35, 51, 49, 62, 69, 91, 148]
            }]

            options.labels = ['Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun', 'Jul', 'Aug', 'Sep']
            options.xaxis.categories = options.labels

            console.log(options)

            var chart = new ApexCharts(document.querySelector("#chart"), options);
            chart.render();

        })
    }

}
</script>
<template>
    <section>
        <div class="box">
            <h3>Mi grafica</h3>
            <p>Mi grafica que muestra datos bonitos</p>
            <div id="chart"></div>
        </div>
        <!-- <div :id="'component-chart-'+_uid"></div> -->
    </section>
</template>
