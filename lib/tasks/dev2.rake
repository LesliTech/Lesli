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

        end
    end

    private

    def help

    end

end

# Instantiate the class to define the tasks:
Dev.new
