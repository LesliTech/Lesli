/**
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



// · Import frameworks, libraries & tools
import { expect } from "chai"
import { createApp } from "vue"


// · plugins to be tested
import pluginUrl from "../../../lib/vue3/plugins/url"


// · build & prepare app to be tested
const vm = createApp({})


// · load plugins
vm.use(pluginUrl, { root: "http://lesli.test" })

const url = vm.config.globalProperties.url


// · 
describe("VUE/PLUGINS/URL", () => {

    describe("Build URL for custom to", () => {

        it("should build a url for invite", () => {
            var url = vm.config.globalProperties.url.to("invite").toString()
            expect(url).to.be.a("string");
            expect(url).to.equal("/invite")
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

    describe("Build URL with with pagination", () => {
        
        it("should build a url for default pagination", () => {
            var url = vm.config.globalProperties.url.admin("users").paginate(1).toString()
            expect(url).to.be.a("string");
            expect(url).to.equal("/administration/users?page=1&perPage=10");
        });

        it("should build a url for paginate page 5", () => {
            var url = vm.config.globalProperties.url.admin("users").paginate(5).toString()
            expect(url).to.be.a("string");
            expect(url).to.equal("/administration/users?page=5&perPage=10");
        });

        it("should build a url for paginate 20 items per page", () => {
            var url = vm.config.globalProperties.url.admin("users").paginate(1,20).toString()
            expect(url).to.be.a("string");
            expect(url).to.equal("/administration/users?page=1&perPage=20");
        });

    });

    describe("Build URL with search", () => {
        
        it("should build a url with a search param", () => {
            var url = vm.config.globalProperties.url.admin("users").search("my search string").toString()
            expect(url).to.be.a("string");
            expect(url).to.equal("/administration/users?search=my search string");
        });

    });

    describe("Build URL with filters", () => {
        
        it("should build a url to filter by role name", () => {
            let result = url.admin("users").filter({ roles: ['admin', 'guest'] }).toString()
            expect(result).to.equal("/administration/users?f[roles]=admin,guest");
        });

        it("should build a url with multiple filters", () => {
            let result = url.admin("users").filter({ roles: ['admin', 'guest'], categories: ['cat1', 'cat2'] }).toString()
            expect(result).to.equal("/administration/users?f[roles]=admin,guest&f[categories]=cat1,cat2");
        });

    });

    describe("Build URL for ROOT requests", () => {
        
        it("should build a url for the root", () => {
            expect(url.root().toString()).to.equal("/")
        });

        it("should build a url to search at the root level", () => {
            expect(url.root().search("mysearchstring").toString()).to.equal("/?search=mysearchstring")
        });

        it("should build a url for a user at the root level", () => {
            url.root("users/:id", 1).search("/users/1").toString()
        });

        it("should build a url for a user at the root level with object params", () => {
            url.root("users/:id", { id: 2 }).search("/users/2").toString()
        });

    });

    describe("Build full featured URL", () => {
        
        it("should build a full feature url at root level", () => {
            let result = url.root().order("id").paginate(1).search("text").filter({ role: ['admin'] }).toString()
            expect(result).to.equal("/?orderBy=id&order=asc&page=1&perPage=10&search=text&f[role]=admin")
        });

        it("should build a full feature url at root level with path", () => {
            let result = url.root("user/:id", 1).order("id").paginate(1).search("text").filter({ role: ['admin'] }).toString()
            expect(result).to.equal("/user/1?orderBy=id&order=asc&page=1&perPage=10&search=text&f[role]=admin")
        });

        it("should build a full feature url for the admin area", () => {
            let result = url.admin().order("id").paginate(1).search("text").filter({ role: ['admin'] }).toString()
            expect(result).to.equal("/administration/?orderBy=id&order=asc&page=1&perPage=10&search=text&f[role]=admin")
        });

        it("should build a full feature url for the admin area with path", () => {
            let result = url.admin("user/:userid", { userid: "2" }).order("id").paginate(1).search("text").filter({ role: ['admin'] }).toString()
            expect(result).to.equal("/administration/user/2?orderBy=id&order=asc&page=1&perPage=10&search=text&f[role]=admin")
        });

        it("should build a full feature url for an engine", () => {
            let result = url.audit().order("id").paginate(1).search("text").filter({ role: ['admin'] }).toString()
            expect(result).to.equal("/audit/?orderBy=id&order=asc&page=1&perPage=10&search=text&f[role]=admin")
        });

        it("should build a full feature url for an engine with path", () => {
            let result = url.audit("user/:userid", { userid: "3" }).order("id").paginate(1).search("text").filter({ role: ['admin'] }).toString()
            expect(result).to.equal("/audit/user/3?orderBy=id&order=asc&page=1&perPage=10&search=text&f[role]=admin")
        });

    });

});
