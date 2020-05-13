export default {
    install (Vue, options) {

        let month_names = [
            'January',
            'February',
            'March',
            'April',
            'May',
            'June',
            'July',
            'August',
            'September',
            'October',
            'November',
            'December'
        ]

        let weekday_names = [
            'Sun',
            'Mon',
            'Tue',
            'Wed',
            'Thu',
            'Fry',
            'Sat'
        ]

        // returns the first day of week based on buefy datepicker. Sunday is 0, Monday is 1 and so on
        let firstDayOfWeek = function(){
            switch(leslicloud_account.settings.start_week_on){
                case 'sunday':
                    return 0
                case 'monday':
                    return 1
                case 'tuesday':
                    return 2
                case 'wednesday':
                    return 3
                case 'thursday':
                    return 4
                case 'friday':
                    return 5
                case 'saturday':
                    return 6
                default:
                    return 1
            }
        }

        //returns the name of the day in which the wee starts
        let startWeekOn = function(){
            return leslicloud_account.settings.start_week_on || 'monday'
        }
        
        // Parses a string and returns a date
        // Limitations of this parser: Only date format, only 1 character delimiters. Delimiters must be the same
        let parse = function(string_date){
            let date_format = leslicloud_account.settings.date_format || '%Y.%m.%d'
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

        //function that turns a Date object into a string
        let toString = function(date){
            if(! date){
                return ''
            }
            
            let date_format = leslicloud_account.settings.date_format || '%Y.%m.%d'
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

        let toStringFull = function(date){
            if(! date){
                return ''
            }
            
            let date_format = leslicloud_account.settings.date_format_full || '%a, %B %d, %Y'
            let year = date.getFullYear()
            let month = month_names[date.getMonth()]
            let day = date.getDate()
            if(day < 10){
                day = `0${day}`
            }
            let weekday = weekday_names[date.getDay()]
            return date_format.replace('%Y', year).replace('%B', month).replace('%d', day).replace('%a', weekday)
        }

        let toStringDatetime = function(date){
            if(! date){
                return ''
            }
            
            let date_format = leslicloud_account.settings.date_time_format || '%Y.%m.%d %H:%M'
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
            let minutes = date.getHours()
            if(minutes < 10){
                minutes = `0${minutes}`
            }
            return date_format.replace('%Y', year).replace('%m', month).replace('%d', day).replace('%H', hours).replace('%M', minutes)
        }
        

        //returns current day in account format
        let today = function(){
            return toString(new Date());
        }
        
        Vue.prototype.date = {
            firstDayOfWeek,
            toStringDatetime,
            toStringFull,
            startWeekOn,
            toString,
            today,
            parse
        };
    }
}
