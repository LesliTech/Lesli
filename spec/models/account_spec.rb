=begin

Lesli

Copyright (c) 2023, Lesli Technologies, S. A.

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

require "rails_helper"
require Lesli::Engine.root.join("spec/support/testers/model")

RSpec.describe , type: :model do
    # Setup runs before each test
    let(:account) { 
        Account.new(
            id: 1,
            status: 1,
            email: "",
            name: "",
            deleted_at: '2024-06-30 15:23:39 -0600',
            created_at: '2024-06-30 15:23:39 -0600',
            updated_at: '2024-06-30 15:23:39 -0600',
            user_id: 1,
        ) 
    }

    it "is valid with valid attributes" do
        expect(account).to be_valid
    end

    it "is invalid without a name" do
        account.name = nil
        expect(account).not_to be_valid
    end

    it "is invalid without an email" do
        account.email = nil
        expect(account).not_to be_valid
    end

    it "is invalid with a duplicate email" do
        account.save
        duplicate_account = Account.new(name: "Test Account 2", email: "test@example.com", balance: 50.0)
        expect(duplicate_account).not_to be_valid
    end

    it "is invalid without a balance" do
        account.balance = nil
        expect(account).not_to be_valid
    end

    it "is invalid with a negative balance" do
        account.balance = -1
        expect(account).not_to be_valid
    end

    # Test associations
    it "has many transactions" do
        expect(account).to respond_to(:transactions)
    end

    # Test custom methods
    describe "#update_balance" do
        it "updates the balance correctly" do
            account.save
            account.update_balance(50.0)
            expect(account.reload.balance).to eq(150.0)
        end
    end
end
