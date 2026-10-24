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

module Lesli
    class DatabaseTasks

        # Rails calls this object when db:prepare creates a new database. Its
        # intentionally empty implementation keeps preparation separate from seeds.
        class SeedlessLoader
            def load_seed
            end
        end
        private_constant :SeedlessLoader

        def rebuild
            reset_database
            seed_database
            configure_database
            print_status
        end

        def build
            prepare_database
            seed_database
            configure_database
            print_status
        end

        def prepare
            prepare_database
            configure_database
            print_status
        end

        def seed
            seed_database
            configure_database
            print_status
        end

        private

        def reset_database
            unless Rails.env.development? || Rails.env.test?
                raise "lesli:db:rebuild can only run in development or test"
            end

            Termline.m("Rebuild the Lesli database from migrations (development and test only)")

            Rake::Task["db:migrate:reset"].invoke
            Termline.info("Databases rebuilt from the available migrations")
        end

        def prepare_database
            Termline.info("Prepare the Lesli database")

            database_tasks = ActiveRecord::Tasks::DatabaseTasks
            original_seed_loader = database_tasks.seed_loader

            database_tasks.seed_loader = SeedlessLoader.new
            Rake::Task["db:prepare"].invoke
        ensure
            database_tasks.seed_loader = original_seed_loader if database_tasks
        end

        def seed_database
            Termline.info("Seed the Lesli database")

            LesliSystem.engines.each_key do |engine|
                next if engine == "Root"

                engine.constantize::Engine.load_seed
            end

            Rake::Task["db:seed"].invoke
            Termline.info("Loading seeds for: Main app")
            Termline.br(2)
        end

        def configure_database
            Termline.info("Setup the Lesli database")

            build_resources
            initialize_accounts
            synchronize_privileges
            synchronize_translations
        end

        def build_resources
            Rake::Task["lesli:resources:build"].invoke
        end

        def initialize_accounts
            Lesli::Account.find_each do |account|
                account.initialize_account
                account.initialize_engines
            end
        end

        def synchronize_privileges
            Rake::Task["lesli_shield:privileges"].invoke if defined?(::LesliShield)
        end

        def synchronize_translations
            return unless defined?(::LesliBabel)

            Rake::Task["lesli_babel:scan"].invoke
            Rake::Task["lesli_babel:import"].invoke
        end

        def print_status
            Rake::Task["lesli:status"].invoke
        end
    end
end
