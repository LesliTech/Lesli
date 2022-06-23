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
import pluginUrl from "../../../lib/vue3/plugins/url"


// · build & prepare app to be tested
const vm = createApp({})


// · load plugins
vm.use(pluginUrl, { root: "http://lesli.test" })


// · 
describe("VUE/PLUGINS/URL", () => {

    describe("Build URL for custom to", () => {

        it("should build a url for invite", () => {
            var url = vm.config.globalProperties.url.to("invite").toString()
            expect(url).to.be.a("string");
            expect(url).to.equal("http://lesli.test/invite")
        });

    })

    describe("Build URL for application/x", () => {

        ["json", "html", "pdf", "xlsx"].forEach(ext => {
            it(`should build a url for ${ ext.toUpperCase() } request`, () => {
                var url = vm.config.globalProperties.url.admin("users").toString(`.${ ext }`)
                expect(url).to.be.a("string");
                expect(url).to.equal(`/administration/users.${ ext }`)
            });
        })

        it("should build a url with json extension ", () => {
            var url = vm.config.globalProperties.url.admin("users").json()
            expect(url).to.equal("/administration/users.json")
        })

        it("should build a url with pdf extension ", () => {
            var url = vm.config.globalProperties.url.admin("users").pdf()
            expect(url).to.equal("/administration/users.pdf")
        })

    })

    describe("Build URL for admin", () => {
        
        it("should build a url for administration users", () => {
            var url = vm.config.globalProperties.url.admin("users").toString()
            expect(url).to.be.a("string");
            expect(url).to.equal("/administration/users");
        });

        it("should build a url for administration users list", () => {
            var url = vm.config.globalProperties.url.admin("users/list").toString()
            expect(url).to.be.a("string");
            expect(url).to.equal("/administration/users/list");
        });

        it("should build a url for administration users options", () => {
            var url = vm.config.globalProperties.url.admin("users/options").toString()
            expect(url).to.be.a("string");
            expect(url).to.equal("/administration/users/options");
        });

        it("should build a url for an specific user", () => {
            var url = vm.config.globalProperties.url.admin("users/:id", 777).toString()
            expect(url).to.be.a("string");
            expect(url).to.equal("/administration/users/777");
        });


        it("should build a url for an specific user through object params", () => {
            var url = vm.config.globalProperties.url.admin("users/:id", { id: 777 }).toString()
            expect(url).to.be.a("string");
            expect(url).to.equal("/administration/users/777");
        });

    });

    describe("Build URL with with pagination", () => {
        
        it("should build a url for default pagination", () => {
            var url = vm.config.globalProperties.url.admin("users").paginate(1).toString()
            expect(url).to.be.a("string");
            expect(url).to.equal("/administration/users?page=1&perPage=15");
        });

        it("should build a url for paginate page 5", () => {
            var url = vm.config.globalProperties.url.admin("users").paginate(5).toString()
            expect(url).to.be.a("string");
            expect(url).to.equal("/administration/users?page=5&perPage=15");
        });

        it("should build a url for paginate 20 items per page", () => {
            var url = vm.config.globalProperties.url.admin("users").paginate(1,20).toString()
            expect(url).to.be.a("string");
            expect(url).to.equal("/administration/users?page=1&perPage=20");
        });

    });





    describe("Build URL with with order", () => {
        
        it("should build a url with order column", () => {
            var url = vm.config.globalProperties.url.admin("users").order("name").toString()
            expect(url).to.be.a("string");
            expect(url).to.equal("/administration/users?orderBy=name&order=asc");
        });

        it("should build a url with order params", () => {
            var url = vm.config.globalProperties.url.admin("users").order("name", "desc").toString()
            expect(url).to.be.a("string");
            expect(url).to.equal("/administration/users?orderBy=name&order=desc");
        });

    });

    describe("Build URL with search", () => {
        
        it("should build a url with a search param", () => {
            var url = vm.config.globalProperties.url.admin("users").search("my search string").toString()
            expect(url).to.be.a("string");
            expect(url).to.equal("/administration/users?search=my search string");
        });

    });

});
