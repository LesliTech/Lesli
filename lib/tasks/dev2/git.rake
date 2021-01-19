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

class DevGit < LesliTasks
    

    def initialize
        namespace :dev2 do        
            namespace :git do

                desc "Push code to remote branch/origin for all engines"
                task :push => :environment do |task, args|
                    ARGV.each { |a| task a.to_sym do ; end }
        
                    # execute command
                    push 
        
                end

                desc "Pull code from origin master from all engines"
                task :pull => :environment do |task, args|
                    ARGV.each { |a| task a.to_sym do ; end }

                    # execute command
                    pull
                    
                end

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

                desc "Push code to backup repositories for all engines"
                task :backup => :environment do |task, args|
                    ARGV.each { |a| task a.to_sym do ; end }
        
                    # execute command
                    push "backup"
        
                end

                desc "Update vendor from node_modules"
                task :vendor => :environment do |task, args|
                    ARGV.each { |a| task a.to_sym do ; end }
        
                    # execute command
                    vendor
        
                end

            end
        end
    end


    
    private



    # Push code to remote branch/origin for all engines
    def push origin="origin", branch="ldonis"

        # for every installed engine
        Lesli::engines.each do |engine|

            #build engine path
            engine_path = Rails.root.join("engines", engine["name"])

            next unless File.exists?(engine_path)
            
            message_separator
            message("Working with: #{engine['name']}")

            command("cd ./engines/#{engine['name']} && git push #{ origin } #{ branch }")

        end

        message("Working with: Lesli")

        # commit any possible pending change
        command("git push #{ origin } #{ branch }")

        message_separator
        message_cow

    end



    # Pull code from origin master from all engines
    def pull

        # for every installed engine
        Lesli::engines.each do |engine|

            #build engine path
            engine_path = Rails.root.join("engines", engine["name"])

            next unless File.exists?(engine_path)
            
            message_separator
            message("Working with: #{engine['name']}")

            command("cd ./engines/#{engine['name']} && git pull origin master")

        end

        message("Working with: Lesli")

        # commit any possible pending change
        command("git pull origin master")

        message_separator
        message_cow

    end



    # Commit pending changes from all engines
    def commit git_message

        # for every installed engine
        Lesli::engines.each do |engine|

            #build engine path
            engine_path = Rails.root.join("engines", engine["name"])

            next unless File.exists?(engine_path)
            
            message_separator
            message("Working with: #{engine['name']}")
            command("cd ./engines/#{engine['name']} && git add --all && git commit -m \"#{ git_message }\"")

        end

        message_separator
        message("Working with: Lesli")

        # commit any possible pending change
        command("git add --all && git commit -m \"#{ git_message }\"")

        message_separator
        message_cow

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
            command("cd ./engines/#{engine['name']} && git checkout #{ branch }")

        end

        message("Working with: Lesli")

        command("git checkout #{ branch }")

        message_separator
        message_cow

    end

    def vendor

        # copy vendor dependencies (only css files are required)
        command("rm -r vendor/*")

        [
            "buefy", 
            "bulma", 
            "quill", 
            "lesli-css",
            "@fullcalendar", 
            "bulma-o-steps", 
            "bulma-extensions", 
            "foundation-emails",
            "grapesjs"
        ].each do |package|
            FileUtils.cp_r "node_modules/#{package}/", "vendor/", :verbose => true
        end

        Dir.glob("vendor/**/*").each do |file|
            FileUtils.rm(file, :verbose => true) if file.index("README.md")
            FileUtils.rm(file, :verbose => true) if file.index("LICENSE")
            FileUtils.rm(file, :verbose => true) if file.index("CHANGELOG.md")
            FileUtils.rm(file, :verbose => true) if file.index("CONTRIBUTING.md")
            FileUtils.rm(file, :verbose => true) if file.index("package.json")
            FileUtils.rm(file, :verbose => true) if file.index("package-lock.json")
        end

        # commit any change in vendor
        #command("git add vendor && git commit -m \"vendor:Update npm dependencies (vendors)\" vendor")

    end

end

# Instantiate the class to define the tasks:
DevGit.new
