<script>
export default {
    data() {
        return {
            text: "",
            show: false,
            timer: null,
            projects: [],
            translations: {
                dl: {
                    projects: I18n.t('deutscheleibrenten.projects'),
                    shared: I18n.t('deutscheleibrenten.shared')
                }
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
            let text = this.searchGermanCharacters(this.text)
            let words_to_highlight = this.text.toLowerCase()
                                        .split(/(\s+)/)
                                        .filter( e => e.trim().length > 0)
                                        .map(e => {
                                            return this.searchGermanCharacters(e)
                                        })

            this.http.get(`/house/projects/search/${text}?orderColumn=CHWS.number&order=asc`).then(result => {
                this.projects = result.data
                this.projects.forEach(project => {
                    for(var key in project) {
                        if (key == 'id') {
                            continue
                        } else if (key == 'code') {
                            project['project_code'] = project[key]
                        }

                        project[key]=this.doHighlightText(project[key] ? project[key] : '', words_to_highlight)
                        
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
        doHighlightText(text_to_highlight, words_to_highlight) {
            // return same string if search tearm is not present
            if (words_to_highlight.length === 0) {
                return text_to_highlight
            }

            words_to_highlight.forEach(word_to_search => {
                let iQuery = new RegExp(word_to_search, 'ig');
                text_to_highlight = text_to_highlight.toString().replace(iQuery, function(matchedText,a,b){
                    return ('<span class=\'tag is-primary\'>' + matchedText + '</span>');
                })
            })

            return text_to_highlight

        },
        searchGermanCharacters(text){
            if (text.includes("ä")){
                return text.replace("ä", "(ä|ae)") 
            } else if (text.includes("ae")){
                return text.replace("ae", "(ä|ae)") 
            } else if (text.includes("ü")){
                return text.replace("ü", "(ü|ue)")                 
            }else if (text.includes("ue")){
                return text.replace("ue", "(ü|ue)") 
            }else if (text.includes("ö")){
                return text.replace("ö", "(ö|oe)") 
            }else if (text.includes("oe")){
                return text.replace("oe", "(ö|oe)")                 
            } else {
                return text
            }
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
            <h4>{{translations.dl.projects.title}}</h4>
            <b-table 
                @click="goToProject"
                :data="projects" 
                :hoverable="true" 
                :striped="true">
                <template slot-scope="props">

                    <b-table-column field="code" :label="translations.dl.projects.table_header_code" sortable v-html="props.row.code">
                    </b-table-column>

                    <b-table-column field="status" :label="translations.dl.projects.table_header_status" sortable v-html="props.row.status">
                    </b-table-column>

                    <b-table-column field="customer" :label="translations.dl.projects.table_header_customer" sortable v-html="props.row.customers">
                    </b-table-column>

                    <b-table-column field="city" :label="translations.dl.projects.form_property_input_city_title" sortable v-html="props.row.city">
                    </b-table-column>

                    <b-table-column field="postcode" :label="translations.dl.projects.form_customers_input_postcode_title" sortable v-html="props.row.postcode">
                    </b-table-column>

                    <b-table-column field="street_name" :label="translations.dl.projects.form_property_input_street_name_title" sortable v-html="props.row.street_name">
                    </b-table-column>

                    <b-table-column field="street_number" :label="translations.dl.projects.form_property_input_street_number" sortable v-html="props.row.street_number">
                    </b-table-column>

                    <b-table-column field="telephone" :label="translations.dl.projects.form_customers_input_phone_title" sortable v-html="props.row.telephone">
                    </b-table-column>

                    <b-table-column field="company" :label="translations.dl.shared.text_kop" sortable v-html="props.row.company">
                    </b-table-column>

                    <b-table-column field="user_main" :label="translations.dl.shared.text_employee" sortable v-html="props.row.user_main">
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
