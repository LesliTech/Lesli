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

        test "language_url builds the correct path" do
            assert_equal "/lesli/language?locale=en", language_url(:en)
            assert_equal "/lesli/language?locale=es", language_url("es")
        end

        test "language_flag returns gb for english locale" do
            assert_equal "gb", language_flag(:en)
            assert_equal "gb", language_flag("en")
        end

        test "language_flag returns the same code for other locales" do
            assert_equal :es, language_flag(:es)
            assert_equal "fr", language_flag("fr")
        end

        test "language_name returns the correct language" do
            original = Lesli.config.locales
            Lesli.config.locales = { en: "English", es: "Español" }

            assert_equal "English", language_name(:en)
            assert_equal "Español", language_name(:es)
        ensure
            Lesli.config.locales = original
        end

        test "language_name returns undefined for missing locale" do
            original = Lesli.config.locales
            Lesli.config.locales = { en: "English" }

            assert_equal "undefined", language_name(:fr)
        ensure
            Lesli.config.locales = original
        end

        test "lesli_controller returns the first segment of the path" do
            @controller_path = "users/profile/edit"
            assert_equal "users", lesli_controller
        end

        test "lesli_controller works with single segment path" do
            @controller_path = "dashboard"
            assert_equal "dashboard", lesli_controller
        end

        test "lesli_instance_code returns lesli" do
            assert_equal "lesli", lesli_instance_code
        end

        test "lesli_engine delegates to LesliSystem.engine" do
            original = LesliSystem.method(:engine)

            LesliSystem.define_singleton_method(:engine) do |*args|
                "test_engine"
            end

            assert_equal "test_engine", lesli_engine
        ensure
            LesliSystem.define_singleton_method(:engine, original)
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
