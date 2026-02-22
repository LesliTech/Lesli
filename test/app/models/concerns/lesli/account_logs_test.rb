=begin

Lesli

Copyright (c) 2026, Lesli Technologies, S. A.

This program is free software: you can redistribute it and/or modify
it under the terms of the GNU General Public License as published by
the Free Software Foundation, either version 3 of the License, or
(at your option) any later version.

This program is distributed in the hope that it will be useful,
but WITHOUT ANY WARRANTY; without even the implied warranty of
MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the
GNU General Public License for more details.

You should have received a copy of the GNU General Public License
along with this program. If not, see http://www.gnu.org/licenses/.

Lesli · Ruby on Rails SaaS Development Framework.

Made with ♥ by LesliTech
Building a better future, one line of code at a time.

@contact  hello@lesli.tech
@website  https://www.lesli.tech
@license  GPLv3 http://www.gnu.org/licenses/gpl-3.0.en.html

// · ~·~     ~·~     ~·~     ~·~     ~·~     ~·~     ~·~     ~·~     ~·~
// · 
=end

#
require Lesli::Engine.root.join("lib/test/lesli")

#
class AccountLogsTest < LesliModelTester
    # A tiny class that includes the concern.
    class FakeAccount
        include Lesli::AccountLogs

        attr_accessor :audit, :logs

        def initialize(audit: nil, logs: nil)
            @audit = audit
            @logs  = logs
        end
    end

    # Captures calls to create/create!
    class CapturingLogs
        attr_reader :created_payloads

        def initialize
            @created_payloads = []
        end

        def create!(payload)
            @created_payloads << payload
            true
        end
    end

    setup do
        # Define a minimal LesliAudit stub for tests that need it.
        unless Object.const_defined?(:LesliAudit)
            Object.const_set(:LesliAudit, Module.new)
        end

        unless LesliAudit.const_defined?(:AccountLog)
            LesliAudit.const_set(:AccountLog, Class.new)
        end
    end

    teardown do
        # Remove LesliAudit constants we introduced, so tests stay isolated.
        if Object.const_defined?(:LesliAudit)
            LesliAudit.send(:remove_const, :AccountLog) if LesliAudit.const_defined?(:AccountLog)
            Object.send(:remove_const, :LesliAudit)
        end
    end

    test "does nothing when LesliAudit is not defined" do
        # Temporarily remove LesliAudit for this test
        Object.send(:remove_const, :LesliAudit) if Object.const_defined?(:LesliAudit)

        account = FakeAccount.new(audit: nil, logs: CapturingLogs.new)

        # Should not raise and should not log anywhere
        assert_nothing_raised { account.log("op", "desc") }
        assert_empty account.logs.created_payloads
    ensure
        # restore stub so teardown doesn't blow up
        Object.const_set(:LesliAudit, Module.new) unless Object.const_defined?(:LesliAudit)
        LesliAudit.const_set(:AccountLog, Class.new) unless LesliAudit.const_defined?(:AccountLog)
    end

    test "logs anonymous when audit is nil/false" do
        created = []
        LesliAudit::AccountLog.define_singleton_method(:create) do |payload|
            created << payload
            true
        end

        account = FakeAccount.new(audit: nil, logs: CapturingLogs.new)
        account.log("login", "someone logged in")

        assert_equal 1, created.length
        assert_equal({ operation: "login", description: "someone logged in" }, created.first)

        # Ensure account logs weren't used
        assert_empty account.logs.created_payloads
    end

    test "logs to account logs association when audit is present" do
        created = []
        LesliAudit::AccountLog.define_singleton_method(:create) do |payload|
            created << payload
            true
        end

        logs = CapturingLogs.new
        account = FakeAccount.new(audit: true, logs: logs)

        account.log("update", "changed settings")

        assert_empty created, "Expected LesliAudit::AccountLog.create not to be called when audit is present"

        assert_equal 1, logs.created_payloads.length
        assert_equal({ operation: "update", description: "changed settings" }, logs.created_payloads.first)
    end
end
