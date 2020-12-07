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


// · Plugin initializing 
export default {

    install (Vue, options) {

        Vue.prototype.url = {

            // · Redirect to specific url
            go(url=null) {
                url = new URL(url, options.root)
                window.location.href = url.href;
            },

            // · Get well formated url
            to(path=null) {

                if (path) {
                    return new URL(path, options.root);
                }

                return new URL("/", options.root);

            }

        } 

        class LesliUrl {

            constructor(base_path, api=true) {
                this.base_path = base_path
                this.parsedPath = ""
                this.query = {}
                this.api = api
                this.url=""
            }

            toString() {
                return this.url.toString()
            }

            build() {

                let url = ""

                if (this.parsedPath != "") {
                    url = url.concat("/").concat(this.parsedPath)
                }

                if (this.api) {
                    url = url.concat(".json")
                }

                url = url.concat(this.parseQuery(this.query))

                this.url = new URL(url, this.base_path)

                return this

            }

            parsePath(path, params = {}) {

                const remainingParams = { ...params };

                const renderedPath = path.replace(/:[_A-Za-z][_A-Za-z0-9]*/g, p => {
                    const key = p.slice(1);
                    delete remainingParams[key];
                    return encodeURIComponent(params[key])
                })

                return renderedPath

            }

            parseQuery(query) {
                query =( new URLSearchParams(query)).toString()
                return query == "" ? "" : "?".concat(query)
            }

            search(text) {
                this.query["search"] = text
                return this.build()
            }

            paginate(page, perPage=0) {
                this.query["page"] = page
                if (perPage > 0) {
                    this.query["perPage"] = perPage
                }
                return this.build()
            }

            order(column, direction=null) {
                this.query["orderBy"] = column
                if (direction) {
                    this.query["order"] = direction
                }
                return this.build()
            }

            engine(engine, path, params) {
                this.parsedPath = engine.concat("/").concat(this.parsePath(path, params))
            }


        }
    
        Vue.prototype.url2 = {

            admin(path, params={}) {
                let url = new LesliUrl(options.root)
                url.engine("administration", path, params)
                return url.build()
            }

        }

    }
    
}
