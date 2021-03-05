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


def user_factory_without_roles
    user = Account.first.users.create!({
                                               email: Faker::Internet.email,
                                               password: "tardis2021$",
                                               password_confirmation: "tardis2021$"
                                       })
    return user
end

RSpec.describe SessionValidationService, type: :model do
    describe 'Check if user is confirmed' do
        it 'is expected user is confirmed' do
            user = user_factory()
            user.confirm
            session_validation = SessionValidationService.new(user)

            response = session_validation.valid?

            expect(response.success?).to eq true
        end

        it 'is expected to respond with an unconfirmed message' do
            user = user_factory()
            session_validation = SessionValidationService.new(user)
            response = session_validation.valid?

            expect(response.success?).to eq false
            expect(response.error).to eql({
                                                  "message"=> I18n.t("devise.errors.custom.confirmation_required")
                                          })
        end

        it 'is expected to respond with a message of has not roles' do
            user = user_factory_without_roles()
            user.confirm

            session_validation = SessionValidationService.new(user)
            response = session_validation.valid?

            expect(response.success?).to eq false
            expect(response.error).to eql({
                                                  "message"=> I18n.t("core.users/sessions.the_user_has_no_assigned_role")
                                          })
        end

        it "is expected user is valid with roles'" do
            user = user_factory()
            user.confirm

            session_validation = SessionValidationService.new(user)
            response = session_validation.valid?

            expect(response.success?).to eq true
        end

        it "is expected to respond with an access denied message for inactive roles" do
            user = user_factory_without_roles()
            user.confirm
            user_roles = user.user_roles.create({ role: Account.first.roles.find_by(name: "limited")})
            user_roles.roles.update(active: false)

            session_validation = SessionValidationService.new(user)
            response = session_validation.valid?

            expect(response.success?).to eq false
            expect(response.error).to eql({
                                                  "message"=> I18n.t("deutscheleibrenten.users/sessions.role_access_denied")
                                          })

            # The limited role is used by other tests.
            # TODO: Create factory for roles so that the test is independent.
            user_roles.roles.update(active: true)
        end

        it "is expected user is valid with active roles'" do
            user = user_factory_without_roles()
            user.confirm
            user_roles = user.user_roles.create({ role: Account.first.roles.find_by(name: "limited")})
            user_roles.roles.update(active: true)

            session_validation = SessionValidationService.new(user)
            response = session_validation.valid?

            expect(response.success?).to eq true
        end
    end
end
