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


# Configure Rails Environment
ENV["RAILS_ENV"] = "test"


# Workaround for color_pound_spec_reporter
MiniTest = Minitest unless defined?(MiniTest)


# Load test frameworks
require "minitest/reporters"
require "color_pound_spec_reporter"


# Load dummy app for unit testing
# This is necessary when testing individual engines
# This should not be loaded when testing from the main rails app
unless ENV["LESLI_INTEGRATION_TEST"]
    require_relative "../../test/xyz/config/environment"

    # IMPORTANT: set migration paths BEFORE test_help / schema maintenance
    ActiveRecord::Migrator.migrations_paths = [
        Lesli::Engine.root.join("test/xyz/db/migrate").to_s,
        Lesli::Engine.root.join("db/migrate").to_s
    ]

    require "rails/test_help"

    # Force Rails to re-check schema using your migration paths
    ActiveRecord::Migration.maintain_test_schema!
end



# Load fixtures from the engine
if ActiveSupport::TestCase.respond_to?(:fixture_paths=)
    ActiveSupport::TestCase.fixture_paths = [ Lesli::Engine.root.join("test", "fixtures").to_s ]
    ActionDispatch::IntegrationTest.fixture_paths = ActiveSupport::TestCase.fixture_paths
    ActiveSupport::TestCase.file_fixture_path = Lesli::Engine.root.join("test", "fixtures", "files").to_s

    # IMPORTANT: attach fixture sets to namespaced models BEFORE loading fixtures
    ActiveSupport::TestCase.set_fixture_class(
        lesli_users:    "Lesli::User",
        lesli_accounts: "Lesli::Account"
    )

    ActiveSupport::TestCase.fixtures :all
end


# Execute tests
Minitest::Reporters.use!([
    Minitest::Reporters::DefaultReporter.new(color: true),
    Minitest::Reporters::JUnitReporter.new("coverage/reports"),
    ColorPoundSpecReporter.new
])
