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
import componentBaseTable from "LesliWidgets/base/table.vue"

import componentCoreHelloWorld from "LesliWidgets/core/hello-world.vue"
import componentCoreListSessions from "LesliWidgets/core/list-sessions.vue"
import componentDriverShowToday from "LesliWidgets/cloud_driver/show-today.vue"
import componentDriverListEvents from "LesliWidgets/cloud_driver/list-events.vue"
import componentDriverShowCalendar from "LesliWidgets/cloud_driver/show-calendar.vue"
import componentFocusChartTasks from "LesliWidgets/cloud_focus/chart-tasks.vue"


// · 
export default {
    components: {
        'component-base-table': componentBaseTable,

        'component-core-hello-world': componentCoreHelloWorld,
        'component-core-list-sessions': componentCoreListSessions,

        'component-driver-show-today': componentDriverShowToday,
        'component-driver-list-events': componentDriverListEvents,
        'component-driver-show-calendar': componentDriverShowCalendar,

        'component-focus-chart-tasks': componentFocusChartTasks,
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
                component_id: "core-list-sessions",
                custom_configuration: {},
                query_configuration: {}
            }, {
                name: "hello world",
                component_id: "core-hello-world",
                layout: 2,
            }, {
                name: "events",
                component_id: "driver-show-calendar",
                layout: 5,
            }, {
                name: "today",
                component_id: "driver-show-today",
                layout: 2,
            }, {
                name: "Upcoming events",
                component_id: "driver-list-events",
                layout: 5,
            }, {
                name: "My tasks",
                component_id: "focus-chart-tasks",
                layout: 5,
            }, {
                name: "table",
                component_id: 'base-table',
                layout: 5,
                url: "/administration/users/8/sessions.json",
                columns: [ 'user_agent', 'created_at_date'],
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


    </section>
</template>
