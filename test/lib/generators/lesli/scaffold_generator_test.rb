require "test_helper"
require "generators/lesli/scaffold/scaffold_generator"

module Lesli
    module Generators
        class ScaffoldGeneratorTest < Rails::Generators::TestCase
            tests ScaffoldGenerator
            destination Rails.root.join("tmp/generators")
            setup :prepare_destination
        end
    end
end
