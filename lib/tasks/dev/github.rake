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

Lesli · Ruby on Rails SaaS development platform.

Made with ♥ by https://www.lesli.tech
Building a better future, one line of code at a time.

@contact  hello@lesli.tech
@website  https://www.lesli.tech
@license  GPLv3 http://www.gnu.org/licenses/gpl-3.0.en.html

// · ~·~     ~·~     ~·~     ~·~     ~·~     ~·~     ~·~     ~·~     ~·~
// · 
=end

REPOSITORY = "LesliGithub"

namespace :dev do
    namespace :github do

        desc "Distribute github workflows and actions to all the installed engines"
        task :actions => :environment do |task, args|
            ARGV.each { |a| task a.to_sym do ; end }

            # execute command
            actions

            L2.cow("Process completed!")

        end
    end
end

# Distribute github workflows and actions to all the installed engines
def actions

    lesli_github_actions_path=nil;

    # check if github actions repository exist in the engines folder
    if File.exists?(Rails.root.join("engines", REPOSITORY))
        lesli_github_actions_path = Rails.root.join("engines", REPOSITORY, "workflows")
    end

    # check if github actions repository exist in the enginesdev folder
    if lesli_github_actions_path.blank? && File.exists?(Rails.root.join("enginesdev", REPOSITORY))
        lesli_github_actions_path = Rails.root.join("enginesdev", REPOSITORY, "workflows")
    end

    # check if github actions repository exist
    if lesli_github_actions_path.blank?
        L2.warn "Actions folder not found! - please clone the repo into the engines folder."
        return
    end

    # get all the available workflows
    workflows_for_core = Dir.glob(lesli_github_actions_path.join("core", "*"))
    workflows_for_engines = Dir.glob(lesli_github_actions_path.join("engine", "*"))
    workflows_for_builders = Dir.glob(lesli_github_actions_path.join("builder", "*"))

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

    # commit for core
    system("git add .github && git commit -m \"ci: update github workflows and actions\"")

    L2.msg("Updating Github action workflows for Lesli core")



    # for every installed engine
    Lesli::engines.each do |engine|

        engine_path = Rails.root.join("engines", engine[:code])

        next unless File.exists?(engine_path)

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

        system("cd ./engines/#{engine[:code]} && git add .github && git commit -m \"ci: update github workflows and actions\"")

        L2.msg("Updating Github action workflows for Lesli Engine #{ engine[:code] }")

    end
end
