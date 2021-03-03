require 'rails_helper'

def user_factory
    user = User.new(
            email:     Faker::Internet.email,
            password:  "password",
            )
    user.save
    return user
end

RSpec.describe User::AccessCode, type: :model do
    describe '#initialize_secret_code' do
        it 'initialize a users secret code' do
            user = user_factory()
            User::AccessCode.initialize_secret_code(user)
            expect(User::AccessCode.find_by(user: user).users_id).to eq user.id
        end
    end

    describe '#create' do
        response = TokenAuthenticationService.create_otp_secret
        subject {
                described_class.new(otp_secret: response.payload[:otp_secret],
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

    describe '#generate_code' do
        it 'user can generate a token' do
            user = user_factory()
            access_code = User::AccessCode.find_by(user: user)
            expect(access_code.generate_code.class).to eq(Integer)
        end
    end
end
