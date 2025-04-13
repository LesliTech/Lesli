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

Made with ♥ by LesliTech
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
            status()
        end

        desc "Seed & prepare Lesli database (development only)"
        task :seed => :environment do |task, args|
            seed()
            status()
        end

        desc "Migrate, seed & prepare the Lesli database (development only)"
        task :dev => :environment do |task, args|
            migrate()
            prepare()
            seed()
            status()
        end

        desc "Migrate, prepare && user the Lesli database"
        task :deploy => :environment do |task, args|
            create()
            migrate()
            prepare()
            status()
        end

        desc "Migrate & prepare the Lesli database"
        task :setup => :environment do |task, args|
            migrate()
            prepare()
            status()
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

        # print a message to let the users show the action running
        L2.m("Create the Lesli database (development only)")

        Rake::Task['db:create'].invoke
    end

    # Migrate the Lesli database 
    def migrate

        # print a message to let the users show the action running
        L2.m("Migrate the Lesli database")

        Rake::Task['db:migrate'].invoke
    end

    def seed

        # print a message to let the users show the action running
        L2.msg("Seed the Lesli database")

        # load main app seeders
        Rake::Task['db:seed'].invoke

        # load Lesli* gems seeders
        Lesli::Engine.load_seed
        LesliBell::Engine.load_seed if defined?(LesliBell)
        LesliAdmin::Engine.load_seed if defined?(LesliAdmin)
        LesliAudit::Engine.load_seed if defined?(LesliAudit)
        LesliLetter::Engine.load_seed if defined?(LesliLetter)
        LesliSupport::Engine.load_seed if defined?(LesliSupport)
        LesliCalendar::Engine.load_seed if defined?(LesliCalendar)
    end

    def prepare 

        # print a message to let the users show the action running
        L2.msg("Prepare the Lesli database")

        Lesli::Account.all.each do |account|
            account.initialize_account
            account.initialize_engines
        end

        # scan rails routes to build the controllers index
        Rake::Task['lesli:controllers:build'].invoke

        # scan rails routes to build the controllers index
        Rake::Task['lesli:shield:privileges'].invoke if defined?(LesliShield)

        # scan rails routes to build the base of translations
        Rake::Task['lesli:babel:scan'].invoke if defined?(LesliBabel)

        # import local translations into LesliBabel
        Rake::Task['lesli:babel:import'].invoke if defined?(LesliBabel)
    end 

    def status 
        # print the lesli gems
        Rake::Task['lesli:status'].invoke 
    end
end
