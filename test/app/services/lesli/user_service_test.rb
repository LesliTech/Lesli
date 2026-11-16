require "test_helper"

module Lesli
    class UserServiceTest < ActiveSupport::TestCase
        fixtures :lesli_users, :lesli_accounts
        set_fixture_class lesli_users: "Lesli::User", lesli_accounts: "Lesli::Account"

        setup do
            @user = lesli_users(:one)
            @service = UserService.new(@user)
        end

        test "listing and lookup stay within the current account" do
            assert_equal [@user.id], @service.index.pluck(:id)
            assert_not @service.find(lesli_users(:two).id).found?
            assert_equal @user, @service.find(@user.id).show
        end

        test "selectors return only IDs and names within the current account" do
            option = @service.list.sole
            assert_equal @user.id, option.fetch("id")
            assert_equal @user.full_name, option.fetch("name")
            assert_equal %w[id name], option.keys.sort
            assert_equal [@user.id], @service.list.map { |row| row["id"] }
        end

        test "selectors use email when the user has no name and ignore pagination" do
            @user.update_columns(first_name: nil, last_name: nil)
            service = UserService.new(@user, pagination: { page: 2, perPage: 1 })
            assert_equal [{ "id" => @user.id, "name" => @user.email }], service.list
        end

        test "update saves initials and preferences in the same write" do
            @service.find(@user.id)
            writes = []
            subscriber = ->(*args) do
                sql = args.last[:sql]
                writes << sql if sql.match?(/UPDATE ["`]?lesli_users/)
            end
            ActiveSupport::Notifications.subscribed(subscriber, "sql.active_record") do
                @service.update(first_name: "Ada", last_name: "Lovelace", time_zone: "Europe/Berlin")
            end
            assert @service.successful?, @service.errors_as_sentence
            assert_equal 1, writes.length
            assert_equal "AL", @user.reload.alias
            assert_equal "Europe/Berlin", @user.time_zone
        end

        test "invalid updates retain input and do not persist the alias" do
            @service.find(@user.id).update(email: "invalid", first_name: "Ada")
            assert_not @service.successful?
            assert_equal "invalid", @service.result.email
            assert @service.result.errors[:email].present?
            assert_nil @user.reload.alias
        end

        test "blank time zone clears the preference without mutating input" do
            attributes = { "time_zone" => "" }
            @service.find(@user.id).update(attributes)
            assert @service.successful?
            assert_nil @user.reload.time_zone
            assert_equal "", attributes["time_zone"]
        end

        test "role filtering and display work without duplicate users" do
            skip "Shield is not installed" unless defined?(LesliShield)
            roles = %w[reviewer approver].map do |name|
                @user.account.roles.create!(name: name, permission_level: 10, active: true)
            end
            roles.each { |role| @user.user_roles.create!(role: role) }

            assert_equal [@user.id], @service.list(role: "reviewer,approver").map { |row| row["id"] }
            assert_empty @service.list(role: "reviewer' OR 1=1 --")
            row = @service.index.sole
            assert_includes row[:rolenames], "reviewer"
            assert_includes row[:rolenames], "approver"
        end

        test "role filtering returns no users when Shield is absent" do
            skip "Shield installed" if defined?(LesliShield)
            assert_empty @service.list(role: "owner")
        end
    end
end
