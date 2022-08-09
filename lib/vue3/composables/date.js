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


// · Import dayjs library and plugins
import dayjs from "dayjs"
var utc = require('dayjs/plugin/utc')
var timezone = require('dayjs/plugin/timezone')


// · give support to dayjs to work with UTC times
dayjs.extend(utc)
dayjs.extend(timezone)


// By default we use the Rails datetime format standard, so to be able to work with
// the javascript (dayjs) datetime formats it is necessary to convert from Rails to JS 
// check lib/LC/date2 for more details
function converter(format) {
    return format
    // Convert Ruby to dayjs format
    .replaceAll("%Y", "YYYY")
    .replaceAll("%m", "MM")
    .replaceAll("%d", "DD")
    // Convert Ruby to dayjs format
    .replaceAll("%H", "HH")
    .replaceAll("%M", "mm")
    // Convert Ruby date words to dayjs format
    .replaceAll("%A", "dddd")   // Full day name
    .replaceAll("%B", "MMMM")   // Full month name
}


// · 
// · IMPORTANT: This library only works with UTC datetimes
export function useDate(options= {
    "time_zone": "America/Guatemala",
    "start_week_on": "sunday",
    "formats": {
        "date": "%d.%m.%Y",
        "time": "%H:%M",
        "date_time": "%d.%m.%Y · %H:%M",
        "date_words": "%A, %B %d, %Y",
        "date_time_words": "%A, %B %d, %Y, %H:%M"
    }
}) {


    // cache for converted datetime formats
    const formats = {
        date: converter(options.formats.date),
        time: converter(options.formats.time),
        date_time: converter(options.formats.date_time),
        date_words: converter(options.formats.date_words),
        date_time_words: converter(options.formats.date_time_words),
    }


    // return current datetime in UTC
    function now() {
        return dayjs().utc().format()
    }

    function date(datetime) {
        return dayjs(datetime).tz(options.time_zone).format(formats.date)
    }

    function time(datetime) {
        return dayjs(datetime).tz(options.time_zone).format(formats.time)
    }

    function dateTime(datetime) {
        return dayjs(datetime).tz(options.time_zone).format(formats.date_time)
    }

    function dateWords(datetime) {
        return dayjs(datetime).tz(options.time_zone).format(formats.date_words)
    }

    function dateTimeWords(datetime) {
        return dayjs(datetime).tz(options.time_zone).format(formats.date_time_words)
    }

    return { date, time, dateTime, dateWords, dateTimeWords }

}
