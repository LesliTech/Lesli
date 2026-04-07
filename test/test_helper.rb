# Configure Rails Environment
ENV["RAILS_ENV"] = "test"


# load lesli testing tools
require "lesli_testing/loader"


# register engine for testing
LesliTesting.configure(Lesli::Engine)


# initialize coverage
LesliTesting.configure_coverage({ :min_coverage => 10 })


# Loading dummy app
require_relative "../test/dummy/config/environment"
ActiveRecord::Migrator.migrations_paths = [ File.expand_path("../test/dummy/db/migrate", __dir__) ]
ActiveRecord::Migrator.migrations_paths << File.expand_path("../db/migrate", __dir__)
require "rails/test_help"


# configure tests
LesliTesting.configure_engine()
