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
    namespace :db do

        desc "Drop, build, migrate & seed Lesli database (development only)"
        task :reset => :environment do |task, args|
            reset()
            start()
            seed()
            setup()
        end

        desc "Build, migrate & seed Lesli database"
        task :start => :environment do |task, args|
            start()
            seed()
            setup()
        end

        desc "Build, migrate & seed Lesli database"
        task :seed => :environment do |task, args|
            seed()
            setup()
        end

        desc "Build, migrate & seed Lesli database"
        task :setup => :environment do |task, args|
            setup()
        end
    end

    # Drop, build, migrate & seed database (development only)
    def reset

        # do not execute this task if we are at production level
        return if Rails.env.production?

        # print a message to let the users show the action running
        L2.m("Reset Lesli database for development")

        Rake::Task['db:drop'].invoke
    end

    # Build, migrate & seed database (development only)
    def start

        # do not execute this task if we are at production level
        return if Rails.env.production?

        # print a message to let the users show the action running
        L2.m("Start Lesli database for development")

        Rake::Task['db:create'].invoke
        Rake::Task['db:migrate'].invoke
    end

    # Seed database (development only)
    def seed

        # do not execute this task if we are at production level
        return if Rails.env.production?

        # print a message to let the users show the action running
        L2.msg("Seed Lesli database for development")

        # load main app seeders
        Rake::Task['db:seed'].invoke

        # load Lesli* gems seeders
        Lesli::Engine.load_seed
        LesliBell::Engine.load_seed if defined?(LesliBell)
        LesliHelp::Engine.load_seed if defined?(LesliHelp)
        LesliAudit::Engine.load_seed if defined?(LesliAudit)
        LesliLetter::Engine.load_seed if defined?(LesliLetter)
    end

    def setup 

        # do not execute this task if we are at production level
        return if Rails.env.production?

        # print a message to let the users show the action running
        L2.msg("Start Lesli database for development")

        # scan rails routes to build the controllers index
        Rake::Task['lesli:controllers:build'].invoke

        # scan rails routes to build the controllers index
        Rake::Task['lesli:guard:privileges'].invoke

        # scan rails routes to build the base of translations
        Rake::Task['lesli:babel:build'].invoke if defined?(LesliBabel)

        # print the lesli gems
        Rake::Task['lesli:status'].invoke 
    end 
end
