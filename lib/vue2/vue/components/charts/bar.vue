<script>
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


// · use general chart as base for our custom chart
import componentChartGeneral from 'LesliVue/components/charts/general.vue'


// · 
export default {
    props: {
        title: {
            type: String,
            required: false
        },
        dataSources: {
            type: Array,
            required: true
        },
        dataLabels: {
            type: Array,
            required: true
        },
        options: {
            type: Object,
            required: false,
            default() {
                return {
                }
            }
        }
    },
    components: {
        'component-chart-general': componentChartGeneral
    },
    data() {
        return {
            optionsBase: {

                // specific options for this kind of chart
                plotOptions: {
                    bar: {
                        columnWidth: '99%',
                        barHeight: '100%'
                    }
                }
                
            }
        }
    }
}
</script>
<template>
    <component-chart-general 
        type="bar"
        :title="title"
        :data-sources="dataSources"
        :data-labels="dataLabels"
        :options-base="optionsBase"
        :options="options">
    </component-chart-general>
</template>
