# Configure Rails Environment
ENV["RAILS_ENV"] = "test"


# load lesli testing tools
require "lesli_testing"


# register engine for testing
LesliTesting.engine("Lesli", {
    :coverage_min_coverage => 10,
    :coverage_profile => "engine"
})


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
