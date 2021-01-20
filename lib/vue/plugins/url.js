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


        // · URL builder for Lesli 
        class LesliUrl {


            constructor(base_path) {
                this.base_path = base_path
                this.parsedPath = ""
                this.query = {}
                this.url=""
            }


            // parse, join and create a well formated url object
            _build(api=false) {

                let url = ""

                // if path exists for the url
                if (this.parsedPath != "") {
                    url = url.concat("/").concat(this.parsedPath)
                }

                // normally all the requests are sent to the internal Lesli api
                // so, the requests should include the json suffix
                if (api) {
                    url = url.concat(".json")
                }

                // concat query string if available
                url = url.concat(this._parseQuery(this.query))

                // build a native URL object
                // this.url = new URL(url, this.base_path)
                this.url = url

                // return this to enable methods chaining pattern
                return this

            }


            // parse a string template into a string path
            // example: domain.com/user/:id, { id: 1 }
            // result: domain.com/user/1 
            // this is good to avoid string interpolation :)
            _parsePath(path, params = {}) {

                // remaining params are useful if we want to work with the params
                // that does not belongs to a any part of the path template
                //const remainingParams = { ...params };

                const renderedPath = path.replace(/:[_A-Za-z][_A-Za-z0-9]*/g, p => {
                    const key = p.slice(1);
                    //delete remainingParams[key];
                    return encodeURIComponent(params[key])
                })

                return renderedPath

            }


            // convert a key value object into a standard queryString. This custom implementation
            // supports deep object parsing and array parsing
            // example: { name: {first: "luis"}, age: 25 }
            // result: domain.com?name[first]=luis&age=25
            _parseQuery(query) {
                function recursion(query, path) {
                    if (Array.isArray(query)) {
                        query.forEach(function (element) {
                            recursion(element, path + '[]')
                        })
                        return
                    }
                    if (query !== null && typeof query === 'object') {
                        Object.keys(query).forEach(function (param) {
                            recursion(query[param], path + '[' + param + ']')
                        });
                        return
                    }
                    data.push(path + '=' + query)
                }
            
                var data = []
                Object.keys(query).forEach(function (param) {
                    recursion(query[param], param)
                })

                return "?".concat(data.join('&'))
            }


            // convert the url object to string automatically if object as string is needed
            toString(api=false) {
                this._build(api)
                return this.url
            }



            // insert search param into query string
            search(text) {
                this.query["search"] = text
                return this._build()
            }


            // insert pagination params into query string
            paginate(page, perPage=0) {
                this.query["page"] = page
                if (perPage > 0) {
                    this.query["perPage"] = perPage
                }
                return this._build()
            }


            // insert order params into query string
            order(column, direction=null) {
                this.query["orderBy"] = column
                if (direction) {
                    this.query["order"] = direction
                }
                return this._build()
            }


            // build a url for a specific engine
            engine(engine, path, params) {
                this.parsedPath = engine.concat("/").concat(this._parsePath(path, params))
                return this._build()
            }

            filters(filters){
                this.query["filters"] = filters

                return this._build()
            }


        }
    
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

            },

            // · Build a url for core resources
            lesli(path, params={}) {
                let url = new LesliUrl(options.root)
                url.parsedPath = url._parsePath(path, params)
                return url._build()
            },

            // · Build a url for administration area
            admin(path, params={}) {
                let url = new LesliUrl(options.root)
                return url.engine("administration", path, params)
            },

            // · Build a url for administration area
            bell(path, params={}) {
                let url = new LesliUrl(options.root)
                return url.engine("bell", path, params)
            },

            // · Build a url for administration area
            text(path, params={}) {
                let url = new LesliUrl(options.root)
                return url.engine("text", path, params)
            },

            // · Build a url for mailer module
            mailer(path, params={}) {
                let url = new LesliUrl(options.root)
                return url.engine("mailer", path, params)
            },

            // · Build a url for CloudProposal area
            proposal(path, params={}) {
                let url = new LesliUrl(options.root)
                return url.engine("proposal", path, params)
            },

        }

    }
    
}
