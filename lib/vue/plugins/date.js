/*
Copyright (c) 2020, all rights reserved.

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
export default {
    install (Vue, options) {

        // @variable month_names [Array] 
        // @description An array of months. Used to translate a number to a month to then translate
        //      it to the locale of the application
        let month_names = [
            'january',
            'february',
            'march',
            'april',
            'may',
            'june',
            'july',
            'august',
            'september',
            'october',
            'november',
            'december'
        ]

        // @variable weekday_names [Array]
        // @description An array of weekday. Used to translate a number to a weekday to then translate
        //      it to the locale of the application
        let weekday_names = [
            'sun',
            'mon',
            'tue',
            'wed',
            'thu',
            'fry',
            'sat'
        ]

        // function firstDayOfWeek(start_on_one)
        // @param start_on_one [Boolean] Wheter the returned value should start sunday as day '1' or day '0'
        // @return [Integer] the first day of week, but using an integer format
        // @description Sunday is always the first day. It starts on '0' or '1' depending on the *start_on_one* value, then it calculates
        //      day number depending on the string states on lesli.settings.datetime.start_week_on global variable
        // @example
        //      // Imagine lesli.settings.datetime.start_week_on == 'wednesday'
        //      console.log(this.date.firstDayOfWeek()) // This will output 3
        //      console.log(this.date.firstDayOfWeek(true)) // This will output 4
        let firstDayOfWeek = function(start_on_one=false){
            let offset = 0
            if(start_on_one){
                offset = 1
            }

            switch(lesli.settings.datetime.start_week_on){

                case 'sunday':
                    return 0 + offset
                case 'monday':
                    return 1 + offset
                case 'tuesday':
                    return 2 + offset
                case 'wednesday':
                    return 3 + offset
                case 'thursday':
                    return 4 + offset
                case 'friday':
                    return 5 + offset
                case 'saturday':
                    return 6 + offset
                default:
                    return 1
            }
        }

        // function startWeekOn()
        // @return [String] The first day of the week in a string format
        // @description Returns a string, in english, lower case that indicates which is the first day of the week. It uses the value
        //      stored in lesli.sttings.datetime.start_week_on. If that value is null or empty, it will default to *monday*
        // @example
        //      // Imagine lesli.settings.datetime.start_week_on == 'wednesday'
        //      console.log(this.date.startWeekOn()) // This will output 'wednesday'
        let startWeekOn = function(){
            return lesli.settings.datetime.start_week_on || 'monday'
        }

        // function getMonthName(date)
        // @param date [Date] The date from which you want to extract the month name
        // @return [String] The month of the date
        // @description Extracts the month of the date and returns it in string format, in lowercase english
        // @example
        //      // Imagine we are on october and your comptuer is on 'es' locale
        //      console.log(this.date.getMonthName(new Date())) // This will output 'october'
        let getMonthName = function(date){
            return month_names[date.getMonth()]
        }
        
        // function parse(string_date)
        // @param string_date [String] A string representing the date, using the lesli.settings.datetime.date_format
        // @return [Date] The date object parsed from the string
        // @description Based on a string representing a date that is formatted using lesli.settings.datetime.date_format,
        //      it generates a new date and returns it. Right now it has one limitation: The delimiters of the date format
        //      must be the same (like dots, or dashes). If there is no field on lesli.settings, '%Y.%m.%d' is used as default
        // @example
        //      // Imagine lesli.settings.datetime.date_format == '%d.%m.%Y'
        //      console.log(this.date.parse('04.11.2020')) // This will output a new date (Wednesday October 4, 2020 00:00:00)
        let parse = function(string_date){
            let date_format = lesli.settings.datetime.date_format || '%Y.%m.%d'
            let delimiter = date_format.replace('%Y', '').replace('%m', '').replace('%d', '').split('')[0]
            
            string_date = string_date.split(delimiter)

            let segments = [{
                name: 'year',
                index: date_format.indexOf('%Y')
            },{
                name: 'month',
                index: date_format.indexOf('%m')
            },{
                name: 'day',
                index: date_format.indexOf('%d')
            }]

            segments = segments.sort((a, b)=>{
                return a.index > b.index
            })

            let date = new Date()
            for(let i = 0; i < segments.length; i++){
                let segment = segments[i]
                let date_segment = parseInt(string_date[i])
                if(segment.name == 'year'){
                    date.setYear(date_segment)
                }else if(segment.name == 'month'){
                    date.setMonth(date_segment - 1)
                }else{
                    date.setDate(date_segment)
                }
            }

            return date

        }

        // function toString(date)
        // @param date [Date] The date which you want to covert to a string format
        // @return [String] The string representation of the date, ignoring the time
        // @description Returns a string representation of the date object based on the variable stored in
        //      lesli.settings.datetime.date_format. If this variable is empty, it defaults to '%Y.%m.%d', 
        //      (you can reffer to ruby strftime() formats for more information) also, if the param *date* is null, 
        //      it returns an empty string.
        // @example
        //      // Imagine lesli.settings.datetime.date_format == '%d.%m.%Y'
        //      console.log(this.date.toString(new Date())) // This will output something like '04.11.2020'
        let toString = function(date){
            if(! date){
                return ''
            }
            
            let date_format = lesli.settings.datetime.date_format || '%Y.%m.%d'
            let year = date.getFullYear()
            let month = date.getMonth()+1
            if(month < 10){
                month = `0${month}`
            }
            let day = date.getDate()
            if(day < 10){
                day = `0${day}`
            }
            return date_format.replace('%Y', year).replace('%m', month).replace('%d', day)
        }

        // function toStringFull(date)
        // @param date [Date] The date which you want to covert to a string format
        // @return [String] The string representation of the date, ignoring the time, but including the day name
        // @description Returns a string representation of the date object based on the variable stored in
        //      lesli.settings.datetime.date_format_full. If this variable is empty, it defaults to '%a, %B %d, %Y'
        //      (you can reffer to ruby strftime() formats for more information), also,
        //      if the param *date* is null, it returns an empty string.
        // @example
        //      // Imagine lesli.settings.datetime.date_format_full == '%a, %B %d, %Y'
        //      console.log(this.date.toStringFull(new Date())) // This will output something like 'Wednesday, October 4, 2020'
        let toStringFull = function(date){
            if(! date){
                return ''
            }
            
            let date_format = lesli.settings.datetime.date_format_full || '%a, %B %d, %Y'
            let year = date.getFullYear()
            let month = month_names[date.getMonth()]
            let day = date.getDate()
            if(day < 10){
                day = `0${day}`
            }
            let weekday = weekday_names[date.getDay()]
            return date_format.replace('%Y', year).replace('%B', month).replace('%d', day).replace('%a', weekday)
        }

        // function toStringDatetime(date)
        // @param date [Date] The date which you want to covert to a string format
        // @return [String] The string representation of the date, including the time
        // @description Returns a string representation of the date object based on the variable stored in
        //      lesli.settings.datetime.date_format_time. If this variable is empty, it defaults to '%Y.%m.%d %H:%M'
        //      (you can reffer to ruby strftime() formats for more information), also,
        //      if the param *date* is null, it returns an empty string.
        // @example
        //      // Imagine lesli.settings.datetime.date_format_time == '%Y.%m.%d %H:%M'
        //      console.log(this.date.toStringDatetime(new Date())) // This will output something like '04.11.2020 16:26'
        let toStringDatetime = function(date){
            if(! date){
                return ''
            }
            
            let date_format = lesli.settings.datetime.date_format_time || '%Y.%m.%d %H:%M'
            let year = date.getFullYear()
            let month = date.getMonth()+1
            if(month < 10){
                month = `0${month}`
            }
            let day = date.getDate()
            if(day < 10){
                day = `0${day}`
            }
            let hours = date.getHours()
            if(hours < 10){
                hours = `0${hours}`
            }
            let minutes = date.getMinutes()
            if(minutes < 10){
                minutes = `0${minutes}`
            }
            return date_format.replace('%Y', year).replace('%m', month).replace('%d', day).replace('%H', hours).replace('%M', minutes)
        }

        // function toStringTime(date)
        // @param date [Date] The date which you want to covert to a string format
        // @return [String] The string representation of the time of the date
        // @description Returns a string representation of the time of the date object based on the variable stored in
        //      lesli.settings.datetime.time_format. If this variable is empty, it defaults to '%H:%M'
        //      (you can reffer to ruby strftime() formats for more information), also,
        //      if the param *date* is null, it returns an empty string.
        // @example
        //      // Imagine lesli.settings.datetime.time_format == '%H:%M'
        //      console.log(this.date.toStringTime(new Date())) // This will output something like '16:26'
        let toStringTime = function(date){
            if(! date){
                return ''
            }
            
            let date_format = lesli.settings.datetime.time_format || '%H:%M'
            let hours = date.getHours()
            if(hours < 10){
                hours = `0${hours}`
            }
            let minutes = date.getHours()
            if(minutes < 10){
                minutes = `0${minutes}`
            }
            return date_format.replace('%H', hours).replace('%M', minutes)
        }
        

        // function today()
        // @return [String] The string representation of today, as returned by the toString() method
        // @description Returns a string representation today, based on the variable stored in
        //      lesli.settings.datetime.date_format. This function is a shortcut, and an equivalent
        //      to using *toString(new Date())*
        // @example
        //      // Imagine lesli.settings.datetime.date_format == '%d.%m.%Y'
        //      console.log(this.date.today()) // This will output something like '04.11.2020'
        let today = function(){
            return toString(new Date());
        }

        // function vcDatepickerconfig(_options)
        // @param _options [Object] Currently unused. Kept in place for new development, these will be datepicker options
        // @return [Object] Default configuration used by a vc-date-picker to set locale, first day of week, masks, etc.
        // @description This is a function that centralizes the vc-date-picker configuration, so we don't have to write all
        //      the lines each time we want to configure a date picker component. It sets the locale, the first day of week
        //      the weekdays and the input format using the lesli.settings.datetime global variable
        // @example
        //      // Imagine you are in html creating a new vc-date-picker, for the configuration you should write something like
        //      // <vc-date-picker :locale="date.vcDatepickerConfig()" ...></vc-datepicker>
        let vcDatepickerConfig = function(_options){
            let date_format = lesli.settings.datetime.date_format || '%Y.%m.%d'
            date_format = date_format.replace('%Y','YYYY').replace('%m','MM').replace('%d','DD')

            return {
                id: I18n.locale,
                firstDayOfWeek: firstDayOfWeek(true),
                masks: {
                    weekdays: 'WW',
                    input: date_format
                }
            }
        }
        
        Vue.prototype.date = {
            firstDayOfWeek,
            toStringDatetime,
            toStringFull,
            toStringTime,
            startWeekOn,
            toString,
            today,
            parse,
            vcDatepickerConfig,
            getMonthName
        };
    }
}
