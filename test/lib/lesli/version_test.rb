require Lesli::Engine.root.join("lib/test/lesli")

module Lesli
    class VersionTest < ActiveSupport::TestCase
        test "it has a version number" do
            assert(Lesli::VERSION)
        end
        test "it has a build number" do
            assert(Lesli::BUILD)
        end
    end
end
