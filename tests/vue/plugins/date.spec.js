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

import dayjs from "dayjs"
var utc = require('dayjs/plugin/utc')
var timezone = require('dayjs/plugin/timezone') // dependent on utc plugin

dayjs.extend(utc)
dayjs.extend(timezone)


// · plugins to be tested
import pluginDate from "../../../lib/vue3/plugins/date"


// · build & prepare app to be tested
const vm = createApp({})


// · load plugins
vm.use(pluginDate)


// · 
const date = vm.config.globalProperties.date


// · 
describe("VUE/PLUGINS/DATE", () => {

    describe("Build a DATE from new Date()", () => {

        it("should parse a new date from new Date() object", () => {
            let jsdate = dayjs().utc().format()
            let result = date.date(jsdate)
            expect(result).to.be.a("string")
            expect(result).to.equal(dayjs(jsdate).tz("America/Guatemala").format("DD.MM.YYYY"))
        })

        it("should parse a new time from new Date() object", () => {
            let jsdate = dayjs().utc().format()
            let result = date.time(jsdate)
            expect(result).to.be.a("string")
            expect(result).to.equal(dayjs(jsdate).tz("America/Guatemala").format("HH:mm"))
        })

        it("should parse a new date_time from new Date() object", () => {
            let jsdate = dayjs().utc().format()
            let result = date.dateTime(jsdate)
            expect(result).to.be.a("string")
            expect(result).to.equal(dayjs(jsdate).tz("America/Guatemala").format("DD.MM.YYYY HH:mm"))
        }) 

        it("should parse a new date_words from new Date() object", () => {
            let jsdate = dayjs().utc().format()
            let result = date.dateWords(jsdate)
            expect(result).to.be.a("string")
            expect(result).to.equal(dayjs(jsdate).tz("America/Guatemala").format("dddd, MMMM DD, YYYY"))
        })

        it("should parse a new date_time_words new Date() object", () => {
            let jsdate = dayjs().utc().format()
            let result = date.dateTimeWords(jsdate)
            expect(result).to.be.a("string")
            expect(result).to.equal(dayjs(jsdate).tz("America/Guatemala").format("dddd, MMMM DD, YYYY, HH:mm"))
        })

    })

    describe("Build a DATE from iso8601 string", () => {

        it("should parse a new date from iso8601 string", () => {
            let result = date.date("1990-09-11T11:05:05.000Z")
            expect(result).to.be.a("string")
            expect(result).to.equal("11.09.1990")
        })

        it("should parse a new time from iso8601 string", () => {
            let result = date.time("1990-09-11T11:05:05.000Z")
            expect(result).to.be.a("string")
            expect(result).to.equal("05:05")
        })

        it("should parse a new date_time from iso8601 string", () => {
            let result = date.dateTime("1990-09-11T11:05:05.000Z")
            expect(result).to.be.a("string")
            expect(result).to.equal("11.09.1990 05:05")
        })

        it("should parse a new date_words from iso8601 string", () => {
            let result = date.dateWords("1990-09-11T11:05:05.000Z")
            expect(result).to.be.a("string")
            expect(result).to.equal("Tuesday, September 11, 1990")
        }) 

        it("should parse a new date_time_words from iso8601 string", () => {
            let result = date.dateTimeWords("1990-09-11T11:05:05.000Z")
            expect(result).to.be.a("string")
            expect(result).to.equal("Tuesday, September 11, 1990, 05:05")
        })

    })

});
