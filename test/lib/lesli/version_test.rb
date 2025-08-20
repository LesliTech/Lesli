require Lesli::Engine.root.join("lib/test/lesli")

module Lesli
    class VersionTest < ActiveSupport::TestCase
        test "it has a version number" do
            assert(Lesli::VERSION)
        end
    end
end
