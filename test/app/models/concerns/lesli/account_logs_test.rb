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
require "test_helper"

#
module Lesli
    class AccountLogsTest < LesliTesting::ModelTester
        # A tiny class that includes the concern.
        class FakeAccount
            include Lesli::AccountLogs
        end

        setup do
            audit = Module.new
            activity_audit = Class.new do
                class << self
                    attr_reader :calls

                    def record_account!(**attributes)
                        (@calls ||= []) << attributes
                        :event
                    end
                end
            end
            audit.const_set(:ActivityAudit, activity_audit)
            Object.const_set(:LesliAudit, audit)
        end

        teardown do
            # Remove LesliAudit constants we introduced, so tests stay isolated.
            Object.send(:remove_const, :LesliAudit) if Object.const_defined?(:LesliAudit)
        end

        test "does nothing when LesliAudit is not defined" do
            # Temporarily remove LesliAudit for this test
            Object.send(:remove_const, :LesliAudit) if Object.const_defined?(:LesliAudit)

            account = FakeAccount.new

            # Should not raise and should not log anywhere
            assert_nothing_raised { account.log("op", "desc") }
        ensure
            # restore stub so teardown doesn't blow up
            Object.const_set(:LesliAudit, Module.new) unless Object.const_defined?(:LesliAudit)
        end

        test "delegates activity events to LesliAudit" do
            account = FakeAccount.new
            user = Object.new

            result = account.log("update", "changed settings", user: user)

            assert_equal :event, result
            assert_equal(
                [{ account: account, actor: user, operation: "update", description: "changed settings" }],
                LesliAudit::ActivityAudit.calls
            )
        end
    end
end
