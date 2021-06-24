

<p align="center">
	<img width="200" alt="LesliCloud logo" src="https://cdn.lesli.tech//lesli/brand/lesli-logo.svg" />
</p>

<h3 align="center">Vue plugin date</h3>

<hr/>


#### Description
Vue date plugin. It works as a middleware between the backend configuration and the frontend, and also provides some
useful features.



<hr/>



#### Initialize
This plugin initializes automatically when the app is loaded and is included in every standard vue app. You can access it 
in the js part of the vue component from the variable **this.date** and in the html part using only 
**date**

#### List of available functions

**Integer firstDayOfWeek(Boolean start_on_one)**
- params:
    - **Boolean** *<span style="color:blue">start_on_one</span>*: Wheter the returned value should start sunday as day '1' or day '0'
- returns: [**Integer**] the first day of week, but using an integer format
- description: Sunday is always the first day. It starts on '0' or '1' depending on the *start_on_one* value, then it calculates day number depending on the string states on lesli.settings.datetime.start_week_on global variable
- example:
```js
    //Imagine lesli.settings.datetime.start_week_on == 'wednesday'
    console.log(this.date.firstDayOfWeek()) // This will output 3
    console.log(this.date.firstDayOfWeek(true)) // This will output 4
```


**String startWeekOn()**
- returns: [**String**] The first day of the week in a string format
- description: Returns a string, in english, lower case that indicates which is the first day of the week. It uses the value stored in *lesli.sttings.datetime.start_week_on*. If that value is null or empty, it will default to *monday*
- example:
```js
    // Imagine lesli.settings.datetime.start_week_on == 'wednesday'
    console.log(this.date.startWeekOn()) // This will output 'wednesday'
```


**String getMonthName(Date date)**
- params:
    - **Date** *<span style="color:blue">date</span>*: The date from which you want to extract the month name
- returns: [**String**] The month of the date
- description: Extracts the month of the date and returns it in string format, in lowercase english
- example:
```js
    // Imagine we are on october and your comptuer is on 'es' locale
   console.log(this.date.getMonthName(new Date())) // This will output 'october'
```

**String parse(String string_date)**
- params:
    - **String** *<span style="color:blue">string_date</span>*: A string representing the date, using the *lesli.settings.datetime.date_format*
- returns: [**Date**] The date object parsed from the string
- description: Based on a string representing a date that is formatted using *lesli.settings.datetime.date_format*, it generates a new date and returns it. Right now it has one limitation: The delimiters of the date format must be the same (like dots, or dashes). If there is no field on lesli.settings, '%Y.%m.%d' is used as default
- example:
```js
    // Imagine lesli.settings.datetime.date_format == '%d.%m.%Y'
    console.log(this.date.parse('04.11.2020')) 
    // This will output a new date:
    //(Wednesday October 4, 2020 00:00:00)
```


**String toString(Date date)**
- params:
    - **Date** *<span style="color:blue">date</span>*: The date which you want to covert to a string format
- returns: [**String**] The string representation of the date, ignoring the time
- description: Returns a string representation of the date object based on the variable stored in *lesli.settings.datetime.date_format*. If this variable is empty, it defaults to '%Y.%m.%d', (you can reffer to ruby strftime() formats for more information) also, if the param *date* is null, it returns an empty string.
- example:
```js
    // Imagine lesli.settings.datetime.date_format == '%d.%m.%Y'
    console.log(this.date.toString(new Date())) // This will output something like '04.11.2020'
```


**String toStringFull(Date date)**
- params:
    - **Date** *<span style="color:blue">date</span>*: The date which you want to covert to a string format
- returns: [**String**] The string representation of the date, ignoring the time, but including the day name
- description: Returns a string representation of the date object based on the variable stored in *lesli.settings.datetime.date_format_full*. If this variable is empty, it defaults to '%a, %B %d, %Y' (you can reffer to ruby strftime() formats for more information), also, if the param *date* is null, it returns an empty string.
- example:
```js
    // Imagine lesli.settings.datetime.date_format_full == '%a, %B %d, %Y'
    console.log(this.date.toStringFull(new Date()))
    // This will output something like:
    // 'Wednesday, October 4, 2020'
```


**String toStringDatetime(Date date)**
- params:
    - **Date** *<span style="color:blue">date</span>*: The date which you want to covert to a string format
- returns: [**String**] The string representation of the date, including the time
- description: Returns a string representation of the date object based on the variable stored in *lesli.settings.datetime.date_format_time*. If this variable is empty, it defaults to '%Y.%m.%d %H:%M' (you can reffer to ruby strftime() formats for more information), also, if the param *date* is null, it returns an empty string.
- example:
```js
    // Imagine lesli.settings.datetime.date_format_time == '%Y.%m.%d %H:%M'
    console.log(this.date.toStringDatetime(new Date())) // This will output something like '04.11.2020 16:26
```


**String toStringTime(Date date)**
- params:
    - **Date** *<span style="color:blue">date</span>*: The date which you want to covert to a string format
- returns: [**String**] The string representation of the time of the date
- description: Returns a string representation of the time of the date object based on the variable stored in *lesli.settings.datetime.time_format*. If this variable is empty, it defaults to '%H:%M' (you can reffer to ruby strftime() formats for more information), also, if the param *date* is null, it returns an empty string.
- example:
```js
    // Imagine lesli.settings.datetime.time_format == '%H:%M'
    console.log(this.date.toStringTime(new Date())) // This will output something like '16:26'
```


**String today()**
- returns: [**String**] The string representation of today, as returned by the **toString()** method
- description: Returns a string representation today, based on the variable stored in *lesli.settings.datetime.date_format*. This function is a shortcut, and an equivalent to using **toString(new Date())**
- example:
```js
    // Imagine lesli.settings.datetime.date_format == '%d.%m.%Y'
    console.log(this.date.today()) // This will output something like '04.11.2020'
```


**Object vcDatepickerconfig(Object _options)**
- params:
    - **Object** *<span style="color:blue">_options</span>*: Currently unused. Kept in place for new development, these will be datepicker options
- returns: [**Object**] Default configuration used by a vc-date-picker to set locale, first day of week, masks, etc.
- description: This is a function that centralizes the vc-date-picker configuration, so we don't have to write all the lines each time we want to configure a date picker component. It sets the locale, the first day of week the weekdays and the input format using the lesli.settings.datetime global variable
- example:
```html
    <!-- Imagine you are in html creating a new vc-date-picker, for the basic configuration you should write something like -->
    <vc-date-picker
        v-model="my_v_model"
        :locale="date.vcDatepickerConfig()"
        >
    </vc-date-picker>
```
