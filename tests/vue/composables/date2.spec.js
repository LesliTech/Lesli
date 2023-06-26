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
import { useDate2 } from "../../../lib/vue/composables/date2"


const Date2 = useDate2()


// · 
describe("VUE/COMPOSABLES/DATE2", () => {

    describe("Build a DATE2 from new Date()", () => {
        var date = new Date2
        expect(date.date().toString()).to.be.a("string");
        //expect(url).to.equal("/administration/users/777");
    })

    describe("Build a DATE2 from iso8601 string", () => {

    })

});
