require 'rails_helper'


RSpec.describe TokenAuthenticationService, type: :model do
    describe '#create_otp_secret' do
        it 'create an otp secret' do
            allow(ROTP::Base32).to receive(:random_base32).and_return("x3avyarrzrsk7mpk")
            response = TokenAuthenticationService.create_otp_secret
            expect(response.success?).to eq true
            expect(response.payload[:otp_secret]).to eq "x3avyarrzrsk7mpk"
        end
    end

    describe '#create_token' do
        it 'It is not created with a non-configured user' do
            user = User.create(email: Faker::Internet.email, password:  "password")
            User::AccessCode.find_by(users_id: user.id).delete
            token_auth_service = TokenAuthenticationService.new(user)
            response = token_auth_service.create_token
            expect(response.success?).to eq false
            expect(response.error[:token]).to eq nil
        end

        it 'Created with configured user' do
            user = User.create(email: Faker::Internet.email, password:  "password")
            allow_any_instance_of(ROTP::TOTP).to receive(:now).and_return("492039")

            token_auth_service = TokenAuthenticationService.new(user)
            response = token_auth_service.create_token
            expect(response.success?).to eq true
            expect(response.payload[:token]).to eq "492039"
        end
    end

    describe '#is_token_valid?' do
        it 'Verify token with non-configured user' do
            user = User.create(email: Faker::Internet.email, password:  "password")
            User::AccessCode.find_by(users_id: user.id).delete
            token_auth_service = TokenAuthenticationService.new(user)
            response = token_auth_service.is_token_valid?("492039")

            expect(response.success?).to eq false
            expect(response.error[:details]).to eq "User is not configured to use access code"
        end

        it 'verify token with configured user' do
            user = User.create(email: Faker::Internet.email, password:  "password")
            token_auth_service = TokenAuthenticationService.new(user)
            response_token = token_auth_service.create_token
            response = token_auth_service.is_token_valid?(response_token.payload[:token])

            expect(response.success?).to eq true
            expect(response.payload[:is_valid?]).to eq true
        end

        it 'verify a token that has already been used' do
            user = User.create(email: Faker::Internet.email, password:  "password")
            token_auth_service = TokenAuthenticationService.new(user)
            response_token = token_auth_service.create_token

            # First use
            token_auth_service.is_token_valid?(response_token.payload[:token])
            # Second use
            response = token_auth_service.is_token_valid?(response_token.payload[:token])
            expect(response.success?).to eq false
            expect(response.error[:details]).to eq "The token has already been used"
        end
    end

end
