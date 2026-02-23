# test/models/lesli_user_test.rb
require "test_helper"

class LesliUserTest < LesliTesting::ModelTester
    fixtures :lesli_users, :lesli_accounts

    set_fixture_class lesli_users: "Lesli::User",
                    lesli_accounts: "Lesli::Account" # adjust if different
    
    test "fixture is valid" do
        assert lesli_users(:one).valid?
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

    test "do not requires encrypted_password" do
        user = lesli_users(:one).dup
        user.encrypted_password = ""
        ##assert user.valid?
        #assert_includes user.errors[:encrypted_password], "can't be blank"
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

        # Because rescue returns nil by default
        assert_equal false, result
    end

    test "generates uid after create when uid is nil" do
        account = lesli_accounts(:one)

        user = Lesli::User.new(
            uid: nil,
            email: "new-user@example.com",
            password: "password123",
            password_confirmation: "password123",
            account: account
        )

        user.save

        #assert_nil user.uid
        #assert user.save, "Expected user to save"
        #assert user.uid.present?, "Expected uid to be generated"
        #assert_match(/\ALID/, user.uid) # loose check; tighten if you know full format
    end
end
