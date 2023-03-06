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


RSpec.describe "PUT:/administration/account/issues/:id.json", type: :request do
    include_context "request user authentication"
    # test cases

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

    it "is expected to update an issue" do
        new_issue_params = {
            first_name: Faker::Name.first_name,
            last_name: Faker::Name.last_name,
            email: Faker::Internet.email,
            telephone: Faker::PhoneNumber.phone_number,
            company_name: Faker::Company.name,
            message: Faker::Lorem.paragraph,
            status: ["created", "reviewed", "solved", "closed"].sample,
            category: ["feedback", "contact_us", "report_error", "report_abuse", "block_object"].sample,
            source: ["not_specified", "web_page", "web_app", "api", "email", "call_center", "mobile_app"].sample,
            reference: Faker::Internet.url
        }

        put("/administration/account/issues/#{new_issue.id}.json", params: {
            account_issue: new_issue_params
        })

        expect_response_with_successful

        # shared_expects validates the response body with the given arguments
        shared_expects(response_body, new_issue_params, [
            { key: "id", expected_type: "integer" },
            { key: "email", expected_type: "string", expected_value: new_issue_params[:email] },
            { key: "first_name", expected_type: "string", expected_value: new_issue_params[:first_name] },
            { key: "last_name", expected_type: "string", expected_value: new_issue_params[:last_name] },
            { key: "telephone", expected_type: "string", expected_value: new_issue_params[:telephone] },
            { key: "message", expected_type: "string", expected_value: new_issue_params[:message] },
            { key: "status", expected_type: "string", expected_value: new_issue_params[:status] },
            { key: "category", expected_type: "string", expected_value: new_issue_params[:category] },
            { key: "source", expected_type: "string", expected_value: new_issue_params[:source] },
            { key: "reference", expected_type: "string", expected_value: new_issue_params[:reference] }
        ])
    end

    it "is expected to respond with not found if id is not valid" do
        new_issue_params = {
            first_name: Faker::Name.first_name,
            last_name: Faker::Name.last_name,
            email: Faker::Internet.email,
            telephone: Faker::PhoneNumber.phone_number,
            company_name: Faker::Company.name,
            message: Faker::Lorem.paragraph,
            status: ["created", "reviewed", "solved", "closed"].sample,
            category: ["feedback", "contact_us", "report_error", "report_abuse", "block_object"].sample,
            source: ["not_specified", "web_page", "web_app", "api", "email", "call_center", "mobile_app"].sample,
            reference: Faker::Internet.url
        }

        put("//administration/account/issues/#{new_issue.id + 1}.json", params: {
            account_issue: new_issue_params
        })

        expect_response_with_not_found

    end

    it "is expected to respond with not error if params are empty" do
        new_issue_params = {}

        put("/administration/account/issues/#{new_issue.id}.json", params: {
            account_issue: new_issue_params
        })

        expect_response_with_error

    end

end
