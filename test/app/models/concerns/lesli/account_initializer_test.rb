require "test_helper"

class AccountInitializerTest < LesliTesting::ModelTester
    # --- Test doubles ---

    class CapturingRoles
        Role = Struct.new(:name, :attrs)

        attr_reader :create_with_calls, :find_or_create_by_calls, :roles

        def initialize
            @create_with_calls = []
            @find_or_create_by_calls = []
            @roles = {} # name => Role
            @next_attrs = {}
        end

        def create_with(attrs)
            @create_with_calls << attrs
            @next_attrs = attrs
            self
        end

        def find_or_create_by(name:)
            @find_or_create_by_calls << { name: name, attrs: @next_attrs }
            @roles[name] ||= Role.new(name, @next_attrs.dup)
        end
    end

    class FakeAccount
        include Lesli::AccountInitializer

        attr_reader :roles, :log_calls

        def initialize
            @roles = CapturingRoles.new
            @log_calls = []
        end

        def log(operation, description = nil, user: nil)
            @log_calls << { operation: operation, description: description, user: user }
        end
    end

        # Fake Engine Account model that captures find_or_create_by!
    class CapturingEngineAccount
        @calls = []
        class << self
            attr_reader :calls
            def reset! = @calls.clear
            def find_or_create_by!(account:)
                @calls << account
                true
            end
        end
    end

    setup do
        # Build fake engine constants with ::Account
        # Example engines: "LesliSupport" and "LesliSales"
        stub_engine("LesliSupport")
        stub_engine("LesliSales")

        # Stub LesliSystem.engines
        stub_const(:LesliSystem, Module.new) unless Object.const_defined?(:LesliSystem)
        LesliSystem.define_singleton_method(:engines) do
            {
                "Lesli" => {},
                "Root" => {},
                "LesliBabel" => {},
                "LesliSupport" => {},
                "LesliSales" => {}
            }
        end
    end

    teardown do
        # cleanup fake engines
        remove_engine("LesliSupport")
        remove_engine("LesliSales")

        Object.send(:remove_const, :LesliSystem) if Object.const_defined?(:LesliSystem)
        Object.send(:remove_const, :LesliShield) if Object.const_defined?(:LesliShield)
    end

    # --- Helpers to create/remove engine constants ---
    def stub_engine(name)
        mod = Module.new
        mod.const_set(:Account, CapturingEngineAccount)
        Object.const_set(name.to_sym, mod)
    end

    def remove_engine(name)
        Object.send(:remove_const, name.to_sym) if Object.const_defined?(name.to_sym)
        CapturingEngineAccount.reset!
    end

    # --- Tests for initialize_account ---

    #   test "initialize_account creates owner/admin/guest roles with expected defaults" do
    #     account = FakeAccount.new
    #     account.initialize_account

    #     calls = account.roles.find_or_create_by_calls

    #     assert_equal 3, calls.length

    #     owner_call = calls.find { |c| c[:name] == "owner" }
    #     admin_call = calls.find { |c| c[:name] == "admin" }
    #     guest_call = calls.find { |c| c[:name] == "guest" }

    #     assert owner_call, "Expected owner role to be created"
    #     assert admin_call, "Expected admin role to be created"
    #     assert guest_call, "Expected guest role to be created"

    #     assert_equal 2147483647, owner_call[:attrs][:permission_level]
    #     assert_equal 100000,     admin_call[:attrs][:permission_level]
    #     assert_equal 10,         guest_call[:attrs][:permission_level]
    #     assert_equal "/administration/profile", guest_call[:attrs][:path_default]
    #   end

    #   test "initialize_account calls LesliShield role action service when LesliShield is defined" do
    #     # Stub LesliShield::RoleActionService
    #     shield = Module.new
    #     shield.const_set(:RoleActionService, Class.new do
    #       def initialize(_); end

    #       def add_owner_actions(role) = (self.class.calls << [:owner, role.name])
    #       def add_guest_actions(role) = (self.class.calls << [:guest, role.name])

    #       def self.calls = (@calls ||= [])
    #       def self.reset! = calls.clear
    #     end)
    #     Object.const_set(:LesliShield, shield)
    #     LesliShield::RoleActionService.reset!

    #     account = FakeAccount.new
    #     account.initialize_account

    #     # Our CapturingRoles returns Role structs with name set.
    #     # Expect owner/admin owner-actions; guest guest-actions.
    #     assert_equal(
    #       [[:owner, "owner"], [:owner, "admin"], [:guest, "guest"]],
    #       LesliShield::RoleActionService.calls
    #     )
    #   end

    # --- Tests for initialize_engines ---

    test "initialize_engines creates Engine::Account for each non-skipped engine and logs initialization" do
        account = FakeAccount.new

        account.initialize_engines

        # CapturingEngineAccount stores accounts passed into find_or_create_by!
        assert_equal 2, CapturingEngineAccount.calls.length
        assert CapturingEngineAccount.calls.all? { |a| a.equal?(account) }

        # Logs for each initialized engine
        log_descriptions = account.log_calls.map { |c| c[:description] }

        assert_includes log_descriptions, "Engine: LesliSupport initialized successfully"
        assert_includes log_descriptions, "Engine: LesliSales initialized successfully"

        # Ensure skipped engines are not logged
        refute log_descriptions.any? { |d| d.include?("Engine: Lesli initialized") }
        refute log_descriptions.any? { |d| d.include?("Engine: Root initialized") }
        refute log_descriptions.any? { |d| d.include?("Engine: LesliBabel initialized") }
    end
end
