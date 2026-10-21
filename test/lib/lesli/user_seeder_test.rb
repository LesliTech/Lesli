require "test_helper"

load Lesli::Engine.root.join("db", "seed", "xyz.rb")

module Lesli
    class UserSeederTest < ActiveSupport::TestCase
        test "creates users without an authentication engine" do
            with_seed_account do |account|
                email = "core-seed-#{SecureRandom.hex(4)}@example.com"

                assert_difference -> { Lesli::User.count }, 1 do
                    create_account_user(
                        email,
                        "owner",
                        "Core",
                        "User",
                        "NotUsed123!"
                    )
                end

                user = Lesli::User.find_by!(email: email)

                assert_equal account, user.account
                assert_equal "Core", user.first_name
                assert_equal "User", user.last_name
                assert_equal "", user.encrypted_password
                refute user.respond_to?(:password=)
            end
        end

        test "does not duplicate an existing core user" do
            with_seed_account do
                email = "existing-core-seed-#{SecureRandom.hex(4)}@example.com"

                create_account_user(
                    email,
                    "owner",
                    "Core",
                    "User",
                    "NotUsed123!"
                )

                assert_no_difference -> { Lesli::User.count } do
                    create_account_user(
                        email,
                        "owner",
                        "Updated",
                        "User",
                        "StillNotUsed123!"
                    )
                end

                assert_equal "Updated", Lesli::User.find_by!(email: email).first_name
            end
        end

        private

        def with_seed_account
            original_email = Lesli.config.company[:email]
            email = "core-seed-account-#{SecureRandom.hex(4)}@example.com"
            Lesli.config.company[:email] = email
            timestamp = Time.current

            Lesli::Account.insert_all!([{
                email: email,
                name: "Core seed account",
                status: "active",
                created_at: timestamp,
                updated_at: timestamp
            }])

            yield Lesli::Account.find_by!(email: email)
        ensure
            Lesli.config.company[:email] = original_email
        end
    end
end
