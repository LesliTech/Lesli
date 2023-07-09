/*

Lesli

Copyright (c) 2023, Lesli Technologies, S. A.

This program is free software: you can redistribute it and/or modify
it under the terms of the GNU General Public License as published by
the Free Software Foundation, either version 3 of the License, or
(at your option) any later version.

This program is distributed in the hope that it will be useful,
but WITHOUT ANY WARRANTY; without even the implied warranty of
MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the
GNU General Public License for more details.

You should have received a copy of the GNU General Public License
along with this program. If not, see http://www.gnu.org/licenses/.

Lesli · Your Smart Business Assistant. 

Made with ♥ by https://www.lesli.tech
Building a better future, one line of code at a time.

@contact  hello@lesli.tech
@website  https://lesli.tech
@license  GPLv3 http://www.gnu.org/licenses/gpl-3.0.en.html

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
