require 'rails_helper'

def user_factory
    user = User.new(
            email:     Faker::Internet.email,
            password:  "password",
            )
    user.save
    return user
end

RSpec.describe AccessCode, type: :model do
    describe '#create' do
        subject {
                described_class.new(otp_secret: TokenAuthenticationService.create_otp_secret,
                                    user: user_factory())
        }
        it 'is valid with valid attributes' do
            expect(subject).to be_valid
        end
        it 'is not valid without a otp secret' do
            subject.otp_secret = nil
            expect(subject).to_not be_valid
        end
        it 'is not valid without a user' do
            subject.user = nil
            expect(subject).to_not be_valid
        end
    end
end
