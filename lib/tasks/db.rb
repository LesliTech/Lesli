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
@website  https://www.lesli.dev
@license  GPLv3 http://www.gnu.org/licenses/gpl-3.0.en.html

// · ~·~     ~·~     ~·~     ~·~     ~·~     ~·~     ~·~     ~·~     ~·~
// · 
=end

# Build, migrate & seed database (development only)
def setup

    L2.br(2)
    L2.info("Setup Lesli database for development")

    Rake::Task['db:create'].invoke
    Rake::Task['db:migrate'].invoke
    Rake::Task['db:seed'].invoke
    seed()
    
end


# Drop, build, migrate & seed database (development only)
def reset

    return if Rails.env.production?

    L2.br(2)
    L2.info("Reset Lesli database for development")

    Rake::Task['db:drop'].invoke
    Rake::Task['db:create'].invoke
    Rake::Task['db:migrate'].invoke
    Rake::Task['db:seed'].invoke
    Rake::Task['lesli:controllers:build'].invoke
    seed()

end


# Drop, build, migrate & seed database (development only)
def seed

    return if Rails.env.production?

    L2.br(2)
    L2.info("Seed Lesli database for #{ Rails.env.downcase } environment")

    Lesli::Engine.load_seed
    LesliBell::Engine.load_seed if defined?(LesliBell)
    LesliAudit::Engine.load_seed if defined?(LesliAudit)
    Rake::Task['lesli:babel:build'].invoke if defined?(LesliBabel)

end
