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

import dayjs from "dayjs"
var utc = require('dayjs/plugin/utc')
var timezone = require('dayjs/plugin/timezone') // dependent on utc plugin
var relativetime = require('dayjs/plugin/relativeTime.js')

dayjs.extend(utc)
dayjs.extend(timezone)
dayjs.extend(relativetime)


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
