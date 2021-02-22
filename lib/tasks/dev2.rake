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

class Dev < LesliTasks
    
    def initialize
        namespace :dev2 do

            desc "List the available tasks"
            task help: :environment do
                ARGV.each { |a| task a.to_sym do ; end }
            end

            desc "Test debug messages"
            task debug: :environment do
                ARGV.each { |a| task a.to_sym do ; end }
                debug
            end

        end
    end

    private

    def help

    end

    def debug
        LC::Debug.msg("LC::Debug.msg simple")
        LC::Debug.info("LC::Debug.info simple")
        LC::Debug.warn("LC::Debug.warn simple")
        LC::Debug.warn("LC::Debug.warn", "with", "multiple", "messages")
        LC::Debug.error("LC::Debug.error simple")
        LC::Debug.success("LC::Debug.success simple")
        LC::Debug.fatal("LC::Debug.fatal simple")
        LC::Debug.deprecation("LC::Debug.deprecation simple")
    end

end

# Instantiate the class to define the tasks:
Dev.new
