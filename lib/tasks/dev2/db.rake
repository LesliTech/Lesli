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
        namespace :dev2 do
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

        LC::Debug.msgc("Reset database for #{environment}")

        message("drop database")
        command("rake db:drop RAILS_ENV=#{environment}")

        message("create database")
        command("rake db:create RAILS_ENV=#{environment}")

        message("migrate database")
        command("rake db:migrate RAILS_ENV=#{environment}")

        message("seed database")
        command("rake db:seed RAILS_ENV=#{environment}")

        message_separator
        message_cow

    end

end

Db.new
