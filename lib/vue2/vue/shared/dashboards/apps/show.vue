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


// · List of Imported Components
// · ~·~     ~·~     ~·~     ~·~     ~·~     ~·~     ~·~     ~·~     ~·~     ~·~     ~·~     ~·~
import componentForm from "../components/form.vue"


export default {

    props: {
        cloudEngine: {
            type: String,
            required: true
        },

        engineNamespace: {
            type: String,
            required: true
        },
        renderComponents: {
            required: true
        },
        appMountPath: {
            type: String,
            default: ''
        },
        newResourceAnchorPath: {
            type: String,
            default: null
        },
        newResourceAnchorText: {
            type: Function,
            default: null
        }
    },
    
    components: {
        'component-form': componentForm
    },

    data(){
        return {
            main_route: null,
            dashboard: null,
            translations: {
                main: I18n.t(`${this.cloudEngine.toLowerCase()}.dashboards`),
                dashboards: I18n.t('core.dashboards'),
                core: I18n.t('core.shared')
            },
            render_default_dashboard: false,
            configuration_ready: false,
            dashboard_name: ''
        }
    },

    mounted(){
        this.setMainRoute()
        this.setComponents()
        this.initialize()
    },

    methods: {
        setMainRoute(){
            this.main_route = `/${this.engineNamespace}/dashboards/default.json`
        },

        setComponents(){
            // We configure the components based on the 'renderComponents' prop
            for(let key in this.renderComponents){
                this.$options.components[key] = this.renderComponents[key]
            }
        },

        initialize(){
            if(! this.$route.params.id){
                this.getDefaultDashboard()
            }
            this.configuration_ready = true
        },

        setDashboardName(dashboard_name){
            this.dashboard_name = dashboard_name
        },

        getDefaultDashboard(){
            this.render_default_dashboard = true
            this.http.get(this.main_route).then((result)=>{
                if (result.successful) {
                    this.dashboard = result.data
                }else{
                    this.msg.error(result.error.message)
                }
            }).catch(error => {
                console.log(error)
            })
        }
    },

    watch: {
        '$route'(){
            this.initialize()
        }
    }
}
</script>
<template>
    <section class="application-component app-dashboards">
        <div v-if="configuration_ready">

            <div v-if="render_default_dashboard">
                <component-header 
                    :title="false"
                >
                    <div class="buttons" v-if="newResourceAnchorPath">
                        <router-link class="button" :to="newResourceAnchorPath">
                            <b-icon icon="plus" size="is-small"></b-icon>
                            <span>{{ newResourceAnchorText() }}</span>
                        </router-link>
                    </div>
                </component-header>

                <div class="columns is-multiline" v-if="dashboard">
                    <div v-for="component in dashboard.components" :key="component.id" :class="['column', `is-${component.layout}`]">
                        <component
                            :is="`component-${component.component_id.replace(/\_/g,'-')}`"
                            :dashboard-id="dashboard.id"
                            :component-id="component.id"
                            :name="component.name"
                        >
                        </component>
                    </div>
                </div>
                <component-data-loading v-else>
                </component-data-loading>
            </div>


            <div v-else>
                <component-header 
                    :title="dashboard_name"
                >
                    <div class="navbar-item">
                        <div class="buttons">
                            <router-link class="button" :to="`${appMountPath}/`">
                                <b-icon icon="list" size="is-small" />
                                <span>{{ translations.core.view_btn_list }}</span>
                            </router-link>
                        </div>
                    </div>
                </component-header>
                <component-form
                    :set-dashboard-name="setDashboardName"
                    :render-components="renderComponents"
                    :cloud-engine="cloudEngine"
                    :engineNamespace="engineNamespace"
                    :app-mount-path="appMountPath"
                >
                </component-form>
            </div>

        </div>
    </section>
</template>
