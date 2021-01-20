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

class DevGithub < LesliTasks
    

    def initialize
        namespace :dev2 do        
            namespace :github do

                desc "Distribute github workflows and actions to all the installed engines"
                task :actions => :environment do |task, args|
                    ARGV.each { |a| task a.to_sym do ; end }
        
                    # execute command
                    actions
        
                end

            end
        end
    end


    
    private



    # Distribute github workflows and actions to all the installed engines
    def actions

        # for every installed engine
        Lesli::engines.each do |engine|

            engine_path = Rails.root.join("engines", engine[:code])

            next unless File.exists?(engine_path)
            
            message_separator

            message("Working with: #{engine[:code]}")

            command("cd ./engines/#{engine[:code]} && git add --all && git commit -m \"ci: update github workflows and actions\"")

        end

        message("Working with: Lesli")

        #command("git add .github && git commit -m \"ci: update github workflows and actions\" .github")

        message_separator

        message_cow

    end

end

# Instantiate the class to define the tasks:
DevGithub.new
