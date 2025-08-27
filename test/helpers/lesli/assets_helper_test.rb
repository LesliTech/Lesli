# test/helpers/lesli/assets_helper_test.rb
require Lesli::Engine.root.join("lib/test/lesli")

module Lesli
    class AssetsHelperTest < LesliViewTester

        test "returns application stylesheet by default" do
            def lesli_engine(key)
                "root"
            end
            assert_equal("application", lesli_asset_path())
        end

        test "returns application stylesheet by default for engine" do
            def lesli_engine(key)
                "lesli"
            end
            assert_equal("lesli/custom", lesli_asset_path(nil, "custom"))
        end

        test "returns engine/stylesheet when engine is provided" do
            assert_equal("lesli/application", lesli_asset_path(:lesli))
        end

        test "returns engine/application when engine and stylesheet are provided" do
            assert_equal("lesli/application", lesli_asset_path(:lesli, "application"))
        end

        test "returns gem/application when gem and stylesheet are provided" do
            assert_equal("lesli_assets/application", lesli_asset_path(:lesli_assets, "application"))
        end

        test "returns gem/custom when gem and stylesheet are provided" do
            assert_equal("lesli_assets/custom", lesli_asset_path(:lesli_assets, "custom"))
        end

        test "returns favicon reference" do
            tag = '<link href="http://test.host/images/lesli/brand/favicon.svg" rel="alternate icon"><link href="http://test.host/images/lesli/brand/favicon.svg" rel="icon" type="image/svg+xml"><link href="http://test.host/images/lesli/brand/favicon.svg" rel="mask-icon" color="#ff8a01">'
            assert_equal(tag, lesli_favicon())
        end
    end
end
