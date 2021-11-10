# Lesli Command Date
LC::Date   is a class with helpful functions to allow the user to manipulate dates formats and date timezones with ease. Note that this class has some limitations: in its current version, LC::Date does not support settings nor multiple accounts, so all accounts under the same lesli instance will have either the default date settings or the ones stated in the **builder engine**

<hr/>


### Initialize
This class is loaded automatically and is available any class inside the rails app. The settings are obtained from the file */core/engines/builder\_engine/lesli.yml*. There you can override the default values in datetime.configuration, for example: 

```yml
# Imagine this is /core/engines/builder_engine/lesli.yml
# some values here...
configuration:
    datetime:
        date_format: "%d.%m.%Y"
        date_format_full: "%a, %B %d, %Y"
        date_format_time: "%d.%m.%Y %H:%M"
        time_format: "%H:%M"
        time_zone: "Europe/Berlin"
        start_week_on: "monday"
# other values here...
```
  

### List of available functions

**static String db\_timestamps(String table = "")**

- params:

	-  **String**  *table*: Name of the table. Leave this blank if the **created\_at** and **updated\_at** are the fields of the main table you are consulting

- returns: [**String**] The sql needed to select the created\_at and updated\_at columns, move it to the instance timezone, apply the instance format but using the postgresql standard for strftime instead of the rails standard, and convert it to char

- description: Returns an SQL that can be used on a select, a where or a group\_by, that adds timezone and date format to the created\_at and updated\_at fields.

- example:

```ruby
Users.select(LC::Date.db_timestamps)
# The generated sql wil be:
# SELECT 
#     TO_CHAR(
#         created_at at time zone 'utc' at time zone 'Europe/Berlin', 'DD.MM.YYYY'
#     ) AS created_at, 
#     TO_CHAR(
#         updated_at at time zone 'utc' at time zone 'Europe/Berlin', 'DD.MM.YYYY'
#     ) AS updated_at
# FROM users;
```

**static String db\_to\_char(String column, String alias\_name = nil, Boolean include\_alias = true) (DEPRECATED, use db\_to\_char\_custom instead)** 

- params:

	-  **String** *column*: The column that will be selected
	- **String** *alias\_name*: Alias of the column that will be selected.
	- **String** *include\_alias*: Wether the resulting string will include an alias or not

- returns: [**String**] The sql needed select date column, move it to the instance timezone, apply the instance format but using the postgresql standard for strftime instead of the rails standard, convert it to char, and add an alias to it

- description: Returns an SQL that can be used on a select, a where or a group\_by, using any date column, that adds timezone and date format.

- example:

```ruby
Users.select(LC::Date.db_to_char("verified_at", "verified"))
# The generated sql wil be:
# SELECT 
#     TO_CHAR(verified_at time zone 'utc' at time zone 'Europe/Berlin', 'DD.MM.YYYY') AS verified
# FROM users;


Users.select(LC::Date.db_to_char("verified_at"))
# The generated sql wil be:
# SELECT 
#     TO_CHAR(verified_at time zone 'utc' at time zone 'Europe/Berlin', 'DD.MM.YYYY') AS verified_at
# FROM users;


Users.select(LC::Date.db_to_char("verified_at", nil, false))
# The generated sql wil be:
# SELECT 
#     TO_CHAR(verified_at time zone 'utc' at time zone 'Europe/Berlin', 'DD.MM.YYYY')
# FROM users;
```

  **static String db\_to\_char\_custom(String column, String alias\_name: column, Boolean include\_alias: false, String db\_format: nil)**

- params:

	-  **String** *column*: The column that will be selected
	- **String** *alias\_name*: Alias of the column that will be selected. It defaults to the name of the column.
	- **String** *include\_alias*: Wether the resulting string will include an alias or not. It defaults to false
	- **String** *db\_format*: The posgresql format used. This is useful in cases you want to select only year (YYYY) intead of the full date (DD.MM.YYYY)

- returns: [**String**] The sql needed select date column, move it to the instance timezone, apply the instance format but using the postgresql standard for strftime instead of the rails standard, convert it to char, and add an alias to it

- description: Returns an SQL that can be used on a select, a where or a group\_by, using any date column, that adds timezone and date format.

- example:

```ruby
Users.select(LC::Date.db_to_char("verified_at", include_alias: true, alias_name: "verified"))
# The generated sql wil be:
# SELECT 
#     TO_CHAR(verified_at time zone 'utc' at time zone 'Europe/Berlin', 'DD.MM.YYYY') AS verified
# FROM users;


Users.select(LC::Date.db_to_char("verified_at", include_alias: true))
# The generated sql wil be:
# SELECT 
#     TO_CHAR(verified_at time zone 'utc' at time zone 'Europe/Berlin', 'DD.MM.YYYY') AS verified_at
# FROM users;


Users.select(LC::Date.db_to_char("verified_at", db_format: "MM/YYYY"))
# The generated sql wil be:
# SELECT 
#     TO_CHAR(verified_at time zone 'utc' at time zone 'Europe/Berlin', 'MM/YYYY')
# FROM users;
```

  **static Time datetime()**

- returns: [**Time**] The datetime representation in the timezone especificated by the lesli instance

- description: Returns a Time object in the current timezone of the lesli instance

- example:

```ruby
date = LC::Date.datetime()
```

  **static String to\_string(Time datetime\_object)**

- params:

	-  **Time** *datetime\_object*: The datetime object you want to convert to string

- returns: [**String**] The string representation of the Time object, in t he correct timezone

- description: Returns a string representation of the Time object in the current timezone of the lesli instance using the format especificated by the instance in *date\_format*

- example:

```ruby
puts LC::Date.to_string(DateTime.current)
# This will display something like 19.10.2020
```

  **static String to\_string\_datetime(Time datetime\_object)**

- params:

	-  **Time** *datetime\_object*: The datetime object you want to convert to string

- returns: [**String**] The string representation of the Time object, in t he correct timezone

- description: Returns a string representation of the Time object in the current timezone of the lesli instance using the format especificated by the instance in *date\_format\_time*

- example:

```ruby
puts LC::Date.to_string_datetime(DateTime.current)
# This will display something like 19.10.2020 14:24
```

 **static String to\_string\_datetime\_words(Time datetime\_object)**

- params:

	-  **Time** *datetime\_object*: The datetime object you want to convert to string

- returns: [**String**] The string representation of the Time object, in t he correct timezone

- description: Returns a string representation of the Time object in the current timezone of the lesli instance using the format especificated by the instance in *date\_format\_full*

- example:

```ruby
puts LC::Date.to_string_datetime_words(DateTime.current)
# This will display something like Monday, November 20, 2020 14:34
```

 **static String to\_string\_time(Time datetime\_object)**

- params:

	-  **Time** *datetime\_object*: The datetime object you want to convert to string

- returns: [**String**] The string representation of the Time object, in t he correct timezone

- description: Returns a string representation of the Time object in the current timezone of the lesli instance using the format especificated by the instance in *time\_format*

- example:

```ruby
puts LC::Date.to_string_time(DateTime.current)
# This will display something like 11:43
```

 **static Time beginning\_of\_month()**

- returns: [**Time**] The time object that represents the beginning of the current month

- description: Returns a time object in the current timezone of the lesli instance with the beginning of the current month

- example:

```ruby
puts LC::Date.to_string(LC::Date.beginning_of_month())
# This will display something like 01.10.2020 00:00
```

 **static Time today\_at\_midnight()**

- returns: [**Time**] The time object that represents the beginning of the current day

- description: Returns a time object in the current timezone of the lesli instance with the beginning of the current day

- example:

```ruby
# Imagine today is 03.10.2020 at some random time
puts LC::Date.to_string(LC::Date.beginning_of_day())
# This will display something like 03.10.2020 00:00
```

 **static Time tomorrow\_at\_midnight()**

- returns: [**Time**] The time object that represents the beginning of tomorrow (end of today)

- description: Returns a time object in the current timezone of the lesli instance with the beginning of the next day

- example:

```ruby
# Imagine today is 03.10.2020 at some random time
puts LC::Date.to_string(LC::Date.today_at_midnight())
# This will display something like 04.10.2020 00:00
```

 **static Time now()**

- returns: [**Time**] The datetime representation in the timezone especificated by the lesli instance

- description: Returns a Time object in the current timezone of the lesli instance. This is an alias for LC::Date.datetime

- example:

```ruby
date = LC::Date.now()
```

 **static String distance\_to\_words(Time time\_from, Time time\_to, Boolean force\_time\_zone=false)**

- params:
	-  **Time** *time\_from*: The initial moment of the calculation
	-  **Time** *time\_to*: The final moment of the calculation
	-  **Boolean** *force\_time\_zone*: Wether you want to force both times to the timezone of the lesli instance

- returns: [**Time**] The distance in words, using only english, of 2 different times.

- description: Calculates the distance between 2 Time objects, if it is greater than a day it returns 'N days ago'. If not, it returns 'N hours ago' and so on for minutes and seconds also.

- example:

```ruby
puts LC::Date.distance_to_words(LC::Date.now, LC::Date.now+4.days)
# This will display '4 days ago'

puts LC::Date.distance_to_words(LC::Date.now, LC::Date.now+6.hours)
# This will display '6 hours ago'
```

 **static Integer get\_year\_difference(Time time\_from, Time time\_to)**

- params:
	-  **Time** *time\_from*: The initial moment of the calculation
	-  **Time** *time\_to*: The final moment of the calculation

- returns: [**Time**] The difference in years of the 2 times.

- description: Calculates the year difference between 2 Time objects and returns an integer based on that. The calculation is always time\_to - time\_from. Timezone is always taken into account.

- example:

```ruby
puts LC::Date.get_year_difference(LC::Date.now, LC::Date.now+4.days)
# This will display '0'

puts LC::Date.distance_to_words(LC::Date.now, LC::Date.now+6.years)
# This will display '6'
```
