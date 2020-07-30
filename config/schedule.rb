=begin

Lesli

Copyright (c) 2020, Lesli Technologies, S. A.

All the information provided by this website is protected by laws of Guatemala related 
to industrial property, intellectual property, copyright and relative international laws. 
Lesli Technologies, S. A. is the exclusive owner of all intellectual or industrial property
rights of the code, texts, trade mark, design, pictures and any other information.
Without the written permission of Lesli Technologies, S. A., any replication, modification,
transmission, publication is strictly forbidden.
For more information read the license file including with this software.

Lesli - Your Smart Business Assistant

Powered by https://www.lesli.tech
Building a better future, one line of code at a time.

@contact  <hello@lesli.tech>
@website  <https://lesli.tech>
@license  Propietary - all rights reserved.

// · ~·~     ~·~     ~·~     ~·~     ~·~     ~·~     ~·~     ~·~     ~·~     ~·~     ~·~     ~·~
// · 

=end

#DeutscheLeibrenten cron jobs 
set :output, 'log/cron.log'

every :day, at: '12:10 am' do
    rake 'deutsche_leibrenten:cron:create_reminder_task' 
end

every :day, at: '12:20 am' do
    rake 'deutsche_leibrenten:cron:send_email_deadline_reminder_tasks_by_user' 
end

every :day, at: '12:30 am' do
    rake 'deutsche_leibrenten:cron:send_email_users_with_delayed_tasks' 
end

every :day, at: '12:50 am' do 
    rake 'deutsche_leibrenten:cron:delete_projects' 
end

every :day, at: '01:00 am' do
    rake 'deutsche_leibrenten:cron:delete_kops_deadline_reached' 
end

every :day, at: '01:10 am' do
    rake 'deutsche_leibrenten:cron:clear_kops_information'
end

every :day, at: '07:55 pm' do
    rake 'deutsche_leibrenten:cron:send_email_tasks_reminder_by_user' 
end

every :day, at: '08:00 am' do
    rake 'deutsche_leibrenten:cron:notify_projects_created_by_callcenter'
end

every :day, at: '12:00 am' do
    rake 'deutsche_leibrenten:cron:send_daily_email_leads_coming'
end

every 1.month, at: '12:00 am' do
    rake 'deutsche_leibrenten:cron:send_monthly_email_leads_coming' 
end
