# Lesli Command Date2
LC::Date2 is a immutable date-time library with helpful functions to allow the user to manipulate datetimes using different formats and timezones with ease. Note that this class has some limitations: in its current version, LC::Date2 does not support settings nor multiple accounts, so all accounts under the same lesli instance will share the datetime timezone and time format settings.

<hr/>


### Initialize
This class is loaded automatically and is available any class inside the rails app. you can initialize a custom datetime object.

example:

```ruby

# initialize with current datetime
LC::Date2.new()

# initialize with a datetime object
LC::Date2.new(Time.current)

# initialize with a iso8601 datetime string
LC::Date2.new("1990-09-11T05:05:05+00:00")

# initialize with datetime string from database datetime column format
LC::Date2.new("1990-09-11 05:05:00")

# initialize with datetime string with custom format
LC::Date2.new("1990/09/11 05:05", "%Y/%m/%d %H:%M")
```

### Datetime formats

```ruby

# Date -> 2021.12.31
LC::Date.new.date 

# Date -> 18:05
LC::Date.new.time 

# Date -> 2021.12.31 18:05
LC::Date.new.date_time 

LC::Date.new.date_words

LC::Date.new.date_time_words
```

### Datetime to string

```ruby

# date to string -> "2021.01.01"
LC::Date2.new.date.to_s

# datetime to string -> "2021.01.01 18:05"
LC::Date2.new.date_time.to_s
```
