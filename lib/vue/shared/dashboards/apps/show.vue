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


// · Import components
import componentCoreShowToday from "LesliWidgetsCore/show-today.vue"
import componentCoreShowEventsNext from "LesliWidgetsCore/show-events-next.vue"
import componentCoreChartTasks from "LesliWidgetsCore/chart-tasks.vue"
import componentCoreShowEventsCalendar from "LesliWidgetsCore/show-events-calendar.vue"
import componentCoreListSessionsActive from "LesliWidgetsCore/list-sessions-active.vue"


import componentChartGeneral from 'LesliVue/components/charts/general.vue'
import componentChartLine from 'LesliVue/components/charts/line.vue'
import componentChartBar from 'LesliVue/components/charts/bar.vue'


// · 
export default {
    components: {
        "component-core-show-today": componentCoreShowToday,
        "component-core-show-events-next": componentCoreShowEventsNext,
        "component-core-show-events-calendar": componentCoreShowEventsCalendar,
        "component-core-chart-tasks": componentCoreChartTasks,
        "component-core-list-sessions-active": componentCoreListSessionsActive,

        'component-chart-general': componentChartGeneral,
        'component-chart-line': componentChartLine,
        'component-chart-bar': componentChartBar
    },
    props: {
        engine: String
    },
    data() {
        return {
            dashboard: {},
            ooptions: {}
        }
    },
    mounted() {

        setTimeout(() => {
            this.ooptions = { stroke: { curve: 'smooth' } }
        }, 2000)

        this.shortcuts = shortcuts
        //this.getDefaultDashboard()
        this.dashboard = {
            "id": 1,
            "name": "Default Dashboard",
            "default": true,
            "main": false,
            "user_main_id": null,
            "users_id": null,
            "roles_id": null,
            "components": [{
                layout: 5,
                name: "Active sessions",
                component_id: "core-list-sessions-active",
                custom_configuration: {},
                query_configuration: {}
            }, {
                name: "events",
                component_id: "core-show-events-calendar",
                layout: 5,
            }, {
                name: "today",
                component_id: "core-show-today",
                layout: 2,
            }, {
                name: "today",
                component_id: "core-show-today",
                layout: 2,
            }, {
                name: "Upcoming events",
                component_id: "core-show-events-next",
                layout: 5,
            }, {
                name: "My tasks",
                component_id: "core-chart-tasks",
                layout: 5,
            }]
        }
    },
    methods: {

        getDefaultDashboard() {
            
            this.http.get(this.url[this.engine]("dashboards/default")).then((result) => {

                if (!result.successful) {

                    this.msg.error(result.error.message)
                    
                }

                this.dashboard = result.data

            }).catch(error => {

                console.log(error)

            })

        }

    }
}
</script>
<template>
    <section class="application-component lesli-dashboards">


        {{ /* dashboard header */ }}
        <component-header title="Dashboard"></component-header>


        {{ /* show message if there is no dashboard */ }}
        <div v-if="!dashboard" class="container">
            <component-data-empty text="empty dashboard"></component-data-empty>
        </div>


        {{ /* show message if there is no dashboard */ }}
        <section v-if="dashboard" class="columns is-multiline">
            <div 
                v-for="component in dashboard.components" 
                :key="component.id" 
                :class="['column', `is-${component.layout}`]">
                <component
                    class="widget-component"
                    :is="`component-${ component.component_id }`"
                    :component="component">
                </component>
            </div>
        </section>

        <div class="columns">
            <div class="column is-4">
                <component-chart-general 
                    type="bar"
                    :data-sources="[{
                        name: 'numeros',
                        data: [1,2,3,4]
                    }]"
                    :data-labels="['uno', 'dos', 'tres', 'cuatro']">
                </component-chart-general>
            </div>
            <div class="column is-4">
                <component-chart-line 
                    :data-sources="[{
                        name: 'numeros',
                        data: [1,2,6,3]
                    }, {
                        name: 'numeros',
                        data: [2,6,3,10]
                    }]"
                    :data-labels="['uno', 'dos', 'tres', 'cuatro']">
                </component-chart-line>
            </div>
            <div class="column is-4">
                <component-chart-bar 
                    :data-sources="[{
                        name: 'numeros',
                        data: [1,2,3,4]
                    }]"
                    :data-labels="['uno', 'dos', 'tres', 'cuatro']">
                </component-chart-bar>
            </div>
        </div>

<!--         <div class="columns">
            <div class="column is-4">
                <component-chart-line 
                    :data-sources="[{
                        name: 'numeros',
                        data: [1,2,6,3]
                    }]"
                    :data-labels="['uno', 'dos', 'tres', 'cuatro']"
                    :options="this.ooptions">
                </component-chart-line>
            </div>
        </div> -->
        


    </section>
</template>
