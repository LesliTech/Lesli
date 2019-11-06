
 set :output, "/log/cron.log"

 every 1.day, at: ['2:00 am', '2:00 pm', '4:00 pm', '6:00 pm', '8:00 pm', '10:00 pm', '11:59 pm'] do
   rake "dev:install"
end
