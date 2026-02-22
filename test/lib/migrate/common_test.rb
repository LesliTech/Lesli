require Lesli::Engine.root.join("lib/test/lesli")

module Lesli
    class MigrationHelpersCommonTest < ActiveSupport::TestCase
        class MockController
            include MigrationHelpers::Common

            attr_accessor :fake_locations

            def caller_locations(*)
                fake_locations || super
            end
        end

        def setup
            @helper = MockController.new
        end

        # Helper to build a Struct mimicking caller locations
        def build_loc(path)
            Struct.new(:absolute_path, :path).new(path, path)
        end


        # table_name_for_shared
        test "table_name_for_shared returns correct table names" do
            result = @helper.table_name_for_shared(:lesli_shield, :tokens)
            assert_equal [:lesli_shield_tokens, :lesli_shield_accounts], result
        end

        # table_name_for_item
        test "table_name_for_gem_item returns correct table name and foreign key" do
            # Simulate the engine path by mocking caller_locations
            @helper.fake_locations = [build_loc("/home/app/gems/lesli_shield/app/models/foo.rb")]

            result = @helper.table_name_for_item(:users, :profile)

            assert_equal [:user_profile, "user"], result
        end

        # table_name_for_item
        test "table_name_for_local_item returns correct table name and foreign key" do
            # Simulate the engine path by mocking caller_locations
            @helper.fake_locations = [build_loc("/home/app/engines/LesliShield/app/models/foo.rb")]

            result = @helper.table_name_for_item(:users, :profile)

            assert_equal [:user_profile, "user"], result
        end

        # table_name_for_item
        test "table_name_for_item returns correct table name and foreign key" do
            # Simulate the engine path by mocking caller_locations
            @helper.fake_locations = [build_loc("/home/app/engines/lesli_shield/app/models/foo.rb")]

            result = @helper.table_name_for_item(:users, :profile)

            assert_equal [:user_profile, "user"], result
        end

        test "table_name_for_item generate table name for activities" do
            @helper.fake_locations = [build_loc("/home/app/engines/lesli_payments/lib/whatever.rb")]

            result = @helper.table_name_for_item(:lesli_support_tickets, :actions)

            assert_equal [:lesli_support_ticket_actions, "lesli_support_ticket"], result
        end


        # infer_engine_from_namespace
        test "infer_engine_from_namespace detects engine from gems path" do
            @helper.fake_locations = [build_loc("/rvm/gems/ruby-3.2.5/gems/lesli_admin-0.2.0/lib/x.rb")]

            assert_equal "lesli_admin", @helper.send(:infer_engine_from_namespace)
        end

        test "infer_engine_from_namespace detects engine from engines path during development" do
            @helper.fake_locations = [build_loc("/home/app/engines/lesli_storage/app/models/x.rb")]

            assert_equal "lesli_storage", @helper.send(:infer_engine_from_namespace)
        end

        test "infer_engine_from_namespace returns nil if nothing matches" do
            @helper.fake_locations = [build_loc("/unrelated/path/to/some/file.rb")]

            assert_nil @helper.send(:infer_engine_from_namespace)
        end
    end
end
