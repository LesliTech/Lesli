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


// · URL builder for Lesli 
class LesliUrl {

    #base_url = "";
    #params = {};
    #query = {};
    #path = "";
    #url = "";

    constructor(base_url, path, params) {
        this.#base_url = base_url
        this.#params = params
        this.#path = path
    }


    // build a url for a specific engine
    engine(engine, path, params) {
        this.#path = engine.concat("/").concat(this.#parsePath(path, params))
        return this
    }


    // convert the url object to string automatically if object as string is needed
    toString() {
        this.build()
        return this.#url.concat(".json")
    }


    // parse, join and create a well formated url object
    build() {

        let url = ""

        // if path exists for the url
        if (this.#path != "") {
            url = url.concat("/").concat(this.#path)
        }

        // normally all the requests are sent to the internal Lesli api
        // so, the requests should include the json suffix

        // concat query string if available
        //url = url.concat(this.#parseQuery(this.query))

        // build a native URL object
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

}


// · 
export default {

    install: (app, options) => {

        app.config.globalProperties.url = {

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

            // · Build a url for administration area
            admin(path, params={}) {
                return (new LesliUrl(options.root)).engine("administration", path, params)
            },

        }

    }
    
}

