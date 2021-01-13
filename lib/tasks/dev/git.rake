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

require "./lesli"

namespace :dev do

    namespace :git do

        desc "Push everything to github master"
        task push: :environment do

            # push all engines
            Lesli::engines.each do |engine|
                engine_path = Rails.root.join('engines', engine[:name])
                puts ""; puts ""; puts "";
                puts "Working with: #{engine[:name]}"
                system "cd ./engines/#{engine[:name]} && git push origin master" if File.exists?(engine_path)
            end
            
            # push core to github
            puts ""; puts ""; puts "";
            puts "Working with: Lesli"
            system "git push github master"

        end

        desc "Pull everything from github master. If you add the 'force' argument, it will force a reset and a checkout to master"
        task :pull, [:force] => :environment do |task, args|
            force_command = ""
            force_command = " git reset --hard && git checkout master && " if args[:force]

            Lesli::engines.each do |engine|

                # build engine path
                engine_path = Rails.root.join('engines', engine[:name])

                # pull from master
                puts ""; puts ""; puts "";
                puts "Working with: #{engine[:name]}"
                result = `cd ./engines/#{engine[:name]} && #{force_command} git pull origin master` if File.exists?(engine_path)

            end

            # pull from master
            puts ""; puts ""; puts "";
            puts "Working with: Lesli"
            system "#{force_command} git pull origin master"

        end

        desc "Commit everything to github master"
        task commit: :environment do

            # push all engines
            Lesli::engines.each do |engine|
                engine_path = Rails.root.join('engines', engine[:name])
                puts ""; puts ""; puts "";
                puts "Working with: #{engine[:name]}"
                system "cd ./engines/#{engine[:name]} && git add --all && git commit -m \"add updates from development\""

            end
            
            # push core to github
            puts ""; puts ""; puts "";
            puts "Working with: Lesli"

            # commit any possible pending change
            system "git add --all && git commit -m \"dev update\""

            Rake::Task["dev:git:vendors"].invoke

        end

        desc ""
        task backup: :environment do

            Lesli::engines.each do |engine|
                engine_path = Rails.root.join('engines', engine[:name])

                puts ""; puts ""; puts "";
                puts "Working with: #{engine[:name]}"
                system "cd ./engines/#{engine[:name]} && git push backup master" if File.exists?(engine_path)
            end

            puts ""; puts ""; puts "";
            puts "Working with: Lesli"
            system "git push backup master"

        end

        desc "Add github origin"
        task add_origin: :environment do

            Lesli::engines.each do |engine|

                # build engine path
                engine_path = Rails.root.join('engines', engine[:name])

                # next if engine folder does not exist
                next unless File.exists?(engine_path)

                ["github", "origin", "lesli", "backup"].each do |origin|

                    remote = engine['github']['ssh'] if origin == "github"
                    remote = engine['github']['ssh'] if origin == "origin"
                    remote = engine['github']['ssh_backup'] if origin == "lesli"
                    remote = engine['github']['ssh_backup'] if origin == "backup"

                    puts ""; puts ""; puts "";
                    puts "Working with: #{engine[:name]} for: #{origin}"
                    exec_command "cd ./engines/#{engine[:name]} && git remote add #{origin} #{remote}" 

                end

            end

            exec_command "git remote add github git@github.com:leitfaden/Lesli.git" 
            exec_command "git remote add origin git@github.com:leitfaden/Lesli.git" 
            exec_command "git remote add backup git@github.com:LesliTech/Lesli.git" 
            exec_command "git remote add lesli git@github.com:LesliTech/Lesli.git" 

        end

        desc ""
        task checkout_master: :environment do

            Lesli::engines.each do |engine|

                # build engine path
                engine_path = Rails.root.join('engines', engine[:name])

                # pull from master
                puts ""; puts ""; puts "";
                puts "Working with: #{engine[:name]}"
                result = `cd ./engines/#{engine[:name]} && git checkout master` if File.exists?(engine_path)

            end

            # pull from master
            puts ""; puts ""; puts "";
            puts "Working with: Lesli"
            system "git pull origin master"

        end

        desc ""
        task vendors: :environment do 

            # copy vendor dependencies (only css files are required)
            system "rm -r vendor/*"

            ["buefy", "bulma", "bulma-o-steps", "bulma-extensions", "quill", "@fullcalendar", "lesli-css"].each do |package|
                FileUtils.cp_r "node_modules/#{package}/", "vendor/", :verbose => true
            end

            Dir.glob("vendor/**/*").each do |file|
                FileUtils.rm(file, :verbose => true) if file.index("package.json")
                FileUtils.rm(file, :verbose => true) if file.index("package-lock.json")
            end

            # commit any change in vendor
            #system "git add --all && git commit -m \"Update npm dependencies (vendors)\""

        end

        def exec_command command
            begin
                system command
            rescue
            end
        end

    end

end
