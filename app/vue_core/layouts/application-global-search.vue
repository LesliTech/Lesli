<script>
export default {
    data() {
        return {
            text: "",
            show: false,
            timer: null,
            projects: []
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
                    for(var dato in project) {
                        if (dato == 'id') {
                            continue
                        }
                        project[dato]=this.doHighlightText(project[dato] ? project[dato] : '', this.text)
                    }
                })
                this.show = true
            }).catch(error => {
                console.log(error)
            })
        },
        goToProject(project) {
            this.url.go("/crm/projects/"+project.id)
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
            <h4>Projects</h4>
            <b-table 
                @click="goToProject"
                :data="projects" 
                :hoverable="true" 
                :striped="true">
                <template slot-scope="props">

                    <b-table-column field="code" label="Code" sortable v-html="props.row.code">
                    </b-table-column>

                    <b-table-column field="name" label="Name" sortable v-html="props.row.name">
                    </b-table-column>

                    <b-table-column field="postcode" label="Postcode" sortable v-html="props.row.postcode">
                    </b-table-column>

                    <b-table-column field="street_name" label="Street" sortable v-html="props.row.street_name">
                    </b-table-column>

                    <b-table-column field="city" label="City" sortable v-html="props.row.city">
                    </b-table-column>

                    <b-table-column field="telephone" label="Telephone" sortable v-html="props.row.telephone">
                    </b-table-column>

                    <b-table-column field="email" label="Email" sortable v-html="props.row.email">
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
