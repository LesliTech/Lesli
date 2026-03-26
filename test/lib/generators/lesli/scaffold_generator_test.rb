require "test_helper"
require "generators/scaffold/scaffold_generator"

module Lesli
  class ScaffoldGeneratorTest < Rails::Generators::TestCase
    tests ScaffoldGenerator
    destination Rails.root.join("tmp/generators")
    setup :prepare_destination

    # test "generator runs without errors" do
    #   assert_nothing_raised do
    #     run_generator ["arguments"]
    #   end
    # end
  end
end
