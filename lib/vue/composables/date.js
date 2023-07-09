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




// DEPRECATED



// · Import dayjs library and plugins
import dayjs from "dayjs"
var utc = require('dayjs/plugin/utc')
var timezone = require('dayjs/plugin/timezone')
var relativetime = require('dayjs/plugin/relativeTime')


// · give support to dayjs to work with UTC times
dayjs.extend(utc)
dayjs.extend(timezone)
dayjs.extend(relativetime)


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

    function distanceToWords(datetime) {
        return dayjs(datetime).fromNow()
    }

    /**
    * @param {Date} datetime 
    * @description Returns the correct format if the the message was sent today, this week or it was sent in the past
    * @returns {String} formatted for a chat
    * Basic usage example:
    * ```js
    *   // · Today
    *   messageTimestamp(new Date()) // "12:00"
    * 
    *   // · This week
    *   messageTimestamp(new Date() - 1000 * 60 * 60 * 24) // "Mon"
    * 
    *   // · Sent in the past
    *   messageTimestamp(new Date("2021-01-01")) // "01.01.2021"
    * ```
    */
    function messageTimestamp(datetime) {
        if (!datetime) return ""
        
        const date = dayjs(datetime?.seconds * 1000).tz(options.time_zone)
        
        // · get the hours and minutes if the message was sent today
        if (date.isSame(dayjs().tz(options.time_zone), 'day')) {
            return date.format(formats.time)
        }
    
        // · get the day if the message was sent this current week
        if (date.isSame(dayjs().tz(options.time_zone), 'week')) {
            // get the day name
            return date.format("dddd")
        }
    
        // · get the date if the message is older than a week
        return date.format(formats.date) || ""
    }

    function timestampToDate(seconds) {
        return dayjs(seconds * 1000).tz(options.time_zone)
    }

    return { date, time, dateTime, dateWords, dateTimeWords, messageTimestamp, distanceToWords, timestampToDate }

}
