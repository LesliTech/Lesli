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

namespace :dev do
    namespace :db do

        desc "Drop, build, migrate & seed database (development only)"
        task :reset => :environment do |task, args|
            reset()
        end

        desc "Load development seeders"
        task :seed => :environment do |task, args|
            seed()
        end

    end

end


# Drop, build, migrate & seed database (development only)
def reset 

    return if Rails.env.production?

    L2.info("Reset database for development")

    Rake::Task['db:drop'].invoke
    Rake::Task['db:create'].invoke
    Rake::Task['db:migrate'].invoke
    Rake::Task['db:seed'].invoke

    #message_separator
    #message_cow

end


# Load development seeders for any environment
def seed
    
    load Rails.root.join("db", "seed", "tools.rb")
    load Rails.root.join("db", "seed", "development.rb")

    Rails.application.config.lesli[:engines].each do |engine|
        instance_klass = engine[:name].safe_constantize
        if File.exists?(instance_klass::Engine.root.join("db", "seed", "development.rb"))
            load(instance_klass::Engine.root.join("db", "seed", "development.rb"))
        end
    end

end 
