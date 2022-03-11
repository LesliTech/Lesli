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

                // shortcut to get specific resource
                if (typeof params == 'string' || typeof params == 'number') {
                    params = { id: params }
                }

                // remaining params are useful if we want to work with the params
                // that does not belongs to a any part of the path template
                const remainingParams = { ...params };

                const renderedPath = path.replace(/:[_A-Za-z][_A-Za-z0-9]*/g, p => {
                    const key = p.slice(1);
                    delete remainingParams[key];
                    return encodeURIComponent(params[key])
                })

                for (let param in remainingParams) {
                    this.query[param] = remainingParams[param]
                }

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
                            recursion(element, path + "[]")
                        })
                        return
                    }
                    if (query !== null && typeof query === "object") {
                        Object.keys(query).forEach(function (param) {
                            recursion(query[param], path + "[" + param + "]")
                        });
                        return
                    }
                    data.push(path + "=" + query)
                }
            
                var data = []
                Object.keys(query).forEach(function (param) {
                    recursion(query[param], param)
                })
            
                if(data.length > 0){
                    return "?".concat(data.join("&"))
                }
            
                return ""
            }


            // convert the url object to string automatically if object as string is needed
            toString(api=false) {
                this._build(api)
                return this.url
            }



            // insert search param into query string
            search(text) {
                if (!!text) {
                    this.query["search"] = text
                }
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
                if(this.query.filters){
                    for(let key in filters){
                        this.query.filters[key] = filters[key]
                    }
                }else{
                    this.query.filters = filters
                }
                return this._build()
            }

            filter(filter) {
                let keys = Object.keys(filter)

                if (!this.query.filters) {
                    this.query.filters = {}
                }

                keys.forEach(key => {
                    this.query.filters[key] = filter[key].join(',')
                })

                return this._build()
            }

            tokenUrl() {
                const urlParams = new URLSearchParams(window.location.search);
                this.query["t"] = urlParams.get("t")
                return this._build()
            }

            dayTimestamp(day){
                if(! day instanceof Date){
                    return this._build()
                }

                let start_date = new Date(day.getTime())
                start_date.setHours(0)
                start_date.setMinutes(0)
                start_date.setSeconds(0)
                start_date.setMilliseconds(0)
                
                // We substract 1 second for the date and add 1 day
                let end_date = new Date(start_date.getTime() - 1000)
                end_date.setDate(end_date.getDate() + 1)

                return this.filters({
                    start_date: start_date.toISOString(),
                    end_date: end_date.toISOString()
                })
            }

            monthTimestamp(month){
                if(! month instanceof Date){
                    return this._build()
                }

                let start_date = new Date(month.getTime())
                start_date.setDate(1)
                start_date.setHours(0)
                start_date.setMinutes(0)
                start_date.setSeconds(0)
                
                // We substract 1 second for the date and add 1 month
                let end_date = new Date(start_date.getTime() - 1000)
                end_date.setMonth(end_date.getMonth() + 1)
                end_date.setDate(1)

                return this.filters({
                    start_date: start_date.toISOString(),
                    end_date: end_date.toISOString()
                })
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

            search(engine, text) {

                engine = engine.replace('cloud_', '').replace('_cloud', '')

                return this[engine]('search').search(text)

            },

            // · Build a url for core resources
            lesli(path, params={}) {
                let url = new LesliUrl(options.root)
                url.parsedPath = url._parsePath(path, params)
                return url._build()
            },

            // · Build a url for administration area
            profile(path, params={}) {
                let url = new LesliUrl(options.root)
                return url.engine("administration/profile", path, params)
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

            // · Build a url for storage area
            storage(path, params={}) {
                let url = new LesliUrl(options.root)
                return url.engine("storage", path, params)
            },

            // · Build a url for team area
            team(path, params={}) {
                let url = new LesliUrl(options.root)
                return url.engine("team", path, params)
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

            // · Build a url for one module
            one(path, params={}) {
                let url = new LesliUrl(options.root)
                return url.engine("one", path, params)
            },

            // · Build a url for CloudThings area
            things(path, params={}) {
                let url = new LesliUrl(options.root)
                return url.engine("inventory", path, params)
            },
            
            // · Build a url for CloudProposal area
            proposal(path, params={}) {
                let url = new LesliUrl(options.root)
                return url.engine("proposal", path, params)
            },

            // · Build a url for CloudProposal area
            audit(path, params={}) {
                let url = new LesliUrl(options.root)
                return url.engine("audit", path, params)
            },

            // · Build a url for CloudHelp area
            help(path, params={}) {
                let url = new LesliUrl(options.root)
                return url.engine("help", path, params)
            },

            // · Build a url for CloudHelp area
            federation(path, params={}) {
                let url = new LesliUrl(options.root)
                return url.engine("cloud", path, params)
            },

            // · Build a url for CloudDriver area
            driver(path, params={}) {
                let url = new LesliUrl(options.root)
                return url.engine("driver", path, params)
            },

            // · Build a url for CloudFocus area
            focus(path, params={}) {
                let url = new LesliUrl(options.root)
                return url.engine("focus", path, params)
            },

            // · Build a url for CloudBabel area
            babel(path, params={}) {
                let url = new LesliUrl(options.root)
                return url.engine("babel", path, params)
            },

            // · Build a url for CloudShared area
            shared(path, params={}) {
                let url = new LesliUrl(options.root)
                return url.engine("shared", path, params)
            },

            // · Build a url for CloudShared public area and links
            sharedPublic(path, params={}) {
                let url = new LesliUrl(options.root)
                return url.engine("shared", "public/".concat(path), params)
            },

            // · Build a url for DeustcheLeibrenten area
            dl(path, params={}) {
                let url = new LesliUrl(options.root)
                return url.engine("crm", path, params)
            },

            // · Build a url for CloudPortal area
            portal(path, params={}) {
                let url = new LesliUrl(options.root)
                return url.engine("portal", path, params)
            },

            // · Build a url for CloudHouse area
            house(path, params={}) {
                let url = new LesliUrl(options.root)
                return url.engine("house", path, params)
            },

            // · Build a url for CloudTalk area
            talk(path, params={}) {
                let url = new LesliUrl(options.root)
                return url.engine("talk", path, params)
            },

            // · Build a url for CloudKb area
            kb(path, params={}) {
                let url = new LesliUrl(options.root)
                return url.engine("kb", path, params)
            },

            // · Build a url for Mitwerken area
            mitwerken(path, params={}) {
                let url = new LesliUrl(options.root)
                url.parsedPath = url._parsePath(path, params)
                return url._build()
            },

            // · Build a url for CloudWork engine
            work(path, params={}) {
                let url = new LesliUrl(options.root)
                return url.engine("work", path, params)
            },

            // · Build a url for CloudRealty engine            
            realty(path, params={}){
                let url = new LesliUrl(options.root)
                return url.engine("realty", path, params)
            }
            
        }

    }
    
}
