require Lesli::Engine.root.join("lib/test/lesli")

class UserExtensionsTest < LesliModelTester
    # --- Test doubles ---------------------------------------------------------

    Setting = Struct.new(:name, :value)

    class CapturingSettings
        attr_reader :created_with, :find_or_create_by_calls

        def initialize(existing: nil)
            @existing = existing # Setting or nil
            @created_with = []
            @find_or_create_by_calls = []
        end

        def find_by(name:)
            return @existing if @existing&.name == name
            nil
        end

        def create_with(attrs)
            @created_with << attrs
            @pending_attrs = attrs
            self
        end

        def find_or_create_by(name:)
            @find_or_create_by_calls << { name: name, attrs: @pending_attrs }
            # simulate record created; store it so next find_by returns it
            @existing = Setting.new(name, @pending_attrs[:value].to_s)
            @existing
        end
    end

    class CapturingRoles
        def initialize(names)
            @names = names
        end

        def pluck(field)
            raise ArgumentError, "expected :name" unless field == :name
            @names
        end
    end

    class CapturingLogs
        attr_reader :created

        def initialize
            @created = []
        end

        def create!(payload)
            @created << payload
            true
        end
    end

    class FakeAccountAudit
        def audit = :audit_assoc
    end

    class FakeUser
        include Lesli::UserExtensions

        attr_accessor :first_name, :last_name, :email, :settings, :roles, :logs, :account

        def initialize(first_name: nil, last_name: nil, email: nil, settings: nil, roles: nil, logs: nil, account: nil)
            @first_name = first_name
            @last_name  = last_name
            @email      = email
            @settings   = settings || CapturingSettings.new
            @roles      = roles || CapturingRoles.new([])
            @logs       = logs || CapturingLogs.new
            @account    = account
        end

    # ActiveSupport's `present?` / `blank?` helpers are available in Rails tests.
    end

    # --- Tests: name / full_name / initials -----------------------------------

    test "name returns first_name when present" do
        u = FakeUser.new(first_name: "Luis", email: "luis@example.com")
        assert_equal "Luis", u.name
    end

    test "name falls back to email when first_name is blank" do
        u = FakeUser.new(first_name: nil, email: "luis@example.com")
        assert_equal "luis@example.com", u.name
    end

    test "full_name returns first + last when first_name present" do
        u = FakeUser.new(first_name: "Luis", last_name: "Donis", email: "luis@example.com")
        assert_equal "Luis Donis", u.full_name
    end

    test "full_name returns first name only when last_name missing" do
        u = FakeUser.new(first_name: "Luis", last_name: nil, email: "luis@example.com")
        assert_equal "Luis", u.full_name
    end

    test "full_name falls back to email when first_name is blank" do
        u = FakeUser.new(first_name: "", last_name: "Donis", email: "luis@example.com")
        assert_equal "luis@example.com", u.full_name
    end

    test "full_name_initials returns empty string when first_name blank" do
        u = FakeUser.new(first_name: nil, last_name: "Donis", email: "luis@example.com")
        assert_equal "", u.full_name_initials
    end

    test "full_name_initials returns first initial when only first_name present" do
        u = FakeUser.new(first_name: "luis", last_name: nil, email: "luis@example.com")
        assert_equal "L", u.full_name_initials
    end

    test "full_name_initials returns first and last initials when both present" do
        u = FakeUser.new(first_name: " luis ", last_name: " donis ", email: "luis@example.com")
        assert_equal "LD", u.full_name_initials
    end

    # --- Tests: locale ---------------------------------------------------------

    test "locale returns existing setting as symbol when present" do
        settings = CapturingSettings.new(existing: Setting.new("locale", "es"))
        u = FakeUser.new(settings: settings)

        assert_equal :es, u.locale
        assert_empty settings.created_with
        assert_empty settings.find_or_create_by_calls
    end

    test "locale creates setting when missing and returns it" do
        I18n.with_locale(:en) do
            settings = CapturingSettings.new(existing: nil)
            u = FakeUser.new(settings: settings)

            assert_equal :en, u.locale

            assert_equal [{ value: :en }], settings.created_with
            assert_equal [{ name: "locale", attrs: { value: :en } }], settings.find_or_create_by_calls
        end
    end

    # --- Tests: role_names -----------------------------------------------------

    test "role_names joins role names with comma" do
        u = FakeUser.new(roles: CapturingRoles.new(%w[owner admin guest]))
        assert_equal "owner, admin, guest", u.role_names
    end

    test "role_names returns empty string when no roles" do
        u = FakeUser.new(roles: CapturingRoles.new([]))
        assert_equal "", u.role_names
    end

    # --- Tests: log ------------------------------------------------------------

    test "log does nothing when LesliAudit is not defined" do
        Object.send(:remove_const, :LesliAudit) if Object.const_defined?(:LesliAudit)

        logs = CapturingLogs.new
        u = FakeUser.new(
            logs: logs,
            account: FakeAccountAudit.new
        )

        assert_nothing_raised do
            u.log(engine: "X", source: "Y", action: "Z", operation: "op", description: "desc", session_id: 123, subject: nil)
        end

        assert_empty logs.created
    end

    test "log writes to user logs when LesliAudit is defined and includes subject/account info" do
        # Define LesliAudit constant to enable logging
        Object.const_set(:LesliAudit, Module.new) unless Object.const_defined?(:LesliAudit)

        logs = CapturingLogs.new
        subject = Struct.new(:id).new(99)
        def subject.class = Struct.new(:name).new("Some::Thing") 

        u = FakeUser.new(
            logs: logs,
            account: FakeAccountAudit.new
        )

        u.log(
            engine: "MyEngine",
            source: "UsersController",
            action: "create",
            operation: "user create",
            description: "Created user",
            session_id: 777,
            subject: subject
        )

        assert_equal 1, logs.created.length
        payload = logs.created.first

        assert_equal "MyEngine", payload[:engine]
        assert_equal "UsersController", payload[:source]
        assert_equal "create", payload[:action]
        assert_equal "user create", payload[:operation]
        assert_equal "Created user", payload[:description]
        assert_equal 777, payload[:session_id]

        assert_equal "Some::Thing", payload[:subject_type]
        assert_equal 99, payload[:subject_id]

        assert_equal :audit_assoc, payload[:account]
    ensure
        Object.send(:remove_const, :LesliAudit) if Object.const_defined?(:LesliAudit)
    end
end
