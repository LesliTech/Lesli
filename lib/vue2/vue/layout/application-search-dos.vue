<script>
/*

Copyright (c) 2020, all rights reserved.

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
export default {
    data() {
        return {
            text: "",
            show: false,
            timer: null,
            columns: [],
            records: [],
            translations: {
            }
        }
    },
    methods: {

        getSearch() {

            let text = (this.filterNonEnglishLetters(this.text) || '').replace(/[+*]/g, '')

            if (text === '') { return }

            let words_to_highlight = this.text.toLowerCase()
                .split(/(\s+)/)
                .filter( e => e.trim().length > 0)
                .map(e => this.filterNonEnglishLetters(e))

            this.http.get(this.url.search(this.lesli.engine, text)).then(result => {

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
                    return {
                        field: column,
                        label: column
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
            .toString().replace(iQuery, function(matchedText, a, b){
                return `<span class="tag is-primary"> ${matchedText} </span>`
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
        <b-table :data="records" :columns="columns">
            <template slot-scope="props">
                <template v-for="(text, index) in props.row">
                    <b-table-column :key="index" v-html="text">
                    </b-table-column>
                </template>
            </template>
        </b-table>
    </section>
</template>
