# test/models/lesli_user_test.rb
require "test_helper"

module Lesli
    class UserTest < LesliTesting::ModelTester
        fixtures :lesli_users, :lesli_accounts

        set_fixture_class lesli_users: "Lesli::User",
                        lesli_accounts: "Lesli::Account" 
        
        test "fixture is valid" do
            assert lesli_users(:one).valid?
        end

        test "legal acceptance fields are optional and have no database defaults" do
            %w[terms_accepted_at terms_version privacy_version].each do |name|
                column = Lesli::User.columns_hash.fetch(name)
                assert column.null
                assert_nil column.default
                assert_nil Lesli::User.new.public_send(name)
            end
        end

        test "time zone is optional and has no database default" do
            column = Lesli::User.columns_hash.fetch("time_zone")
            assert column.null
            assert_nil column.default
            assert_nil Lesli::User.new.time_zone
            user = lesli_users(:one)
            user.update!(time_zone: nil)
            assert_nil user.reload.time_zone
        end

        test "accepts IANA time zones and rejects unknown zones and Rails display names" do
            user = lesli_users(:one)
            ["America/Guatemala", "Europe/Berlin", "UTC"].each do |zone|
                user.update!(time_zone: zone)
                assert_equal zone, user.reload.time_zone
            end
            ["Invalid/Timezone", "", "+02:00", "Eastern Time (US & Canada)"].each do |zone|
                user.time_zone = zone
                assert_not user.valid?
                assert user.errors.added?(:time_zone, :inclusion, value: zone)
            end
        end

        test "effective time zone uses the profile then global configuration then Rails configuration" do
            previous_datetime = Lesli.config.datetime
            previous_rails_zone = Rails.application.config.time_zone
            Lesli.config.datetime = { time_zone: "America/Guatemala" }
            Rails.application.config.time_zone = "UTC"
            user = lesli_users(:one)
            user.time_zone = "Europe/Berlin"
            assert_equal "Europe/Berlin", user.effective_time_zone.name

            user.time_zone = nil
            assert_equal "America/Guatemala", user.effective_time_zone.name
            Lesli.config.datetime = nil
            Time.use_zone("Asia/Tokyo") do
                assert_equal "UTC", user.effective_time_zone.name
            end
            assert_nil user.time_zone
            assert_equal :utc, ActiveRecord.default_timezone
        ensure
            Lesli.config.datetime = previous_datetime
            Rails.application.config.time_zone = previous_rails_zone
        end

        test "declares the security associations used by the platform" do
            sessions = Lesli::User.reflect_on_association(:sessions)
            user_roles = Lesli::User.reflect_on_association(:user_roles)
            roles = Lesli::User.reflect_on_association(:roles)
            privileges = Lesli::User.reflect_on_association(:privileges)

            assert_equal "LesliShield::User::Session", sessions.class_name
            assert_equal "LesliShield::User::Role", user_roles.class_name
            assert_equal :user_roles, roles.options[:through]
            assert_equal :role, roles.options[:source]
            assert_equal :roles, privileges.options[:through]
        end

        test "declares the audit associations used by the platform" do
            requests = Lesli::User.reflect_on_association(:requests)
            journals = Lesli::User.reflect_on_association(:journals)
            logs = Lesli::User.reflect_on_association(:logs)
            account_logs = Lesli::User.reflect_on_association(:account_logs)

            assert_equal "LesliAudit::UserRequest", requests.class_name
            assert_equal "LesliAudit::UserJournal", journals.class_name
            assert_equal "LesliAudit::UserLog", logs.class_name
            assert_equal "LesliAudit::AccountLog", account_logs.class_name

            [requests, journals, logs, account_logs].each do |association|
                assert_equal :user_id, association.options[:foreign_key]
                assert_equal :user, association.options[:inverse_of]
            end
        end

        test "requires uid" do
            user = lesli_users(:one).dup
            user.uid = nil
            assert_not user.valid?
        end

        test "requires email" do
            user = lesli_users(:one).dup
            user.email = ""
            assert_not user.valid?
            assert_includes user.errors[:email], "can't be blank"
        end

        test "uid is unique" do
            user = lesli_users(:one).dup
            user.email = "unique@example.com" # avoid email unique collision
            assert_raises ActiveRecord::RecordNotUnique do
                user.save!(validate: false) # hit DB unique index directly
            end
        end

        test "email is unique" do
            user = lesli_users(:one).dup
            user.uid = "USR-UNIQUE"
            assert_raises ActiveRecord::RecordNotUnique do
                user.save!(validate: false)
            end
        end

        test "active defaults to true for new records" do
            user = Lesli::User.new(
                uid: "USR-NEW",
                email: "new@example.com",
                encrypted_password: "x",
                account: lesli_accounts(:one)
            )
            assert_equal true, user.active
        end

        test "save does not hide database uniqueness violations" do
            existing = lesli_users(:one)

            dup = Lesli::User.new(
                uid: existing.uid,                 # violates unique index
                email: "another@example.com",      # avoid email conflict so uid is the one failing
                encrypted_password: "x",
                account_id: existing.account_id
            )

            assert_raises ActiveRecord::RecordNotUnique do
                dup.save(validate: false)
            end
        end

        test "generates uid before creating a user when uid is nil" do
            account = lesli_accounts(:one)

            user = Lesli::User.new(
                uid: nil,
                email: "new-user@example.com",
                encrypted_password: "provided-by-authentication-engine",
                account: account
            )

            assert_nil user.uid
            assert user.save(validate: false), "Expected user to save"
            assert user.uid.present?, "Expected uid to be generated"
        end

        test "generates uid against the global unique index without an account" do
            existing_uid = lesli_users(:one).uid
            generated_uids = [existing_uid, "LID-UNIQUE"]
            user = Lesli::User.new

            user.define_singleton_method(:generate_resource_uid) do |**|
                generated_uids.shift
            end

            user.send(:before_create_user)

            assert_equal "LID-UNIQUE", user.uid
        end
    end
end
