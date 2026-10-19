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

        test "save rescues RecordNotUnique and does not raise" do
            existing = lesli_users(:one)

            dup = Lesli::User.new(
                uid: existing.uid,                 # violates unique index
                email: "another@example.com",      # avoid email conflict so uid is the one failing
                encrypted_password: "x",
                account_id: existing.account_id
            )

            # It should not raise:
            result = nil
            assert_nothing_raised do
                result = dup.save
            end

            # The rescue branch returns nil instead of propagating the error.
            assert_nil result
        end

        test "generates uid after create when uid is nil" do
            account = lesli_accounts(:one)

            user = Lesli::User.new(
                uid: nil,
                email: "new-user@example.com",
                encrypted_password: "provided-by-authentication-engine",
                account: account
            )

            assert_nil user.uid
            assert user.save, "Expected user to save"
            assert user.uid.present?, "Expected uid to be generated"
        end
    end
end
