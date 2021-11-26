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

# path is a variable of wenever class that returns the current path of the application
RAILS_ROOT = path

#output file
set :output, "log/cron.log"

# require needed to include active-record models and initializers.
require "#{RAILS_ROOT}/lesli.rb"

# include all schedule.rb of each engine
Lesli::engines().map do |engine|
    schedule_path = "#{RAILS_ROOT}/engines/#{engine[:code]}/schedule.rb"

    if(File.exist?(schedule_path)) # load file
        instance_eval(File.read(schedule_path), schedule_path)
    end
end
