
require "rails_helper"
require Lesli::Engine.root.join("spec/support/testers/model")

RSpec.describe Lesli::UsersValidator, type: :model do

    #let(:account) { create(:account) }
    #let(:user) { create(:user, account: account) }
    #let(:validator) { described_class.new(user) }

    let(:account) { FactoryBot.create(:lesli_account) }
    let(:user) { account.user }
    let(:validator) { described_class.new(user) }

    describe '#password_complexity' do
        let(:password) { 'Passw0rd!' }
        let(:password_settings) do
            [
                create(:setting, name: 'password_enforce_complexity', value: '1', account: account),
                create(:setting, name: 'password_special_char_count', value: '1', account: account),
                create(:setting, name: 'password_lowercase_count', value: '1', account: account),
                create(:setting, name: 'password_uppercase_count', value: '1', account: account),
                create(:setting, name: 'password_minimum_length', value: '8', account: account),
                create(:setting, name: 'password_digit_count', value: '1', account: account)
            ]
        end

        before do
            allow(user.account).to receive(:settings).and_return(password_settings)
        end

        
    end

    
=begin
    
    it 'validates the password complexity' do
        validator.password_complexity(password)
        expect(validator.failures).to be_empty
    end
    

    it 'fails when password is blank' do
    validator.password_complexity('')
    expect(validator.failures).to include('error_password_cannot_be_blank')
    end

    # Additional tests for each password complexity requirement can be added here
    end

    describe '#active?' do
    it 'returns true if user is active and not locked' do
    allow(user).to receive(:active?).and_return(true)
    allow(user).to receive(:locked_until).and_return(nil)

    expect(validator.send(:active?)).to be true
    end

    it 'returns false and logs if user is not active' do
    allow(user).to receive(:active?).and_return(false)
    allow(user).to receive(:locked_until).and_return(Time.now + 1.hour)

    expect(validator.send(:active?)).to be false
    expect(user.logs.last.description).to eq('user_locked')
    end
    end

    describe '#confirmed?' do
    it 'returns true if user is confirmed' do
    allow(user).to receive(:confirmed?).and_return(true)

    expect(validator.send(:confirmed?)).to be true
    end

    it 'returns false and logs if user is not confirmed' do
    allow(user).to receive(:confirmed?).and_return(false)

    expect(validator.send(:confirmed?)).to be false
    expect(user.logs.last.description).to eq('email_not_confirmed')
    end
    end

    describe '#roles_empty?' do
    it 'returns false if user has roles' do
    allow(user).to receive(:roles).and_return([double])

    expect(validator.send(:roles_empty?)).to be false
    end

    it 'returns true and logs if user has no roles' do
    allow(user).to receive(:roles).and_return([])

    expect(validator.send(:roles_empty?)).to be true
    expect(user.logs.last.description).to eq('user_has_no_assigned_role')
    end
    end

    describe '#active_roles?' do
    it 'returns true if user has active roles' do
    allow(user).to receive(:roles).and_return([double(active: true)])

    expect(validator.send(:active_roles?)).to be true
    end

    it 'returns false and logs if user has no active roles' do
    allow(user).to receive(:roles).and_return([double(active: false)])

    expect(validator.send(:active_roles?)).to be false
    expect(user.logs.last.description).to eq('user_has_no_active_role')
    end
    end
=end
end
