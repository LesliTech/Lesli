/*

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




/*
IMPORTANT:  
    This is a JavaScript implementation of app/lib/Date2 RoR lib.
    If any modification or update is needed it must be implemented in app/lib/Date2 first, then we can
    copy the new feature and implement in here.
    DO NOT add custom features, methods, params or any other modification that is not present in app/lib/Date2
*/


// · Import dayjs library and plugins
import dayjs from "dayjs"
var utc = require("dayjs/plugin/utc")
var timezone = require("dayjs/plugin/timezone")


// · 
dayjs.extend(utc)
dayjs.extend(timezone)


// · 
class LesliDate2 {
    
    #settings = {}
    #datetime = {}
    #format = ""
    
    constructor(datetime = dayjs().utc().format(), format = "%Y-%m-%d %H:%M:%S") {

        /*
        # NOTE: Do not modify settings here,
        # if you need a different date format you should change it in the config file
        # Check the docs for more information: /development/docs/rails-lib-time

        # TODO: User should be able to select an appropiate datetime format in an easy way,
        # the Administration module must be present to the users a curated list of different
        # datetime format options with examples, also user should be able to manually modify
        # the format through an "advanced view"
        */
        this.#settings = {
            timeZone: "America/Guatemala",              // get this from Lesli settings
            startWeekOn: "config[:start_week_on]",
            format: {
                date: "%d.%m.%Y",
                time: "%H:%M",                          // 24 hours datetime format (default)
                dateTime: "%d.%m.%Y %H:%M",             // 24 hours datetime format (default)
                dateWords: "%A, %B %d, %Y",
                dateTimeWords: "%A, %B %d, %Y, %H:%M"   // 24 hours datetime in words format (default)
            }
        }

        // default date format
        this.#format = this.#setFormat("date")


        // get datetime object from user params
        this.#datetime = dayjs(datetime).tz(this.#settings.timeZone)
    }
    
    date() {
        this.#setFormat("date")
        return this
    }


    dateTime() {
        this.#setFormat("dateTime")
        return this.toString()
    }


    dateWords() {
        this.#setFormat("dateWords")
        return this
    }


    // convert a datetime object to string representation using defined format
    toString() {
        return this.#datetime.format(this.#format)
    }



    //
    #setFormat(format) {
        this.#format = this.#settings.format[format]
            // Convert date Ruby to dayjs format
            .replaceAll("%Y", "YYYY")
            .replaceAll("%m", "MM")
            .replaceAll("%d", "DD")
            // Convert time Ruby to dayjs format
            .replaceAll("%H", "HH")
            .replaceAll("%M", "mm")
            // Convert words Ruby to dayjs format
            .replaceAll("%A", "dddd")   // Full day name
            .replaceAll("%B", "MMMM")   // Full month name
    }
   
}



export function useDate2() {

    return function (datetime = dayjs().utc().format(), format = "%Y-%m-%d %H:%M:%S") {
        return new LesliDate2(datetime, format)
    }

}
