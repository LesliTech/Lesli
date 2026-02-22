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


# Usage:
#   COVERAGE=true rails test
if ENV["COVERAGE"]

    # Load code coverage tools
    require "simplecov"
    require "simplecov-console"
    require "simplecov-cobertura"

    # Add console stats and html generator
    SimpleCov.formatter = SimpleCov::Formatter::MultiFormatter.new([
        SimpleCov::Formatter::CoberturaFormatter,
        SimpleCov::Formatter::Console
    ])


    # limit the number of missing lines
    SimpleCov::Formatter::Console.missing_len = 10


    # configure the files to track and ignore
    SimpleCov.start do 

        # remove to track files in these folders
        add_filter "/app/assets"
        add_filter "/app/controllers/items"
        add_filter "/app/controllers/shared"
        add_filter "/app/jobs"
        add_filter "/app/lib"
        add_filter "/app/mailers"
        add_filter "/app/services"
        add_filter "/app/views"
        add_filter "/config"
        add_filter "/db"
        add_filter "/lib/generators"
        add_filter "/lib/scss"
        add_filter "/lib/task"
        add_filter "/lib/test"

        add_filter "/docs"
        add_filter "/test"
        add_filter "/spec"
        add_filter "/vendor"

        add_group "Controllers", "app/controllers"
        add_group "Helpers", "app/helpers"
        add_group "Models", "app/models"
        add_group "Jobs", "app/jobs"
        add_group "Services", "app/services"
        add_group "Operators", "app/operators"
        add_group "Validators", "app/validators"
    end


    # Minimum expected coverage percentage
    SimpleCov.minimum_coverage 40
end
