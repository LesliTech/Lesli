=begin

Copyright (c) 2023, all rights reserved.

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

require "lesli_request_helper"

RSpec.describe 'GET:/administration/account/issues.json', type: :request do
    include_context "request user authentication"

    let!(:new_issue) do

        issue_params =  {
            first_name: Faker::Name.first_name,
            last_name: Faker::Name.last_name,
            email: Faker::Internet.email,
            telephone: Faker::PhoneNumber.phone_number,
            company_name: Faker::Company.name,
            message: Faker::Lorem.paragraph,
            category: ["feedback", "contact_us", "report_error", "report_abuse", "block_object"].sample,
            source: ["not_specified", "web_page", "web_app", "api", "email", "call_center", "mobile_app"].sample,
            reference: Faker::Internet.url,

        }    

        issue = @current_user.account.issues.new(issue_params)
        issue.user = @current_user
        issue.account = @current_user.account
        issue.save!
        issue
    end

    it 'is expected to respond with all the issues' do
        get '/administration/account/issues.json'
        
        # shared examples
        expect_response_with_successful

        # shared specs
        expect(@response_body_data).to be_a(Object)
        expect(response_body["records"][0]).to be_a(Object)

        expect(response_body["records"][0]).to have_key("id")
        expect(response_body["records"][0]["id"]).to be_a(Integer)

        expect(response_body["records"][0]).to have_key("full_name")
        expect(response_body["records"][0]["full_name"]).to be_a(String)

        expect(response_body["records"][0]).to have_key("email")
        expect(response_body["records"][0]["email"]).to be_a(String)
        expect(response_body["records"][0]["email"]).to be_eql(new_issue.email)

        expect(response_body["records"][0]).to have_key("telephone")
        expect(response_body["records"][0]["telephone"]).to be_a(String)
        expect(response_body["records"][0]["telephone"]).to be_eql(new_issue.telephone)

        expect(response_body["records"][0]).to have_key("message")
        expect(response_body["records"][0]["message"]).to be_a(String)
        expect(response_body["records"][0]["message"]).to be_eql(new_issue.message)

        expect(response_body["records"][0]).to have_key("category")
        expect(response_body["records"][0]["category"]).to be_a(String)
        expect(response_body["records"][0]["category"]).to be_eql(new_issue.category)

        expect(response_body["records"][0]).to have_key("source")
        expect(response_body["records"][0]["source"]).to be_a(String)
        expect(response_body["records"][0]["source"]).to be_eql(new_issue.source)

        expect(response_body["records"][0]).to have_key("reference")
        expect(response_body["records"][0]["reference"]).to be_a(String)
        expect(response_body["records"][0]["reference"]).to be_eql(new_issue.reference)

        expect(response_body["records"][0]).to have_key("company_name")
        expect(response_body["records"][0]["company_name"]).to be_a(String)
        expect(response_body["records"][0]["company_name"]).to be_eql(new_issue.company_name)

    end
end
