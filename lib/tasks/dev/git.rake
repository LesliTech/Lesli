=begin

Lesli

Copyright (c) 2020, Lesli Technologies, S. A.

All the information provided by this website is protected by laws of Guatemala related 
to industrial property, intellectual property, copyright and relative international laws. 
Lesli Technologies, S. A. is the exclusive owner of all intellectual or industrial property
rights of the code, texts, trade mark, design, pictures and any other information.
Without the written permission of Lesli Technologies, S. A., any replication, modification,
transmission, publication is strictly forbidden.
For more information read the license file including with this software.

LesliCloud - Your Smart Business Assistant

Powered by https://www.lesli.tech
Building a better future, one line of code at a time.

@license  Propietary - all rights reserved.
@version  0.1.0-alpha

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
                engine_path = Rails.root.join('engines', engine['name'])
                puts ""; puts ""; puts "";
                puts "Working with: #{engine['name']}"
                system "cd ./engines/#{engine['name']} && git push origin master" if File.exists?(engine_path)
            end
            
            # push core to github
            puts ""; puts ""; puts "";
            puts "Working with: Lesli"
            system "git push github master"

        end

        desc "Pull everything from github master"
        task pull: :environment do

            Lesli::engines.each do |engine|

                # build engine path
                engine_path = Rails.root.join('engines', engine['name'])

                # pull from master
                puts ""; puts ""; puts "";
                puts "Working with: #{engine['name']}"
                result = `cd ./engines/#{engine['name']} && git pull origin master` if File.exists?(engine_path)

            end

            # pull from master
            puts ""; puts ""; puts "";
            puts "Working with: Lesli"
            system "git pull origin master"

        end

        desc "Commit everything to github master"
        task commit: :environment do

            # push all engines
            Lesli::engines.each do |engine|
                engine_path = Rails.root.join('engines', engine['name'])
                puts ""; puts ""; puts "";
                puts "Working with: #{engine['name']}"
                system "cd ./engines/#{engine['name']} && git add --all && git commit -m \"add updates from development\""

            end
            
            # push core to github
            puts ""; puts ""; puts "";
            puts "Working with: Lesli"

            # commit any possible pending change
            system "git add --all && git commit -m \"dev update\""

            # copy vendor dependencies (only css files are required)
            system "rm -r vendor/*"
            ["buefy", "bulma", "bulma-o-steps", "bulma-extensions", "quill", "@fullcalendar", "lesli-css"].each do |package|
                FileUtils.cp_r "node_modules/#{package}/", "vendor/", :verbose => true
            end
            #system "cp node_modules/buefy/ vendor/ -ra"
            #system "cp node_modules/bulma/ vendor/ -ra"
            #system "cp node_modules/bulma-o-steps/ vendor/ -ra"
            #system "cp node_modules/bulma-extensions/ vendor/ -ra"
            #system "cp node_modules/quill/ vendor/ -ra"
            #system "cp node_modules/@fullcalendar/ vendor/ -ra"
            #system "cp node_modules/lesli-css/ vendor/ -ra"

            # commit any change in vendor
            #system "git add --all && git commit -m \"Update npm dependencies (vendors)\""

        end

        desc ""
        task backup: :environment do

            Lesli::engines.each do |engine|
                engine_path = Rails.root.join('engines', engine['name'])

                puts ""; puts ""; puts "";
                puts "Working with: #{engine['name']}"
                system "cd ./engines/#{engine['name']} && git push backup master" if File.exists?(engine_path)
            end

            puts ""; puts ""; puts "";
            puts "Working with: Lesli"
            system "git push lesli master"

        end

        desc "Add github origin"
        task add_origin: :environment do

            Lesli::engines.each do |engine|

                # build engine path
                engine_path = Rails.root.join('engines', engine['name'])

                # next if engine folder does not exist
                next unless File.exists?(engine_path)

                ["github", "origin", "lesli", "backup"].each do |origin|

                    remote = engine['github_ssh'] if origin == "github"
                    remote = engine['github_ssh'] if origin == "origin"
                    remote = engine['github_ssh_backup'] if origin == "lesli"
                    remote = engine['github_ssh_backup'] if origin == "backup"

                    # check if github remote exists
                    next if system "cd ./engines/#{engine['name']} && git remote show #{origin}" 

                    puts ""; puts ""; puts "";
                    puts "Working with: #{engine['name']} for: #{origin}"
                    system "cd ./engines/#{engine['name']} && git remote add #{origin} #{remote}" 

                end

            end

            system "git remote add github git@github.com:leitfaden/Lesli.git" 
            system "git remote add origin git@github.com:leitfaden/Lesli.git" 
            system "git remote add lesli git@github.com:LesliTech/Lesli.git" 
            system "git remote add backup git@github.com:LesliTech/Lesli.git" 

        end

    end

end
