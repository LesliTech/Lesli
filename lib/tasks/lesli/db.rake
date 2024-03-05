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

        desc "Drop, create, migrate, seed & prepare the Lesli database (development only)"
        task :reset => :environment do |task, args|
            drop()
            create()
            migrate()
            prepare()
            seed()
        end

        desc "Seed & prepare Lesli database (development only)"
        task :seed => :environment do |task, args|
            seed()
        end

        desc "Migrate, seed & prepare the Lesli database (development only)"
        task :dev => :environment do |task, args|
            migrate()
            prepare()
            seed()
        end

        desc "Migrate & prepare the Lesli database"
        task :setup => :environment do |task, args|
            migrate()
            prepare()
        end

        desc "Prepare the Lesli database"
        task :prepare => :environment do |task, args|
            prepare()
        end

        desc "Migrate, prepare && user the Lesli database"
        task :deploy => :environment do |task, args|
            migrate()
            prepare()
            Lesli::Engine.load_seed
        end
    end

    # Drop the Lesli database (development only)
    def drop

        # do not execute this task if we are at production level
        return if Rails.env.production?

        # print a message to let the users show the action running
        L2.m("Drop the Lesli database (development only)")

        Rake::Task['db:drop'].invoke
    end

    # Create the Lesli database (development only)
    def create

        # do not execute this task if we are at production level
        return if Rails.env.production?

        # print a message to let the users show the action running
        L2.m("Create the Lesli database (development only)")

        Rake::Task['db:create'].invoke
    end

    desc "Seed the Lesli database (development only)"
    def seed

        # do not execute this task if we are at production level
        return if Rails.env.production?

        # print a message to let the users show the action running
        L2.msg("Seed the Lesli database (development only)")

        # load main app seeders
        Rake::Task['db:seed'].invoke

        # load Lesli* gems seeders
        Lesli::Engine.load_seed
        LesliBell::Engine.load_seed if defined?(LesliBell)
        LesliHelp::Engine.load_seed if defined?(LesliHelp)
        LesliAudit::Engine.load_seed if defined?(LesliAudit)
        LesliLetter::Engine.load_seed if defined?(LesliLetter)
    end

    # Migrate the Lesli database 
    def migrate

        # print a message to let the users show the action running
        L2.m("Migrate the Lesli database")

        Rake::Task['db:migrate'].invoke
    end

    desc "Prepare the Lesli database"
    def prepare 

        # print a message to let the users show the action running
        L2.msg("Prepare the Lesli database")

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
