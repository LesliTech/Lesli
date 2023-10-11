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
        end

        desc "Build, migrate & seed Lesli database"
        task :setup => :environment do |task, args|
            setup()
        end

        desc "Build, migrate & seed Lesli database"
        task :seed => :environment do |task, args|
            seed()
        end
    end

    # Drop, build, migrate & seed database (development only)
    def reset
        return if Rails.env.production?
        L2.msg("Reset Lesli database for development")

        Rake::Task['db:drop'].invoke
        setup()
        seed()
    end

    # Build, migrate & seed database (development only)
    def setup
        return if Rails.env.production?
        L2.msg("Setup Lesli database for development")

        Rake::Task['db:create'].invoke
        Rake::Task['db:migrate'].invoke
        
        seed()
    end

    # Seed database (development only)
    def seed
        return if Rails.env.production?
        L2.msg("Seed Lesli database for development")

        Rake::Task['db:seed'].invoke

        Lesli::Engine.load_seed
        LesliBell::Engine.load_seed if defined?(LesliBell)
        LesliAudit::Engine.load_seed if defined?(LesliAudit)
        Rake::Task['lesli:controllers:build'].invoke
        Rake::Task['lesli:babel:build'].invoke if defined?(LesliBabel)
    end
end
