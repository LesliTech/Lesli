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
export default {
    data() {
        return {
            text: "",
            show: false,
            timer: null,
            columns: [],
            records: [],
            highlight_tag: {
                start: '<span class="tag is-primary">',
                end: '</span>'
            }
        }
    },
    methods: {

        getSearch() {

            let text = (this.filterNonEnglishLetters(this.text) || '').replace(/[+*]/g, '')

            if (text === '') { return }

            let words_to_highlight = this.text.toLowerCase()
                .split(/(\s+)/)
                .filter( e => e.trim().length > 0)
                .map(e => this.filterNonEnglishLetters(e))

            let url = this.url.search(this.lesli.engine, text)
            if(this.data.global_search && this.data.global_search.order){
                url = url.order(
                    this.data.global_search.order.sorting_field || 'id',
                    this.data.global_search.order.sorting_order || 'asc'
                )
            }

            this.http.get(url).then(result => {

                this.records = result.data.records.map(record => {
                    for(var key in record) {
                        if (key == 'id') {
                            continue
                        }

                        record[key]=this.doHighlightText(record[key] ? record[key] : '', words_to_highlight)
                    }

                    return record

                })

                this.columns = result.data.columns.map(column => {

                    // If the columns are objects, we interpret them as such. Otherwise, we asume they are strings
                    if(typeof column === 'object'){
                        return {
                            field: column.field,
                            label: column.label
                        }
                    }else{
                        return {
                            field: column,
                            label: column
                        }
                    }
                })

                this.show = true
                this.$nextTick(() => { window.scrollTo(0,0) })

            }).catch(error => {
                console.log(error)
            })
        },

        doHighlightText(text_to_highlight, words_to_highlight) {

            // return same string if search tearm is not present
            if (words_to_highlight.length === 0) {
                return text_to_highlight
            }

            let iQuery = new RegExp(`${words_to_highlight.join('|')}`, 'ig');

            text_to_highlight = text_to_highlight
            .toString().replace(iQuery, (matchedText, _a, _b)=>{
                return `${this.highlight_tag.start}${matchedText}${this.highlight_tag.end}`
            })

            return text_to_highlight

        },

        filterNonEnglishLetters(text) {

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

        },

        goToRecord(record){
            if(record && record.url){
                // Since the url can be highlighted, we replace the start and end tags when redirecting to it.
                this.url.go(record.url.replace(this.highlight_tag.start, '').replace(this.highlight_tag.end, ''))
            }
        }

    },
    watch: {

        'data.global.search': function(text) {

            if (text == "") {
                this.show = false
                return 
            }

            this.text = text

            clearTimeout(this.timer)

            this.timer = setTimeout(() => this.getSearch(), 800)

        }

    }

}
</script>
<template>
    <section v-if="show" class="application-global-search">
        <div class="content">
            <h4 v-if="data.global_search && data.global_search.title">
                {{data.global_search.title}}
            </h4> 
        </div>
    </section>
</template>
