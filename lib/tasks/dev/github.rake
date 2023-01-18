=begin

Copyright (c) 2023, all rights reserved.

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

require "./lib/tasks/lesli_rake"

class DevGithub < LesliRake


    def initialize
        namespace :dev do
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


        # check if github actions repository exist
        if not File.exists?(Rails.root.join("engines", "github_actions"))
            message("Actions folder not found! - please clone the repo into the engines folder.")
            return
        end

        # get all the available workflows
        workflows_for_core = Dir.glob(Rails.root.join("engines", "github_actions", "workflows", "core", "*"))
        workflows_for_engines = Dir.glob(Rails.root.join("engines", "github_actions", "workflows", "engine", "*"))
        workflows_for_builders = Dir.glob(Rails.root.join("engines", "github_actions", "workflows", "builder", "*"))

        message("Working with: core")

        # remove github workflows folder if it exists
        FileUtils.rm_rf Rails.root.join(".github", "workflows")

        # create github workflows folder if it does not exist
        FileUtils.mkdir_p Rails.root.join(".github", "workflows")

        # work with every workflow file found on github actions repository
        workflows_for_core.each do |file_path|

            # get the name of the workflow file
            filename = File.basename(file_path)

            # get the content of the workflow file
            workflow = File.read(file_path)

            # write workflow file into engine
            File.write(Rails.root.join(".github", "workflows", filename), workflow)

        end

        command("git branch -D github-actions && git checkout -b github-actions && git add .github && git commit -m \"ci: update github workflows and actions\" && git push origin github-actions")
        command("git checkout master")

        # for every installed engine
        Lesli::engines.each do |engine|

            engine_path = Rails.root.join("engines", engine[:code])

            next unless File.exists?(engine_path)

            message_separator

            message("Working with: #{engine[:code]}")

            # remove github workflows folder if it exists
            FileUtils.rm_rf engine_path.join(".github", "workflows")

            # create github workflows folder if it does not exist
            FileUtils.mkdir_p engine_path.join(".github", "workflows")

            # work with every workflow file found on github actions repository
            workflows_for_engines.each do |file_path|
                next if engine[:type] == "builder"

                # get the name of the workflow file
                filename = File.basename(file_path)

                # get the content of the workflow file
                workflow = File.read(file_path)

                # write workflow file into engine
                File.write(engine_path.join(".github", "workflows", filename), workflow)

            end

            workflows_for_builders.each do |file_path|
                next unless engine[:type] == "builder"

                # get the name of the workflow file
                filename = File.basename(file_path)

                # get the content of the workflow file
                workflow = File.read(file_path)

                # search and replace variables with value of the engine
                workflow = workflow.gsub("[[BUILDER_CODE]]", engine[:code])

                # write workflow file into engine
                File.write(engine_path.join(".github", "workflows", filename), workflow)

            end

            # message("cd ./engines/#{engine[:code]} && git branch -D github-actions && git checkout -b github-actions && git add .github && git commit -m \"ci: update github workflows and actions\" && git push origin github-actions")
            command("cd ./engines/#{engine[:code]} && git branch -D github-actions && git checkout -b github-actions && git add .github && git commit -m \"ci: update github workflows and actions\" && git push origin github-actions")
            command("cd ./engines/#{engine[:code]} && git checkout master")

        end

        message_separator

        message_cow

    end

end

# Instantiate the class to define the tasks:
DevGithub.new
