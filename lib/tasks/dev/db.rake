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

namespace :dev do
    namespace :db do

        desc "Drop, build, migrate & seed database (development only)"
        task :reset => :environment do |task, args|
            reset()
        end

        desc "Load development seeders"
        task :seed => :environment do |task, args|
            seed()
        end

    end

end


# Drop, build, migrate & seed database (development only)
def reset

    return if Rails.env.production?

    L2.info("Reset database for development")

    Rake::Task['db:drop'].invoke
    Rake::Task['db:create'].invoke
    Rake::Task['db:migrate'].invoke
    Rake::Task['db:seed'].invoke

end


# Load development seeders for any environment
def seed

    load Rails.root.join("db", "seed", "tools.rb")
    load Rails.root.join("db", "seed", "development.rb")

    Rails.application.config.lesli.dig(:engines).each do |engine|
        instance_klass = engine[:name].safe_constantize
        if File.exists?(instance_klass::Engine.root.join("db", "seed", "development.rb"))
            load(instance_klass::Engine.root.join("db", "seed", "development.rb"))
        end
    end
end
