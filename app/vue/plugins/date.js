export default {
    install (Vue, options) {

        //date will be returned in standard format YYYY-MM-DD
        let today = function(){
            var date = new Date();
            //We do not use time so date type inputs will accept the value
            return date.toISOString().substr(0, 10);
        }

    let date_options = {
        year: 'numeric',
        month: '2-digit',
        day: '2-digit',
        timeZone: 'UTC'
        };

    let datetime_options = {
        ...date_options, ...{
        hour: '2-digit',
        minute: '2-digit',
        second: '2-digit'
        }
    }

    let full_date_options = {
        ...datetime_options, ...{
            weekday: 'long'
        }
    }

        //date should be given in standard format YYYY-MM-DD
        let toLocalFormat = function(date,include_time = false, full_date = false){
            date = new Date(date);
            let options = date_options
            
            if(include_time){
                options = datetime_options
            }
            if(full_date){
                options = full_date_options
            }
            
            return date.toLocaleDateString(I18n.currentLocale(), options)
        }
        
        Vue.prototype.date = {
            today,
            toLocalFormat
        };
    }
}
