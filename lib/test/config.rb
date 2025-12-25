=begin

Lesli

Copyright (c) 2025, Lesli Technologies, S. A.

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


# Configure Rails Environment
ENV["RAILS_ENV"] = "test"


# Workaround for color_pound_spec_reporter
MiniTest = Minitest unless defined?(MiniTest)


# Load test frameworks
require "minitest/reporters"
require "color_pound_spec_reporter"


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
SimpleCov.minimum_coverage 50


# Load dummy app for unit testing
# Run tests across all the engines: LESLI_INTEGRATION_TEST=true rails test
# Run tests for the current engine: rails test
unless ENV["LESLI_INTEGRATION_TEST"]
    require_relative "../../test/dummy/config/environment"
    ActiveRecord::Migrator.migrations_paths = [ File.expand_path("../test/dummy/db/migrate", __dir__) ]
    ActiveRecord::Migrator.migrations_paths << File.expand_path("../db/migrate", __dir__)
    require "rails/test_help"
end


# Load fixtures from the engine
if ActiveSupport::TestCase.respond_to?(:fixture_paths=)
    ActiveSupport::TestCase.fixture_paths = [ File.expand_path("fixtures", __dir__) ]
    ActionDispatch::IntegrationTest.fixture_paths = ActiveSupport::TestCase.fixture_paths
    ActiveSupport::TestCase.file_fixture_path = File.expand_path("fixtures", __dir__) + "/files"
    ActiveSupport::TestCase.fixtures :all
end


# Execute tests
Minitest::Reporters.use!([
    Minitest::Reporters::DefaultReporter.new(color: true),
    ColorPoundSpecReporter.new
])
