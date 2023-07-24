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


// · plugins to be tested
import { useHTTP } from "../../../lib/vue/composables/http"


// · Composable instance
const HTTP = useHTTP()

var MockAdapter = require("axios-mock-adapter");

// This sets the mock adapter on the default instance
var mock = new MockAdapter(HTTP);


mock.onGet("/administration").reply(200, {
    users: [{ id: 1, name: "John Smith" }],
});


// · 
describe("VUE/COMPOSABLES/HTTP", () => {
    
    describe("Build URL for custom to", () => {

        it("should build a url for invite", () => {
            HTTP.get("/administration").then(result => {
                console.log(result)
            }).catch(error => {
                console.log(error)
            })
        });
    });
});
