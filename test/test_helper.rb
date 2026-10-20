# Configure the Rails test environment before booting the dummy application.
ENV["RAILS_ENV"] ||= "test"


# Start coverage before loading Lesli or the dummy Rails application.
require "lesli_testing"


# Register the engine profile. LesliTesting resolves Lesli::Engine after Rails
# boots and configures its fixtures and migration paths through load hooks.
LesliTesting.engine("Lesli", coverage_min_coverage: 10)


# Boot the dummy application only after LesliTesting has selected its profile.
require_relative "dummy/config/environment"
require "rails/test_help"
