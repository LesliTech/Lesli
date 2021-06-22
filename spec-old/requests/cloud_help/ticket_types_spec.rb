require 'rails_helper'

RSpec.describe "CloudHelp::TicketTypes", type: :request do
    include Devise::Test::IntegrationHelpers

    def login_admin
        @user = User.find_by(email: "admin@lesli.cloud")
        sign_in @user
    end

    def create_account
        @account = CloudHelp::Account.new(id: @user.account.id)
    end

    def json_headers
        {
            "Content-Type" => "application/json",
            "Accept" => "application/json"
        }
    end


    describe "INDEX integration test" do  

        it "test http json response" do
            login_admin

            get "/help/ticket_types.json"
            response_json = JSON.parse(response.body)

            expect(response.status).to be 200
            expect(response.headers["Content-Type"]).to eq "application/json; charset=utf-8"
            expect(response_json["successful"]).to be true
        end
        
        it "test http html response" do
            login_admin

            get "/help/ticket_types.html"
        
            expect(response.status).to be 200
            expect(response.headers["Content-Type"]).to eq "text/html; charset=utf-8"
        end
    end


    describe "SHOW integration test" do

        it "test http html response" do
            login_admin
            create_account

            ticket_type = CloudHelp::TicketType.create!(
                name: Faker::Verb.base,
                account: @account
            )

            get "/help/ticket_types/#{ticket_type.id}.html"
            expect(response.status).to be 200
            expect(response.headers["Content-Type"]).to eq "text/html; charset=utf-8"
        end

        it "test valid request" do
            login_admin
            create_account

            ticket_type = CloudHelp::TicketType.create!(
                name: Faker::Verb.base,
                account: @account
            )

            get "/help/ticket_types/#{ticket_type.id}.json"
            response_json = JSON.parse(response.body)

            expect(response.status).to be 200
            expect(response.headers["Content-Type"]).to eq "application/json; charset=utf-8"
            expect(response_json["successful"]).to be true
        end

        it "test invalid request (non-existent type)" do
            login_admin
            create_account

            get "/help/ticket_types/#{Faker::Number.number(digits: 6)}.json"
            response_json = JSON.parse(response.body)

            expect(response.status).to be 404
        end

        it "test invalid request (requesting type from another account)" do
            login_admin
            create_account

            other_main_account = Account.create!(id: Account.order(id: :asc).last.id + 1)
            other_help_account = CloudHelp::Account.create!(id: other_main_account.id)
            ticket_type = CloudHelp::TicketType.create!(
                name: Faker::Verb.base,
                account: other_help_account
            )

            get "/help/ticket_types/#{ticket_type.id}.json"
            response_json = JSON.parse(response.body)

            expect(response.status).to be 404
        end
    end

    describe "NEW integration test" do

        it "test http html response" do
            login_admin

            get "/help/ticket_types/new.html"

            expect(response.status).to be 200
            expect(response.headers["Content-Type"]).to eq "text/html; charset=utf-8"
        end
    end


    describe "EDIT integration test " do

        it "test http html response" do
            login_admin

            get "/help/ticket_types/edit.html"

            expect(response.status).to be 200
            expect(response.headers["Content-Type"]).to eq "text/html; charset=utf-8"
        end
    end


    describe "CREATE integration test" do

        it "test valid request" do
            login_admin

            request_json = {
                name: Faker::Verb.base
            }.to_json
            headers = json_headers

            post "/help/ticket_types", params: request_json, headers: headers
            response_json = JSON.parse(response.body)
            
            expect(response.status).to be 200
            expect(response.headers["Content-Type"]).to eq "application/json; charset=utf-8"
            expect(response_json["successful"]).to be true
        end

        it "test invalid request (no name)" do
            login_admin

            request_json = { }.to_json
            headers = json_headers

            post "/help/ticket_types", params: request_json, headers: headers
            response_json = JSON.parse(response.body)

            expect(response.status).to be 200
            expect(response.headers["Content-Type"]).to eq "application/json; charset=utf-8"
            expect(response_json["successful"]).to be false
        end
    end


    describe "UPDATE integration test" do

        it "test valid request" do
            login_admin
            create_account

            ticket_type = CloudHelp::TicketType.create!(
                name: Faker::Verb.base,
                account: @account
            )
            request_json = {
                name: Faker::Verb.base
            }.to_json
            headers = json_headers

            put "/help/ticket_types/#{ticket_type.id}", params: request_json, headers: headers
            response_json = JSON.parse(response.body)

            expect(response.status).to be 200
            expect(response.headers["Content-Type"]).to eq "application/json; charset=utf-8"
            expect(response_json["successful"]).to be true
        end

        it "test invalid request (name changed to nil)" do
            login_admin
            create_account

            ticket_type = CloudHelp::TicketType.create!(
                name: Faker::Verb.base,
                account: @account
            )
            request_json = {
                name: nil
            }.to_json
            headers = json_headers

            put "/help/ticket_types/#{ticket_type.id}", params: request_json, headers: headers
            response_json = JSON.parse(response.body)

            expect(response.status).to be 200
            expect(response.headers["Content-Type"]).to eq "application/json; charset=utf-8"
            expect(response_json["successful"]).to be false
        end

        it "test invalid request (non-existent type)" do
            login_admin
            create_account

            request_json = {
                name: Faker::Verb.base
            }.to_json
            headers = json_headers

            put "/help/ticket_types/#{Faker::Number.number(digits: 10)}", params: request_json, headers: headers
            response_json = JSON.parse(response.body)

            expect(response.status).to be 404
        end

        it "test invalid request (updating type from another account)" do
            login_admin
            create_account

            other_main_account = Account.create!(id: Account.order(id: :asc).last.id + 1)
            other_help_account = CloudHelp::Account.create!(id: other_main_account.id)
            ticket_type = CloudHelp::TicketType.create!(
                name: Faker::Verb.base,
                account: other_help_account
            )

            request_json = {
                name: Faker::Verb.base
            }.to_json
            headers = json_headers

            put "/help/ticket_types/#{ticket_type.id}", params: request_json, headers: headers

            expect(response.status).to be 404
        end
    end

    describe "DESTROY integration test" do

        it "test valid request" do
            login_admin
            create_account

            ticket_type = CloudHelp::TicketType.create!(
                name: Faker::Verb.base,
                account: @account
            )

            delete "/help/ticket_types/#{ticket_type.id}"
            response_json = JSON.parse(response.body)

            expect(response.status).to be 200
            expect(response_json["successful"]).to be true
        end

        it "test invalid request (non-existent type)" do
            login_admin
            create_account

            delete "/help/ticket_types/#{Faker::Number.number(digits: 10)}"
            response_json = JSON.parse(response.body)

            expect(response.status).to be 404
        end

        it "test invalid request (ticket associated to type)" do
            login_admin
            create_account

            sla = CloudHelp::Sla.create!(
                name: Faker::Verb.base,
                account: @account
            )
            ticket_priority = CloudHelp::TicketPriority.create!(
                name: Faker::Verb.base,
                weight: Faker::Number.number(digits: 6),
                account: @account
            )
            ticket_source = CloudHelp::TicketSource.create!(
                name: Faker::Verb.base,
                account: @account
            )
            ticket_category = CloudHelp::TicketCategory.create!(
                name: Faker::Verb.base,
                account: @account
            )
            ticket_type = CloudHelp::TicketType.create!(
                name: Faker::Verb.base,
                account: @account
            )
            workflow_state = CloudHelp::WorkflowState.create!(
                name: Faker::Verb.base,
                account: @account
            )
            workflow = CloudHelp::Workflow.create!(
                name: Faker::Verb.base,
                account: @account,
                default: true
            )
            workflow.details.create!(
                workflow_state: workflow_state
            )
            ticket = CloudHelp::Ticket.create!(
                account: @account,
                user: @user,
                detail_attributes: {
                    priority: ticket_priority,
                    source: ticket_source,
                    type: ticket_type,
                    category: ticket_category,
                    workflow_detail: workflow.details.first
                }
            )

            delete "/help/ticket_types/#{ticket_type.id}"
            response_json = JSON.parse(response.body)

            expect(response.status).to be 200
            expect(response_json["successful"]).to be false
        end

        it "test invalid request (deleting type from another account)" do
            login_admin
            create_account

            other_main_account = Account.create!(id: Account.order(id: :asc).last.id + 1)
            other_help_account = CloudHelp::Account.create!(id: other_main_account.id)
            ticket_type = CloudHelp::TicketType.create!(
                name: Faker::Verb.base,
                account: other_help_account
            )

            delete "/help/ticket_types/#{ticket_type.id}"

            expect(response.status).to be 404
        end
    end
end
