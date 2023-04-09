/*

Copyright (c) 2023, all rights reserved.

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


// · plugins to be tested
import { useDate2 } from "../../../lib/vue3/composables/date2"


const Date2 = useDate2()


// · 
describe("VUE/PLUGINS/DATE2", () => {

    describe("Build a DATE2 from new Date()", () => {
        var date = new Date2
        expect(date.date().toString()).to.be.a("string");
        //expect(url).to.equal("/administration/users/777");
    })

    describe("Build a DATE2 from iso8601 string", () => {

    })

});
