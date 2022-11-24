=begin
Copyright (c) 2022, all rights reserved.

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

RSpec.describe "Tests for Lesli3", type: :request do
    describe "POST:/administration/account/issues.json", type: :request do
        include_context "request user authentication"

        it "is expected to respond with a issue created successfully" do

            account_attrs_types = {
                first_name: String,
                last_name: String,
                company_name: String,
                email: String,
                telephone: String,
                message: String,
                category: String,
                status: String,
                source: String,
                reference: String,
            }

            account_issue = {
                :first_name => Faker::Name.first_name,
                :last_name => Faker::Name.last_name,
                :company_name => Faker::Company.name,
                :email => Faker::Internet.email,
                :telephone => Faker::PhoneNumber.phone_number,
                :message => Faker::Lorem.paragraph,
                :subscribed => true,
                :category => "contact_us",
                :status => "created",
                :source => "web_page",
                :reference => nil,
            }

            post("/administration/account/issues.json", params: {
                account_issue: account_issue
            })

            #share examples
            expect_response_with_successful

            expect(response_body).to be_a(Hash)
            expect(response_body).to have_key("id")
            expect(response_body["id"]).to be_a(Numeric)

            expect(response_body).to have_key("deleted_at")
            expect(response_body["deleted_at"]).to be_nil

            account_attrs_types.each do |attr_name, type|
                if response_body[attr_name].nil?
                    expect(response_body[attr_name]).to be_nil
                else
                    expect(response_body[attr_name]).to be_a(type).and eql(account_issue[attr_name])
                end
            end

            expect(response_body).to have_key("accounts_id")
            expect(response_body["accounts_id"]).to be_a(Numeric).and eql(@current_user.account.id)

            expect(response_body).to have_key("users_id")
            expect(response_body["users_id"]).to be_a(Numeric).and eql(@current_user.id)

        end

    end
end
