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



// · URL #builder for Lesli
class LesliUrl {
    
    #params = "";
    #base_url = "";
    #query = {};
    #path = "";
    #url = "";
    
    constructor(base_url, path, params) {
        this.#base_url = base_url
        this.#params = params
        this.#path = path
    }
    
    
    // build a url for resources mounted at root level
    // this happens on builders engines like MW.
    root(path, params) {
        
        this.#path = ""
        
        // process path template if provided
        if (path) this.#path = this.#path.concat(this.#parsePath(path, params));
        
        return this
        
    }
    
    
    // build a url for a specific engine
    engine(engine, path, params) {
        
        // manually add a slash due we are not using native JS url builders
        engine = engine.concat("/")
        
        // return url for the root of the engine
        if (!path) return this.root(engine, params);
        
        // include the engine as part of the path
        return this.root(engine.concat(path), params)
        
    }
    
    
    // insert order params into query string
    order(column, direction="asc") {
        
        this.#query["orderBy"] = column
        
        if (direction) {
            this.#query["order"] = direction
        }
        
        return this.#build()
        
    }
    
    
    // add standard query param to request paginated data to the server
    paginate(page, perPage=15) {
        this.#query["page"] = page
        this.#query["perPage"] = perPage
        return this.#build()
    }
    
    
    // add standard query param to request search to the server
    search(text) {
        if (!!text) {
            this.#query["search"] = text
        }
        return this.#build()
    }
    
    group(text) {
        if (!!text) {
            this.#query["group"] = text
        }
        return this.#build()
    }
    
    
    // add standard query params to request filtered data from the server
    filter(filters) {
        
        let keys = Object.keys(filters)
        
        if (!this.#query.f) {
            this.#query["f"] = {}
        }
        
        keys.forEach(key => {
            this.#query.f[key] = filters[key].join(',')
        })
        
        return this.#build()
        
    }


    // allow to add custom query params
    query(key, value) {
        this.#query[key] = value
        return this.#build()
    }
    
    
    // automatically add auth token if exists in the url query string
    tokenUrl() {
        let urlParams = new URLSearchParams(window.location.search);
        this.#query["t"] = urlParams.get("t")
        return this.#build()
    }


    // automatically add auth token if exists in the url query string as param
    tokenShared() {

        // get the token from a "signed" url with format:
        // /shared/public/:token/help/tickets/new
        // for this kind of "signed" url token is always at position 4 of the string
        let url = window.location.pathname.split('/')[3];

        // attach the token as opaque token so the public api is able authenticate the request
        this.#query["t"] = url

        return this.#build()
    }
    
    
    // convert the url object to string automatically if object as string is needed
    toString(extension=null) {
        
        this.#build(extension)
        
        return this.#url.toString()
        
    }
    
    
    // alias for toString() method
    get s() {
        return this.toString()
    }
    
    
    // add json extension to the url 
    json() {
        return this.toString(".json")
    }
    
    
    // add pdf extension to the url 
    pdf() {
        return this.toString(".pdf")
    }
    
    
    // perform a redirect action after #build an url
    // be sure to call this method last always
    go() {
        this.#build()
        window.location.href = this.#url.toString()
    }
    
    
    // parse, join and create a well formated url object
    #build(extension=null) {
        
        // root
        let url = "/"
        
        // if path exists for the url
        if (this.#path != "") {
            url = url.concat(this.#path)
        }
        
        // normally all the requests are sent to the internal Lesli api
        // so, the requests should include the json suffix
        if (extension) {
            url = url.concat(extension)
        }
        
        // concat query string if available
        url = url.concat(this.#parseQuery(this.#query))
        
        // #build a native URL object
        this.#url = url
        
        
        // return this to enable methods chaining pattern
        return this
        
    }
    
    
    // parse a string template into a string path
    // examples:
    //      domain.com/user/:id, { id: 1 }
    //      domain.com/user/:id, 1
    // result: domain.com/user/1
    // this is good to avoid string interpolation :)
    #parsePath(path, params = {}) {
        
        // shortcut to get specific resource through id
        if (typeof params == 'string' || typeof params == 'number') {
            params = { id: params }
        }
        
        // remaining params are useful if we want to work with the params
        // that does not belongs to a any part of the path template
        const remainingParams = { ...params };
        
        // compile the string template to assign values to the variables
        const renderedPath =  path.replace(/:[_A-Za-z][_A-Za-z0-9]*/g, p => {
            let key = p.slice(1);
            delete remainingParams[key];
            return encodeURIComponent(params[key])
        })
        
        for (let param in remainingParams) {
            this.#query[param] = remainingParams[param]
        }
        
        return renderedPath
        
    }
    
    
    // convert a key value object into a standard queryString. This custom implementation
    // supports deep object parsing and array parsing
    // example: { name: {first: "luis"}, age: 25 }
    // result: domain.com?name[first]=luis&age=25
    #parseQuery(query) {
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
    
    
}



export function useUrl() {
    
    const root = "/"
    
    return {
        
        // · Redirect to specific url
        go(url="/") {
            document.location.href = url;
        },
        
        // · Get well formated url
        to(path=null) {
            
            if (path) {
                return root.concat(path)
            }
            
            return root
            
        },
        
        // · Build a url for core requests
        root(path, params={}) {
            return (new LesliUrl()).root(path, params)
        },
        
        // · Build a url for administration area
        profile(path, params={}) {
            return (new LesliUrl()).engine("administration/profile", path, params)
        },
        
        // · Build a url for core administration area
        admin(path, params={}) {
            return (new LesliUrl()).engine("administration", path, params)
        },
        
        // · Build a url for CloudAudit engine
        audit(path, params={}) {
            return (new LesliUrl()).engine("audit", path, params)
        },
        
        // · Build a url for CloudBabel engine
        babel(path, params={}) {
            return (new LesliUrl()).engine("babel", path, params)
        },
        
        // · Build a url for CloudBell engine
        bell(path, params={}) {
            return (new LesliUrl()).engine("bell", path, params)
        },
        
        // · Build a url for CloudHelp engine
        help(path, params={}) {
            return (new LesliUrl()).engine("help", path, params)
        },

        // · Build a url for CloudMailer engine
        mailer(path, params={}) {
            return (new LesliUrl()).engine("mailer", path, params)
        },
        
        // · Build a url for CloudTalk engine
        talk(path, params={}) {
            return (new LesliUrl()).engine("talk", path, params)
        },
        
        // · Build a url for CloudFocus engine
        focus(path, params={}) {
            return (new LesliUrl()).engine("focus", path, params)
        },

        // · Build a url for CloudTime engine
        time(path, params={}) {
            return (new LesliUrl()).engine("time", path, params)
        },
        
        // · Build a url for CloudDriver engine
        driver(path, params={}) {
            return (new LesliUrl()).engine("driver", path, params)
        },
        
        // · Build a url for CloudSocial engine
        social(path, params={}) {
            return (new LesliUrl()).engine("social", path, params)
        },
        
        // · Build a url for CloudWord engine
        word(path, params={}) {
            return (new LesliUrl()).engine("word", path, params)
        },
        
        // · Build a url for CloudTeam engine
        team(path, params={}) {
            return (new LesliUrl()).engine("team", path, params)
        },
        
        // · Build a url for CloudScraper engine
        scraper(path, params={}) {
            return (new LesliUrl()).engine("scraper", path, params)
        },
        
        // · Build a url for CloudShared engine
        shared(path, params={}) {
            return (new LesliUrl()).engine("shared", path, params)
        },

        // · Build a url for CloudAuthority engine
        authority(path, params={}) {
            return (new LesliUrl()).engine("authority", path, params)
        }
    }
}
