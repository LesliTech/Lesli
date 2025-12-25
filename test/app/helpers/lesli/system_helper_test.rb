# test/helpers/lesli/assets_helper_test.rb
require Lesli::Engine.root.join("lib/test/lesli")

module Lesli
    class SystemHelperTest < LesliViewTester

        # Stubbing the controller_path which Rails helpers expect to find in the view context
        attr_accessor :controller_path

        setup do
            # Default path for tests
            @controller_path = "onboardings/setup"
        end

        test "lesli_controller returns the first segment of the path" do
            @controller_path = "users/profile/edit"
            assert_equal "users", lesli_controller
        end

        test "lesli_instance_code returns lesli" do
            assert_equal "lesli", lesli_instance_code
        end

        test "is_lesli_onboarding? returns true when controller is onboardings" do
            @controller_path = "onboardings/welcome"
            assert is_lesli_onboarding?
        end

        test "is_lesli_onboarding? returns false for other controllers" do
            @controller_path = "dashboard/index"
            assert_not is_lesli_onboarding?
        end
    end
end
