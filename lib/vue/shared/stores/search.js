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
import { defineStore } from "pinia"
import { reactive } from "vue"


// · 
export const useSearch = defineStore("search", {
    state: () => {
        return {
            text: "",
            timer: null,
            loading: false,
            showResults: false,

            pagination: {},
            columns: [],
            records: []
        }
    },
    actions: {

        doSearch() {

            if (this.text == "") {
                this.showResults = false
                return 
            }

            this.loading = true

            clearTimeout(this.timer)

            this.timer = setTimeout(() => this.fetchSearch(), 800)

        }, 

        fetchSearch() {
            this.loading = true

            // filter german characteres and replace for strings
            // that will be replaced in the highlight method
            var wordsToHighlight = this.text.toLowerCase()
                .split(/(\s+)/)
                .filter( e => e.trim().length > 0)
                .map(e => this.filterNonEnglishLetters(e))

            // TODO: this url must be dynamically, according to the engine where we are searching
            let url = this.url.dl("search").search(this.text)

            // searching... :) 
            this.http.get(url).then(result => {
                this.pagination = result.pagination
                this.columns = result.columns
                this.records = result.records.map(record => {
                    
                    // iterate over every column in the search result
                    for(var key in record) {

                        // do not highlight the id column
                        if (key == 'id') continue;

                        // highlight the text in the search result if match with the text
                        // we want to search 
                        record[key] = this.doHighlightText(record[key], wordsToHighlight)
                    }

                    return record
                })
            }).catch(error => {
                console.log(error)
            }).finally(() => {
                this.loading = false
            })
        },

        doHighlightText(textToHighlight, wordsToHighlight) {

            if (!textToHighlight) return ;

            // return same string if search tearm is not present
            if (wordsToHighlight.length === 0) {
                return text_to_highlight
            }

            // working with german characteres
            let iQuery = new RegExp(`${wordsToHighlight.join('|')}`, 'ig');

            textToHighlight = textToHighlight.toString()
            // replace the matched strings in the results with the text search term
            // with a tag, so we can highlight the matching results
            .replace(iQuery, (matchedText, _a, _b)=>{
                return `<span class="tag is-primary">${matchedText}</span>`
            })

            return textToHighlight

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
    }
})
