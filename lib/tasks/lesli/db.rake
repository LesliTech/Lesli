=begin

Lesli

Copyright (c) 2026, Lesli Technologies, S. A.

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

        desc "Drop, create, migrate, seed & configure the Lesli database (development and test only)"
        task :rebuild => :environment do |task, args|
            drop()
            prepare()
            seed()
            configure()
            status()
        end

        desc "Create, migrate, seed & configure the Lesli database"
        task :build => :environment do |task, args|
            prepare()
            seed()
            configure()
            status()
        end

        desc "Migrate and configure the Lesli database"
        task :prepare => :environment do |task, args|
            prepare()
            configure()
            status()
        end

        desc "Seed and configure the Lesli database"
        task :seed => :environment do |task, args|
            seed()
            configure()
            status()
        end
    end

    # Drop the Lesli database (development and test only)
    def drop

        # This task is intentionally available only for disposable local and
        # automated-test databases.
        unless Rails.env.development? || Rails.env.test?
            raise "lesli:db:rebuild can only run in development or test"
        end

        # print a message to let the users show the action running
        Termline.m("Drop the Lesli database (development and test only)")

        Rake::Task['db:drop'].invoke
        Termline.info("Databases deleted")

        schema_file = Rails.root.join('db', 'schema.rb')
        if File.exist?(schema_file)
            File.delete(schema_file)
            Termline.info("Schema.rb file deleted")
        end
    end

    # Create the Lesli database (development only)
    def prepare

        # print a message to let the users show the action running
        Termline.info("Prepare the Lesli database")

        # Rails db:prepare loads the host application's seeds when it creates a
        # new database. Temporarily replace the seed loader so this Lesli step
        # prepares the database without loading application seeds.
        database_tasks = ActiveRecord::Tasks::DatabaseTasks
        original_seed_loader = database_tasks.seed_loader
        seedless_loader = Object.new
        def seedless_loader.load_seed
            # Intentionally skip the host application's seeds.
        end

        database_tasks.seed_loader = seedless_loader
        Rake::Task['db:prepare'].invoke
    ensure
        database_tasks.seed_loader = original_seed_loader if database_tasks
    end

    def seed

        # print a message to let the users show the action running
        Termline.info("Seed the Lesli database")

        # load Lesli* gems seeders
        LesliSystem.engines.each do |engine, data|
            next if engine == "Root"
            engine.constantize::Engine.load_seed
        end

        # load main app seeders
        Rake::Task['db:seed'].invoke
        Termline.info("Loading seeds for: Main app")
        Termline.br(2)
    end

    def configure 

        # print a message to let the users show the action running
        Termline.info("Setup the Lesli database")

        # scan rails routes to build the controllers index
        Rake::Task['lesli:resources:build'].invoke

        Lesli::Account.find_each do |account|
            account.initialize_account
            account.initialize_engines
        end

        # scan rails routes to build the controllers index
        Rake::Task['lesli_shield:privileges'].invoke if defined?(LesliShield)

        if defined?(LesliBabel)

            # scan rails routes to build the base of translations
            Rake::Task['lesli_babel:scan'].invoke 

            # import local translations into LesliBabel
            Rake::Task['lesli_babel:import'].invoke 
        end
    end 

    def status 
        # print the lesli status
        Rake::Task['lesli:status'].invoke 
    end
end
