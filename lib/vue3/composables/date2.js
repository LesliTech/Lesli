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



/*
IMPORTANT:  
    This is a JavaScript implementation of LC::Date2 RoR lib.
    If any modification or update is needed it must be implemented in LC::Date2 first, then we can
    copy the new feature and implement in here.
    Do Not add custom features, methods, params or any other modification that is not present in LC::Date2
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
    
    
    // set date format and return Date2 instance
    date() {
        this.#setFormat("date")
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

    return LesliDate2

}
