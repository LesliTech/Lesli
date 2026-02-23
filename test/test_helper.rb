# my_engine/test/test_helper.rb
ENV["RAILS_ENV"] = "test"
require_relative "../test/dummy/config/environment"
require "rails/test_help"

require "lesli_testing"
LesliTesting.init(Lesli::Engine)

# Your tests in version_test.rb can now simply do:
# class VersionTest < LesliModelTester
