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
import componentCoreListSessionsActive from "LesliWidgetsCore/list-sessions-active.vue"
import componentPortalHelloWorld from "CloudPortalWidgets/hello-world.vue"


// · 
export default {
    components: {
        "component-core-list-sessions-active": componentCoreListSessionsActive,
        "component-portal-hello-world": componentPortalHelloWorld
    },
    props: {
        engine: String
    },
    data() {
        return {
            dashboard: {}
        }
    },
    mounted() {
        //this.getDefaultDashboard()
        this.dashboard = {
            "id": 1,
            "name": "Default Dashboard",
            "default": true,
            "main": false,
            "user_main_id": null,
            "deleted_at": null,
            "created_at": "2021-07-12T19:26:52.028Z",
            "updated_at": "2021-07-12T19:26:52.028Z",
            "cloud_portal_accounts_id": 1,
            "users_id": null,
            "roles_id": null,
            "components": [{
                "id": 1,
                "name": "Active sessions",
                "component_id": "core-list-sessions-active",
                "layout": 4,
                "index": 0,
                "query_configuration": {
                    "filters": {},
                    "pagination": {
                        "per_page": 6
                    }
                },
                "custom_configuration": {
                    "arrangement": {}
                },
                "deleted_at": null,
                "created_at": "2021-07-12T19:26:52.034Z",
                "updated_at": "2021-07-12T19:26:52.034Z",
                "cloud_portal_dashboards_id": 1,
                "component_ids": null
            }, {
                name: "visitantes",
                component_id: "portal-hello-world",
                layout: 2,
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
        <component-header></component-header>

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
