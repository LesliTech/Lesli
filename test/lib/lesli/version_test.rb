
require "test_helper"

module Lesli
    class VersionTest < ActiveSupport::TestCase
        test "it has a version number" do
            assert(Lesli::VERSION)
            assert_equal("Luis","Luiss")
        end
        test "it has a build number" do
            assert(Lesli::BUILD)
            assert_equal(1,2)
        end
    end
end
