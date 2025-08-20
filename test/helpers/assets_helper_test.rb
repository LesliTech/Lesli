# test/helpers/lesli/assets_helper_test.rb
require Lesli::Engine.root.join("lib/test/lesli")

class Lesli::AssetsHelperTest < LesliViewTester

    test "returns application stylesheet by default" do
        def lesli_engine(key)
            "root"
        end
        assert_equal("application", lesli_asset_path())
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
end
