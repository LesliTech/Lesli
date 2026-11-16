require "test_helper"

module Lesli
    class RoleServiceTest < ActiveSupport::TestCase
        fixtures :lesli_accounts
        set_fixture_class lesli_accounts: "Lesli::Account"

        test "list respects account and permission level" do
            account = lesli_accounts(:one)
            low = account.roles.create!(name: "selector-low", permission_level: 10, active: true)
            high = account.roles.create!(name: "selector-high", permission_level: 100, active: true)
            foreign = lesli_accounts(:two).roles.create!(name: "selector-other", permission_level: 10, active: true)
            actor = Struct.new(:account, :max_level_permission).new(account, 10)
            service = RoleService.new(actor)

            assert_includes service.list.pluck(:id), low.id
            refute_includes service.list.pluck(:id), high.id
            refute_includes service.list.pluck(:id), foreign.id
            assert_equal %w[id name], service.list.first.attributes.keys.sort
            assert_not service.find(foreign.id).found?
        end
    end
end
