<script>

import componentChartBar from 'LesliVue/components/charts/bar.vue'

export default {
    props: {
        component: Object
    },
    components: {
        'component-chart-bar': componentChartBar
    },
    data() {
        return {
            chart_options: { chart: { height: '200px' } }
        }
    }
}
</script>
<template>
    <div class="card">
        <div class="card-header">
            <h3 class="card-header-title">{{ component.name }}</h3>
        </div>
        <div class="card-content">
            <component-chart-bar 
                :data-sources="[{
                    name: 'numeros',
                    data: [1,2,3,4]
                }]"
                :data-labels="['uno', 'dos', 'tres', 'cuatro']"
                :options="this.chart_options">
            </component-chart-bar>
        </div>
    </div>
</template>
