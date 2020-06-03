<script>
export default {
    data() {
        return {
            text: "",
            show: false,
            timer: null,
            projects: [],
            translations: {
                projects: I18n.t('haus.projects')
            }
        }
    },
    mounted() {
        this.initListeners()
    },
    methods: {
        initListeners() {
            this.bus.subscribe("search:/core/layouts/component-global-search", text =>{
                this.text = text
            })
        },
        getSearch() {
            this.http.get(`/house/projects/search/${this.text}`).then(result => {
                this.projects = result.data
                this.projects.forEach(project => {
                    for(var key in project) {
                        if (key == 'id') {
                            continue
                        } else if (key == 'code') {
                            project['project_code'] = project[key]
                        }

                        project[key]=this.doHighlightText(project[key] ? project[key] : '', this.text)
                        
                    }
                })
                this.show = true
                this.$nextTick(()=>{
                    window.scrollTo(0,0)
                })
            }).catch(error => {
                console.log(error)
            })
        },
        goToProject(project) {
            this.url.go(`/crm/projects/${project.project_code}`)
        },
        doHighlightText(text_to_highlight, text_to_search) {

            // return same string if search tearm is not present
            if (text_to_search === '') {
                return text_to_highlight
            }

            text_to_highlight = text_to_highlight.toString()
            text_to_highlight = text_to_highlight.toLowerCase()
            text_to_search = text_to_search.toLowerCase()

            // remove some special german characters
            text_to_highlight = text_to_highlight.replace('ü', 'u')
            text_to_search = text_to_search.replace('ü', 'u')

            let iQuery = new RegExp(text_to_search, "ig")
            return text_to_highlight.toString().replace(iQuery, function(matchedText,a,b){
                return ('<span class=\'tag is-primary\'>' + matchedText + '</span>');
            })

        }
    },
    watch: {
        text() {
            if (this.text == "") {
                this.show = false
                return 
            }
            clearTimeout(this.timer)
            this.timer = setTimeout(() => {
                this.getSearch()
            }, 800);
        }
    }
}
</script>
<template>
    <section v-if="show" class="application-global-search">
        <div class="content">
            <h4>{{translations.projects.title}}</h4>
            <b-table 
                @click="goToProject"
                :data="projects" 
                :hoverable="true" 
                :striped="true">
                <template slot-scope="props">

                    <b-table-column field="code" :label="translations.projects.table_header_code" sortable v-html="props.row.code">
                    </b-table-column>

                    <b-table-column field="status" :label="translations.projects.table_header_status" sortable v-html="props.row.status">
                    </b-table-column>

                    <b-table-column field="customer" :label="translations.projects.table_header_customer" sortable v-html="props.row.customers">
                    </b-table-column>

                    <b-table-column field="city" :label="translations.projects.form_property_input_city_title" sortable v-html="props.row.city">
                    </b-table-column>

                    <b-table-column field="postcode" :label="translations.projects.form_customers_input_postcode_title" sortable v-html="props.row.postcode">
                    </b-table-column>

                    <b-table-column field="street_name" :label="translations.projects.form_property_input_street_name_title" sortable v-html="props.row.street_name">
                    </b-table-column>

                    <b-table-column field="street_number" :label="translations.projects.form_property_input_street_number" sortable v-html="props.row.street_number">
                    </b-table-column>

                    <b-table-column field="telephone" :label="translations.projects.form_customers_input_phone_title" sortable v-html="props.row.telephone">
                    </b-table-column>

                    <b-table-column field="company" label="Kop" sortable v-html="props.row.company">
                    </b-table-column>

                </template>
            </b-table>            
        </div>
    </section>
</template>
<style>
    .application-global-search span.tag {
        font-size: initial;
        height: initial;
        padding: 0px 6px;
    }
</style>
