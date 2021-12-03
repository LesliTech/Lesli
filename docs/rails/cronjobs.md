# Cronjobs
The platform use the gem [**whenever**](https://github.com/javan/whenever) gem to create cron jobs. We created a custom schedule.rb which reads the cron jobs of each installed engine and creates a cron file with all the cron jobs found.


## Shedule cron jobs
Lesli allows define cron jobs in any engine.

### Where define the cron jobs?
To setup cron jobs you need to create a schedule.rb file inside the config folder of the engine.

example:

```bash
sudo nano engines/engine_name/config/schedule.rb
```

We use the methods provided by the gem Whenever.

example:
```bash
every 1.day, at: '4:30 am' do
  runner "rake:engine_name:test"
end
```