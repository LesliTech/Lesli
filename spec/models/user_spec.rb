require "rails_helper"
require "spec_helper"
require "byebug"
require "faker"

RSpec.describe "using method (clear_fields) based on a list of specific fields", type: :model do
    account = User.find_by(email: Rails.application.config.lesli_settings["account"]["user"]["email"]).account # instance of account

    # user variables
    password = Faker::Internet.password
    first_name = Faker::Name.last_name
    last_name = Faker::Name.last_name
    salutation = ["mr", "mrs"][rand(2)]
    address = Faker::Address.city

    # create user
    user = account.users.create({
        email: Faker::Internet.email,
        password: password,
        password_confirmation: password,
        detail_attributes: {
            first_name: first_name,
            last_name: last_name,
            salutation: salutation,
            address: address
        }
    })


    user.detail.clear_fields(["first_name", "last_name"])

    it "clear only specific fields where clean" do
        expect(user.detail.first_name).to   eql(nil)
        expect(user.detail.last_name).to    eql(nil)
        expect(user.detail.salutation).to   eql(salutation)
        expect(user.detail.address).to      eql(address)
    end
end


RSpec.describe "using method (clear_fields) to clear all fields excluding foreign key", type: :model do
    account = User.find_by(email: Rails.application.config.lesli_settings["account"]["user"]["email"]).account # instance of account

    # create user
    password = Faker::Internet.password

    user = account.users.create({
        email: Faker::Internet.email,
        password: password,
        password_confirmation: password,
        detail_attributes: {
            first_name: Faker::Name.last_name,
            last_name: Faker::Name.last_name,
            salutation: ["mr", "mrs"][rand(2)],
            address: Faker::Address.city
        }
    })


    user.detail.clear_fields

    it "clear all fields excluding foreign keys" do
        user.detail.attributes.each do |key, value|
            next if (key.end_with? "id") ||
            key == "created_at" ||
            key == "updated_at" ||
            key == "deleted_at"

            expect(value).to eql(nil)
        end
    end
end


RSpec.describe "using method (full_name_initials)", type: :model do
    account = User.find_by(email: Rails.application.config.lesli_settings["account"]["user"]["email"]).account # instance of account

    # create user
    first_name = Faker::Name.last_name
    last_name = Faker::Name.last_name
    password = Faker::Internet.password

    user = account.users.create({
        email: Faker::Internet.email,
        password: password,
        password_confirmation: password,
        detail_attributes: {
            first_name: first_name,
            last_name: last_name,
            salutation: ["mr", "mrs"][rand(2)],
            address: Faker::Address.city
        }
    })

    it "Initials match" do

        first_name_initial = first_name[0].upcase
        last_name_initial = last_name[0].upcase

        expect(user.full_name_initials).to  eql("#{first_name_initial}#{last_name_initial}")
    end
end
