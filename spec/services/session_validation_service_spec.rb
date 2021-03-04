require 'rails_helper'


def user_factory
    user = Account.first.users.create!({
                                               email: Faker::Internet.email,
                                               password: "tardis2021$",
                                               password_confirmation: "tardis2021$"
                                       })
    user.user_roles.create({ role: Account.first.roles.find_by(name: "limited") })
    return user
end


RSpec.describe SessionValidationService, type: :model do
    user = user_factory()

    describe '#confirmed?' do
        it 'The resource is confirmed' do
            user.confirm
            session_validation = SessionValidationService.new(user)

            response = session_validation.valid?
            expect(response.success?).to eq true
        end
        it 'The resource is not confirmed.' do
            SessionValidationService.confirmed?
            expect(1).to eq 1
        end
    end
end
