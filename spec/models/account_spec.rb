=begin
DESCRIPTION GOES HERE
=end

require "rails_helper"
require Lesli::Engine.root.join("spec/support/testers/model")

RSpec.describe Lesli::Account, type: :model do
    # Setup runs before each test
    let(:account) { 
        Account.new(
            id: 1,
            status: 1,
            email: "",
            name: "",
            deleted_at: '2024-06-13 00:49:28 -0600',
            created_at: '2024-06-13 00:49:28 -0600',
            updated_at: '2024-06-13 00:49:28 -0600',
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
