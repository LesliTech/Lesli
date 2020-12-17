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

class BicycleTasks < LesliTasks
    

    def initialize
        namespace :dev2 do        
            namespace :git do

                desc "Commit pending changes from all engines"
                task commit: :environment do
                    ARGV.each { |a| task a.to_sym do ; end }

                    # default params
                    git_message = "add updates from development"

                    # get params sent by user
                    git_message = ARGV[1] if not ARGV[1].blank?

                    # execute command
                    commit git_message
        
                end

                desc "Checkout all engines to a different branch"
                task :checkout => :environment do |task, args|
                    ARGV.each { |a| task a.to_sym do ; end }

                    # default params
                    force = false
                    branch = "master"

                    # get params sent by user
                    branch = ARGV[1] if not ARGV[1].blank?
                    force = ARGV[2] == "force"

                    # execute command
                    checkout branch, force

                end

            end
        end
    end

    private

    def commit git_message

        # for every installed engine
        Lesli::engines.each do |engine|

            #build engine path
            engine_path = Rails.root.join("engines", engine["name"])

            next unless File.exists?(engine_path)
            
            message_separator
            message "Working with: #{engine['name']}"

            command("cd ./engines/#{engine['name']} && git add --all && git commit -m #{ git_message }")

        end

        # push core to github
        puts ""; puts ""; puts "";
        puts "Working with: Lesli"

        # commit any possible pending change
        system "git add --all && git commit -m #{ git_message }"

    end

    def checkout branch, force

        # for every installed engine
        Lesli::engines.each do |engine|

            # build engine path
            engine_path = Rails.root.join("engines", engine["name"])

            next unless File.exists?(engine_path)

            message_separator
            message "Working with: #{engine['name']}"
            
            command("cd ./engines/#{engine['name']} && git reset --hard") if force
            command("cd ./engines/#{engine['name']} && git checkout master")

        end

        # pull from master
        message "Working with: Lesli"

        command("git pull origin master")

        message_separator
        message_cow

    end

end

# Instantiate the class to define the tasks:
BicycleTasks.new
