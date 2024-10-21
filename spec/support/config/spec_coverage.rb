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

Lesli · Ruby on Rails Development Platform.

Made with ♥ by https://www.lesli.tech
Building a better future, one line of code at a time.

@contact  hello@lesli.tech
@website  https://www.lesli.tech
@license  GPLv3 http://www.gnu.org/licenses/gpl-3.0.en.html

// · ~·~     ~·~     ~·~     ~·~     ~·~     ~·~     ~·~     ~·~     ~·~
// ·     
=end


# Test coverage
require "simplecov"
require "simplecov-console"
require "simplecov-cobertura"
require "codecov"


# COVERAGE=true rspec spec
# run test coverage on demand only
if ENV["COVERAGE"] || ENV["CODECOV"]

    # customer report formatters containers
    FORMATTERS = []

    # add formatters for codecov through github actions
    FORMATTERS.push(SimpleCov::Formatter::Codecov) if ENV["CODECOV"]
    FORMATTERS.push(SimpleCov::Formatter::CoberturaFormatter) if ENV["CODECOV"]

    # add formatters for local visualization
    FORMATTERS.push(SimpleCov::Formatter::Console) if ENV["COVERAGE"]
    FORMATTERS.push(SimpleCov::Formatter::HTMLFormatter) if ENV["COVERAGE"]

    # add console stats and html generator
    SimpleCov.formatter = SimpleCov::Formatter::MultiFormatter.new(FORMATTERS)

    # limit the number of missing lines
    SimpleCov::Formatter::Console.missing_len = 50 

    # configure the files to track and ignore
    SimpleCov.start do 
        #track_files 'lib/**/*.rb'
        
        # remove to track files in these folders
        add_filter "/spec"
        add_filter "/vendor"

        # temporary exceptions
        add_filter "/engines/Lesli/app/lib"
        add_filter "/engines/Lesli/app/models"
        add_filter "/engines/Lesli/app/helpers"
        add_filter "/engines/Lesli/app/mailers"
        add_filter "/engines/Lesli/app/services"
        add_filter "/engines/Lesli/app/operators"
        add_filter "/engines/Lesli/app/validators"
        add_filter "/engines/Lesli/app/controllers/lesli/interfaces"
        add_filter "/engines/Lesli/app/controllers/lesli/application_controller.rb"
        add_filter "/engines/Lesli/app/controllers/lesli/application_lesli_controller.rb"

        add_filter "/engines/LesliShield"
        add_filter "/engines/LesliSupport"
        add_filter "/engines/LesliDashboard"
        add_filter "/engines/LesliAudit"
    end

    # execute test coverage after test suites
    RSpec.configure do |config|
        config.after(:suite) do
        end
    end
end
