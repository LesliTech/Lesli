



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



// · Import frameworks, libraries & tools
import { expect } from "chai"
import { createApp } from "vue"


// · plugins to be tested
import pluginUrl from "../../vue/plugins/url.js"


// · build & prepare app to be tested
const vm = createApp({})
vm.use(pluginUrl, { root: "http://lesli.test" })


// · 
describe("VUE/PLUGINS/URL", () => {

    describe("Build URL for admin", () => {
        
        it("should build a url for /administration/users", () => {

            var url = vm.config.globalProperties.url.admin("users").toString()
            expect(url).to.be.a("string");
            expect(url).to.equal("/administration/users.json");
            
        });

        it("should build a url for /administration/users/list", () => {

            var url = vm.config.globalProperties.url.admin("users/list").toString()
            expect(url).to.be.a("string");
            expect(url).to.equal("/administration/users/list.json");
            
        });

        it("should build a url for /administration/users/options", () => {

            var url = vm.config.globalProperties.url.admin("users/options").toString()
            expect(url).to.be.a("string");
            expect(url).to.equal("/administration/users/options.json");
            
        });

        it("should build a url for an specific user", () => {

            var url = vm.config.globalProperties.url.admin("users/:id", 777).toString()
            expect(url).to.be.a("string");
            expect(url).to.equal("/administration/users/777.json");
            
        });


        it("should build a url for an specific user through object params", () => {

            var url = vm.config.globalProperties.url.admin("users/:id", { id: 777 }).toString()
            expect(url).to.be.a("string");
            expect(url).to.equal("/administration/users/777.json");
            
        });

        /*
    
        this.url.admin("users/:id", 777)
        this.url.admin("users/:id", { id: 777 })
        //-> /administration/users/777
    
        this.url.admin("users").search("ldonis")
        //-> /administration/users?search=ldonis
    
        this.url.admin("users").search("ldonis").paginate(2)
        //-> /administration/users?search=ldonis&page=2
    
        this.url.admin("users").search("ldonis").paginate(2, 15)
        //-> /administration/users?search=ldonis&page=2&perPage=15
    
        this.url.admin("users").order("name", "desc")
        //-> /administration/users?orderBy=name&order=desc
    
        this.url.admin("users").order("name", "desc").toString(true)
        //-> /administration/users.json?orderBy=name&order=desc

        */
       
    })
    
});
