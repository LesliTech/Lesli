# Configure Rails Environment
ENV["RAILS_ENV"] = "test"

require "lesli_system"

# Lesli helpers
require "lesli_testing/loader"


# Start Lesli testing coverage
LesliTesting.configure(Lesli::Engine, { :min_coverage => 10 })


# Loading dummy app
require_relative "../test/dummy/config/environment"
ActiveRecord::Migrator.migrations_paths = [ File.expand_path("../test/dummy/db/migrate", __dir__) ]
ActiveRecord::Migrator.migrations_paths << File.expand_path("../db/migrate", __dir__)
require "rails/test_help"


# Load fixtures from the engine
if ActiveSupport::TestCase.respond_to?(:fixture_paths=)
    ActiveSupport::TestCase.fixture_paths = [ File.expand_path("fixtures", __dir__) ]
    ActionDispatch::IntegrationTest.fixture_paths = ActiveSupport::TestCase.fixture_paths
    ActiveSupport::TestCase.file_fixture_path = File.expand_path("fixtures", __dir__) + "/files"
    ActiveSupport::TestCase.fixtures :all
end


# Load Lesli testing defaults
LesliTesting.configure_tests()
