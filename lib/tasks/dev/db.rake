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

require "./lib/tasks/lesli_tasks"

class Db < LesliTasks

    def initialize
        namespace :dev do
            namespace :db do

                desc ""
                task :reset => :environment do |task, args|
                    ARGV.each { |a| task a.to_sym do ; end }
        
                    env = 'development'
                    env = ARGV[1] if not ARGV[1].blank?

                    # execute command
                    reset env
        
                end

            end

        end

    end



    private



    # Push code to remote branch/origin for all engines
    def reset environment

        message("Reset database for #{environment}")

        message("drop database")
        Rake::Task['db:drop'].invoke

        message("create database")
        Rake::Task['db:create'].invoke

        message("migrate database")
        Rake::Task['db:migrate'].invoke

        message("seed database")
        Rake::Task['db:seed'].invoke

        message_separator
        message_cow

    end

end

Db.new
