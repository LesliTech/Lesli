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

Lesli · Ruby on Rails SaaS Development Framework.

Made with ♥ by https://www.lesli.tech
Building a better future, one line of code at a time.

@contact  hello@lesli.tech
@website  https://www.lesli.tech
@license  GPLv3 http://www.gnu.org/licenses/gpl-3.0.en.html

// · ~·~     ~·~     ~·~     ~·~     ~·~     ~·~     ~·~     ~·~     ~·~
// · 
=end

# · 
namespace :lesli do 
    namespace :dev do

        desc "Print a welcome message with some basic instructions"
        task :welcome => :environment do |task, args|
            welcome()
        end

        desc "Distribute github workflows and actions to all the installed enginess"
        task :actions => :environment do |task, args|
            actions()
        end
    end

    # Seed database (development only)
    def welcome

        # do not execute this task if we are at production level
        return if Rails.env.production?

        L2.br(4)

        # print the lesli gems
        Rake::Task['lesli:status'].invoke 

        password = Lesli.config.security.dig(:password)
        password = password  + Time.now.year.to_s + "$"
        user = Lesli::User.first

        L2.line
        L2.m(" Owner user credentials (demo):")
        L2.m(" username: #{ user.email }")
        L2.m(" password: #{ password }")
        L2.line

        L2.cow "Enjoy your Lesli demo"
    end

    # Distribute github workflows and actions to all the installed engines
    def actions
        L2.info "start"

        # get all the available workflows
        workflows = Dir.glob(Rails.root.join("engines", "Lesli", ".github", "workflows", "*"))

        Lesli::System.engines.each do |engine|
            engine = engine[1]

            next if engine[:name] == "Lesli"

            engine_path = Rails.root.join("engines", engine[:name])

            next unless File.exist?(engine_path)

            pp "working with #{engine[:name]}"
            
            # remove github workflows folder if it exists
            FileUtils.rm_rf engine_path.join(".github", "workflows")

            # create github workflows folder if it does not exist
            FileUtils.mkdir_p engine_path.join(".github", "workflows")

            pp workflows

            # work with every workflow file found on github actions repository
            workflows.each do |file_path|

                pp file_path

                # get the name of the workflow file
                filename = File.basename(file_path)

                # get the content of the workflow file
                workflow = File.read(file_path)

                # write workflow file into engine
                File.write(engine_path.join(".github", "workflows", filename), workflow)

            end
        end
        L2.info "end"
    end
end
