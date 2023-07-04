=begin

Lesli

Copyright (c) 2023, Lesli Technologies, S. A.

This program is free software: you can redistribute it and/or modify
it under the terms of the GNU General Public License as published by
the Free Software Foundation, either version 3 of the License, or
(at your option) any later version.

This program is distributed in the hope that it will be useful,
but WITHOUT ANY WARRANTY; without even the implied warranty of
MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the
GNU General Public License for more details.

You should have received a copy of the GNU General Public License
along with this program. If not, see http://www.gnu.org/licenses/.

Lesli · Your Smart Business Assistant. 

Made with ♥ by https://www.lesli.tech
Building a better future, one line of code at a time.

@contact  hello@lesli.tech
@website  https://lesli.tech
@license  GPLv3 http://www.gnu.org/licenses/gpl-3.0.en.html

// · ~·~     ~·~     ~·~     ~·~     ~·~     ~·~     ~·~     ~·~     ~·~     ~·~     ~·~     ~·~
// · 

=end

require "./lib/tasks/lesli_rake"

class DevGit < LesliRake


    def initialize
        namespace :dev do
            namespace :git do

                desc "Push code to remote branch/origin for all engines"
                task :push => :environment do |task, args|
                    ARGV.each { |a| task a.to_sym do ; end }

                    branch="ldonis"
                    origin="origin"

                    # get params sent by user
                    branch = ARGV[1] unless ARGV[1].blank?
                    origin = ARGV[2] unless ARGV[2].blank?

                    # execute command
                    push branch, origin

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
                    git_message = ARGV[1] unless ARGV[1].blank?

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
                    branch = ARGV[1] unless ARGV[1].blank?
                    force = ARGV[2] == "force"

                    # execute command
                    checkout branch, force

                end

                desc "Push code to backup repositories for all engines"
                task :backup => :environment do |task, args|
                    ARGV.each { |a| task a.to_sym do ; end }

                    # execute command
                    push "master", "backup"

                end

                desc "Update vendor from node_modules"
                task :vendor => :environment do |task, args|
                    ARGV.each { |a| task a.to_sym do ; end }

                    # execute command
                    vendor

                end

                desc "Add origins"
                task :origin => :environment do |task, args|
                    ARGV.each { |a| task a.to_sym do ; end }

                    # default params
                    force = false
                    engine = "all"

                    # get params sent by user
                    engine = ARGV[1] unless ARGV[1].blank?
                    force = ARGV[2] == "all"

                    # execute command
                    origin(engine, force)

                end

            end
        end
    end



    private



    # Push code to remote branch/origin for all engines
    def push branch, origin

        # for every installed engine
        Lesli::engines.each do |engine|

            #build engine path
            engine_path = Rails.root.join("engines", engine[:code])

            next unless File.exists?(engine_path)

            message_separator
            message("Working with: #{engine[:code]}")

            command("cd ./engines/#{engine[:code]} && git push #{ origin } #{ branch }")

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
            engine_path = Rails.root.join("engines", engine[:code])

            next unless File.exists?(engine_path)

            message_separator
            message("Working with: #{engine[:code]}")

            command("cd ./engines/#{engine[:code]} && git pull origin master")

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

            engine_path = Rails.root.join("engines", engine[:code])

            next unless File.exists?(engine_path)

            message_separator
            message("Working with: #{engine[:code]}")
            command("cd ./engines/#{engine[:code]} && git add --all && git commit -m \"#{ git_message }\"")

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
            engine_path = Rails.root.join("engines", engine[:code])

            next unless File.exists?(engine_path)

            message_separator
            message "Working with: #{engine[:code]}"

            command("cd ./engines/#{engine[:code]} && git reset --hard") if force
            command("cd ./engines/#{engine[:code]} && git checkout #{ branch }")

        end

        message("Working with: Lesli")

        command("git checkout #{ branch }")

        message_separator
        message_cow

    end

    def vendor

        # copy vendor dependencies (only css files are required)
        command("rm -r vendor/*")


        # updated version of libraries
        [
            "trix",
            "bulma",
            "lesli-css",
            "remixicon",
            "@fullcalendar"
        ].each do |package|
            FileUtils.cp_r "node_modules/#{package}/", "vendor/#{package}", :verbose => true
        end

        Dir.glob("vendor/**/*").each do |file|
            next if file.end_with?(".css")
            next if file.end_with?(".scss")
            next if file.end_with?(".sass")
            next if file.end_with?("LICENSE")
            next if file.end_with?("License")
            next if file.end_with?("license")
            next if File.directory?(file)
            FileUtils.rm(file, :verbose => true) 
        end

        # commit any change in vendor
        command("git add vendor && git commit -m \"vendor: update npm dependencies (vendors)\" vendor")

    end

    def origin engine_name, force

        # for every installed engine
        Lesli::engines.each do |engine|

            break if engine_name == "core"

            # build engine path
            engine_path = Rails.root.join("engines", engine[:code])

            next unless File.exists?(engine_path)

            next if (engine_name != "all" && engine_name != engine[:code])

            ["github", "origin", "lesli", "backup"].each do |origin|

                remote = engine.dig(:github, :ssh) if origin == "github"
                remote = engine.dig(:github, :ssh) if origin == "origin"
                remote = engine.dig(:github, :ssh_backup) if origin == "lesli"
                remote = engine.dig(:github, :ssh_backup) if origin == "backup"

                message("working with: #{engine[:code]} -> #{remote}")
                command("cd ./engines/#{engine[:code]} && git remote add #{origin} #{remote}")

            end

        end

        if engine_name == "core" || engine_name == "all"
            message("working with core")
            command("git remote add github git@github.com:leitfaden/Lesli.git")
            command("git remote add origin git@github.com:leitfaden/Lesli.git")
            command("git remote add backup git@github.com:LesliTech/Lesli.git")
            command("git remote add lesli git@github.com:LesliTech/Lesli.git")
        end

        message_separator
        message_cow

    end

end

# Instantiate the class to define the tasks:
DevGit.new
