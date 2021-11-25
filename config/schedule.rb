=begin

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

=end
set :output, 'log/cron.log'

# ======================== DeutscheLeibrenten cron jobs

# Tasks
every :day, at: '05:55 am' do
    rake 'deutsche_leibrenten:cron:send_email_tasks_reminder_by_user' if defined? DeutscheLeibrenten
end

every :day, at: '10:10 pm' do
    rake 'deutsche_leibrenten:cron:create_reminder_task' if defined? DeutscheLeibrenten
end

every :day, at: '10:20 pm' do
    rake 'deutsche_leibrenten:cron:send_email_deadline_reminder_tasks_by_user' if defined? DeutscheLeibrenten
end

every :day, at: '10:30 pm' do
    rake 'deutsche_leibrenten:cron:send_email_users_with_delayed_tasks' if defined? DeutscheLeibrenten
end


# Leads
every :hour do
    rake 'deutsche_leibrenten:cron:send_alert_if_no_lead_registered' if defined? DeutscheLeibrenten
end

every :day, at: '10:00 pm' do
    rake 'deutsche_leibrenten:cron:send_daily_email_leads_coming' if defined? DeutscheLeibrenten
end

every :day, at: '11:00 pm' do
    rake 'deutsche_leibrenten:cron:create_lead_origin_reminder_task' if defined? DeutscheLeibrenten
end

every 1.month, at: '10:00 pm' do
    rake 'deutsche_leibrenten:cron:send_monthly_email_leads_coming' if defined? DeutscheLeibrenten
end


# Companies
every :monday, at: '4:00 am' do
    rake 'deutsche_leibrenten:cron:send_report_companies_projects' if defined? DeutscheLeibrenten
end

every :day, at: '11:00 pm' do
    rake 'deutsche_leibrenten:cron:delete_kops_deadline_reached' if defined? DeutscheLeibrenten
end

every :day, at: '11:10 pm' do
    rake 'deutsche_leibrenten:cron:clear_kops_information' if defined? DeutscheLeibrenten
end


# Projects
every :day, at: '06:00 am' do
    rake 'deutsche_leibrenten:cron:notify_projects_created_by_callcenter' if defined? DeutscheLeibrenten
end

every :day, at: '10:50 pm' do
    rake 'deutsche_leibrenten:cron:delete_projects' if defined? DeutscheLeibrenten
end

every :day, at: '11:30 am' do
    rake 'deutsche_leibrenten:cron:create_project_follow_up_reminder_task' if defined? DeutscheLeibrenten
end


# System Maintenance
every :day, at: '11:10 pm' do
    rake 'deutsche_leibrenten:cron:upload_local_files_to_s3' if defined? DeutscheLeibrenten
end

every :day, at: '11:45 pm' do
    rake 'deutsche_leibrenten:cron:delete_old_local_reports' if defined? DeutscheLeibrenten
end


# Reports
every :day, at: '09:50 pm' do
    rake 'deutsche_leibrenten:cron:generate_reports' if defined? DeutscheLeibrenten
end


# Integrations
every :day, at: '11:15 pm' do
    rake 'deutsche_leibrenten:cron:test_iframe_integration' if defined? DeutscheLeibrenten
end


# ======================== # Mitwerken Cron Jobs

every :day, at: '06:00 am' do
    rake 'mitwerken_cloud:cron:notify_outdated_projects' if defined? MitwerkenCloud
end

every :sunday, at: '10:00 pm' do
    rake 'mitwerken_cloud:cron:reports:new_users_weekly' if defined? MitwerkenCloud
end
