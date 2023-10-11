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
if ENV["COVERAGE"]

    # add console stats and html generator
    SimpleCov.formatter = SimpleCov::Formatter::MultiFormatter.new([
        SimpleCov::Formatter::CoberturaFormatter,
        #SimpleCov::Formatter::HTMLFormatter,
        #SimpleCov::Formatter::Console,
    ])

    # limit the number of missing lines
    SimpleCov::Formatter::Console.missing_len = 50 

    # configure the files to track and ignore
    SimpleCov.start do 
        #track_files 'lib/**/*.rb'

        # remove to track files in these folders
        add_filter "/lib"
        add_filter "/spec"
        add_filter "/vendor"
        add_filter "/app/models"
        add_filter "/app/helpers"
        add_filter "/app/mailers"
        add_filter "/engines"
        add_filter "/config"
    end

    # execute test coverage after test suites
    RSpec.configure do |config|
        config.after(:suite) do
        end
    end

end

if ENV["CODECOV"]
    SimpleCov.formatter = SimpleCov::Formatter::MultiFormatter.new([
        SimpleCov::Formatter::CoberturaFormatter,
        SimpleCov::Formatter::Codecov
    ])
    SimpleCov.start
end
