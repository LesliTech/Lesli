=begin

Copyright (c) 2021, all rights reserved.

All the information provided by this platform is protected by international laws related  to
industrial property, intellectual property, copyright and relative international laws.
All intellectual or industrial property rights of the code, texts, trade mark, design,
pictures and any other information belongs to the owner of this platform.

Without the written permission of the owner, any replication, modification,
transmission, publication is strictly forbidden.

For more information read the license file including with this software.

// · ~·~     ~·~     ~·~     ~·~     ~·~     ~·~     ~·~     ~·~     ~·~     ~·~     ~·~     ~·~
// ·

=end


require 'rails_helper'
require 'spec_helper'
require 'byebug'


RSpec.describe 'POST:/onboarding.json', type: :request do
    include_context 'user authentication'

    let!(:status) do 
        [
            :registered, 
            :onboarding,
            :active, 
            :suspended
        ]
    end

    let!(:regions) do
        {
            latin_america: "latin_america",
            united_states: "united_states",
            european_union: "european_union"
        }
    end

    before(:all) do

        @company_name = Faker::Name.name
        @company_name_legal = Faker::Name.name
        @company_tag_line = Faker::Quote.yoda
        @country = Faker::Address.country
        @address = Faker::Address.full_address
        @status = "active"
        @region = "latin_america"
        @phone_number_1 = Faker::PhoneNumber.phone_number
        @phone_number_2 = Faker::PhoneNumber.phone_number
        @phone_number_3 = Faker::PhoneNumber.phone_number
        @phone_number_4 = Faker::PhoneNumber.phone_number
        @website = Faker::Internet.url
        @public_email = Faker::Internet.email
        @github = Faker::Internet.url
        @twitter = Faker::Internet.url
        @youtube = Faker::Internet.url
        @linkedin = Faker::Internet.url
        @facebook = Faker::Internet.url

        post("/onboarding.json", params: {
            onboarding: {
                account: {
                    company_name: @company_name,
                    company_name_legal: @company_name_legal,
                    company_tag_line: @company_tag_line,
                    country: nil,
                    address: @address,
                    region: @region,
                    phone_number_1: @phone_number_1,
                    phone_number_2: @phone_number_2,
                    phone_number_3: @phone_number_3,
                    phone_number_4: @phone_number_4,
                    website: @website,
                    public_email: @public_email,
                    github: @github,
                    twitter: @twitter,
                    youtube: @youtube,
                    linkedin: @linkedin,
                    facebook: @facebook,
                    status: @status
                },
                account_settings: {
                    datetime_time_zone: "America/Guatemala",
                    datetime_start_week_on: "monday",
                    datetime_format_date: "%d/%m/%Y",
                    datetime_format_time: "%H:%M",
                    datetime_format_date_time: "%d/%m/%Y %H:%M",
                    datetime_format_date_words: "%a, %B %d, %Y",
                    datetime_format_date_time_words: "%a, %B %d, %Y, %H:%M",
                    password_enforce_complexity: 1,
                    password_lowercase_count: 0,
                    password_uppercase_count: 0,
                    password_digit_count: 0,
                    password_special_char_count: 0,
                    password_minimum_length: 10,
                    password_expiration_time_days: 365,
                }
            }
        })
    end

    include_examples 'successful standard json response'

    it 'is expected to create an return with all keys and values' do
        expect(@response_body_data).to be_a(Hash)

        expect(@response_body_data).to have_key("id")
        expect(@response_body_data["id"]).to be_a(Numeric)
        expect(@response_body_data["id"]).to be > 0

        expect(@response_body_data).to have_key("users_id")
        expect(@response_body_data["id"]).to be_a(Numeric)

        expect(@response_body_data).to have_key("status")
        expect(@response_body_data["status"]).to be_a(String)
        expect(@response_body_data["status"]).to eql(@status)
        expect(@response_body_data["status"]).to be_in(status.map { |x| x.to_s })

        expect(@response_body_data).to have_key("created_at")
        expect(@response_body_data["created_at"]).to be_a(String)

        expect(@response_body_data).to have_key("updated_at")
        expect(@response_body_data["updated_at"]).to be_a(String)

        expect(@response_body_data).to have_key("company_name")
        expect(@response_body_data["company_name"]).to be_a(String)
        expect(@response_body_data["company_name"]).to eq(@company_name)
        
        expect(@response_body_data).to have_key("company_name_legal")
        expect(@response_body_data["company_name_legal"]).to be_a(String)
        expect(@response_body_data["company_name_legal"]).to eq(@company_name_legal)

        expect(@response_body_data).to have_key("company_tag_line")
        expect(@response_body_data["company_tag_line"]).to be_a(String)
        expect(@response_body_data["company_tag_line"]).to eq(@company_tag_line)

        expect(@response_body_data).to have_key("address")
        expect(@response_body_data["address"]).to be_a(String)
        expect(@response_body_data["address"]).to eq(@address)

        expect(@response_body_data).to have_key("region")
        expect(@response_body_data["region"]).to be_a(String)
        expect(@response_body_data["region"]).to eq(@region)
        expect(@response_body_data["region"]).to be_in(regions.values)

        expect(@response_body_data).to have_key("phone_number_1")
        expect(@response_body_data["phone_number_1"]).to be_a(String)
        expect(@response_body_data["phone_number_1"]).to eq(@phone_number_1)

        expect(@response_body_data).to have_key("phone_number_2")
        expect(@response_body_data["phone_number_2"]).to be_a(String)
        expect(@response_body_data["phone_number_2"]).to eq(@phone_number_2)

        expect(@response_body_data).to have_key("phone_number_3")
        expect(@response_body_data["phone_number_3"]).to be_a(String)
        expect(@response_body_data["phone_number_3"]).to eq(@phone_number_3)

        expect(@response_body_data).to have_key("phone_number_4")
        expect(@response_body_data["phone_number_4"]).to be_a(String)
        expect(@response_body_data["phone_number_4"]).to eq(@phone_number_4)

        expect(@response_body_data).to have_key("website")
        expect(@response_body_data["website"]).to be_a(String)
        expect(@response_body_data["website"]).to eq(@website)

        expect(@response_body_data).to have_key("public_email")
        expect(@response_body_data["public_email"]).to be_a(String)
        expect(@response_body_data["public_email"]).to eq(@public_email)

        expect(@response_body_data).to have_key("github")
        expect(@response_body_data["github"]).to be_a(String)
        expect(@response_body_data["github"]).to eq(@github)

        expect(@response_body_data).to have_key("twitter")
        expect(@response_body_data["twitter"]).to be_a(String)
        expect(@response_body_data["twitter"]).to eq(@twitter)

        expect(@response_body_data).to have_key("youtube")
        expect(@response_body_data["youtube"]).to be_a(String)
        expect(@response_body_data["youtube"]).to eq(@youtube)

        expect(@response_body_data).to have_key("linkedin")
        expect(@response_body_data["linkedin"]).to be_a(String)
        expect(@response_body_data["linkedin"]).to eq(@linkedin)

        expect(@response_body_data).to have_key("facebook")
        expect(@response_body_data["facebook"]).to be_a(String)
        expect(@response_body_data["facebook"]).to eq(@facebook)
    end
end

RSpec.describe "POST:/onboardings.json", type: :request do
    include_context "user authentication"

    before(:all) do
        post("/onboarding.json", params: {
            onboarding: {
                account: {},
                account_settings: {}
            }
        })

    end

    include_examples 'error standard json response'

    it "is expected to respond with error when params are not sent" do
        expect(@response_body).to have_key("error")
        expect(@response_body["error"]).to be_a(Hash)

        expect(@response_body["error"]).to have_key("message")
        expect(@response_body["error"]["message"]).to be_a(String)
        
        expect(@response_body["error"]).to have_key("details")
        expect(@response_body["error"]["details"]).to be_a(Array)
    end
end
