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


    // convert the url object to string automatically if object as string is needed
    toString(extension=null) {

        this.#build(extension)
        
        return this.#url.toString()

    }


    // perform a redirect action after #build an url
    // be sure to call this method last always
    go() {
        this.#build()
        window.location.href = this.#url.toString()
    }

    json() {
        return this.toString(".json")
    }

    pdf() {
        return this.toString(".pdf")
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

        // compile the string template to assign values to the variables
        return path.replace(/:[_A-Za-z][_A-Za-z0-9]*/g, p => {
            let key = p.slice(1);
            return encodeURIComponent(params[key])
        })

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
        
        // · Build a url for CloudTalk engine
        talk(path, params={}) {
            return (new LesliUrl()).engine("talk", path, params)
        },
        
        // · Build a url for MitwerkenCloud engine
        mitwerken(path, params={}) {
            return (new LesliUrl()).root(path, params)
        },
    }

}
