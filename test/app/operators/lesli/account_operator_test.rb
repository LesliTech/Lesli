require "test_helper"

module Lesli
    class AccountOperatorTest < ActiveSupport::TestCase
        test "new accounts are provisioned automatically and can be configured repeatedly" do
            account = Account.create!(name: "Operator account", email: "operator@example.com", status: "active", region: "america")
            assert_equal %w[admin guest owner], account.roles.order(:name).pluck(:name)
            original_ids = account.roles.order(:id).pluck(:id)
            account.roles.find_by!(name: "guest").update!(path_default: "/custom")
            operator = AccountOperator.new(account: account)

            assert_equal account, operator.initialize_roles!
            assert_equal account, operator.initialize_engines!
            assert_equal original_ids, account.roles.order(:id).pluck(:id)
            assert_equal "/custom", account.roles.find_by!(name: "guest").path_default
        end

        test "failed role creation rolls back the complete initialization" do
            account = Account.create!(name: "Rollback account", email: "rollback@example.com", status: "active", region: "america")
            account.roles.delete_all
            # Model validation failure after creating the first role.
            roles = account.roles
            roles.define_singleton_method(:create_with) do |attributes|
                raise ActiveRecord::RecordInvalid.new(Lesli::Role.new) if attributes[:permission_level] == 100000
                super(attributes)
            end

            assert_raises(ActiveRecord::RecordInvalid) do
                AccountOperator.new(account: account).initialize_roles!
            end
            assert_empty account.roles.reload
        end
    end
end
