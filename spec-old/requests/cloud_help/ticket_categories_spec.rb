require 'rails_helper'

RSpec.describe "CloudHelp::TicketCategories", type: :request do
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

            get "/help/ticket_categories.json"
            response_json = JSON.parse(response.body)

            expect(response.status).to be 200
            expect(response.headers["Content-Type"]).to eq "application/json; charset=utf-8"
            expect(response_json["successful"]).to be true
        end
        
        it "test http html response" do
            login_admin

            get "/help/ticket_categories.html"
        
            expect(response.status).to be 200
            expect(response.headers["Content-Type"]).to eq "text/html; charset=utf-8"
        end
    end


    describe "SHOW integration test" do

        it "test http html response" do
            login_admin
            create_account

            ticket_category = CloudHelp::TicketCategory.create!(
                name: Faker::Verb.base,
                account: @account
            )

            get "/help/ticket_categories/#{ticket_category.id}.html"
            expect(response.status).to be 200
            expect(response.headers["Content-Type"]).to eq "text/html; charset=utf-8"
        end

        it "test valid request" do
            login_admin
            create_account

            ticket_category = CloudHelp::TicketCategory.create!(
                name: Faker::Verb.base,
                account: @account
            )

            get "/help/ticket_categories/#{ticket_category.id}.json"
            response_json = JSON.parse(response.body)

            expect(response.status).to be 200
            expect(response.headers["Content-Type"]).to eq "application/json; charset=utf-8"
            expect(response_json["successful"]).to be true
        end

        it "test invalid request (non-existent category)" do
            login_admin
            create_account

            get "/help/ticket_categories/#{Faker::Number.number(digits: 6)}.json"
            response_json = JSON.parse(response.body)

            expect(response.status).to be 404
        end

        it "test invalid request (requesting category from another account)" do
            login_admin
            create_account

            other_main_account = Account.create!(id: Account.order(id: :asc).last.id + 1)
            other_help_account = CloudHelp::Account.create!(id: other_main_account.id)
            ticket_category = CloudHelp::TicketCategory.create!(
                name: Faker::Verb.base,
                account: other_help_account
            )

            get "/help/ticket_categories/#{ticket_category.id}.json"
            response_json = JSON.parse(response.body)

            expect(response.status).to be 404
        end
    end

    describe "NEW integration test" do

        it "test http html response" do
            login_admin

            get "/help/ticket_categories/new.html"

            expect(response.status).to be 200
            expect(response.headers["Content-Type"]).to eq "text/html; charset=utf-8"
        end
    end


    describe "EDIT integration test " do

        it "test http html response" do
            login_admin

            get "/help/ticket_categories/edit.html"

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

            post "/help/ticket_categories", params: request_json, headers: headers
            response_json = JSON.parse(response.body)
            
            expect(response.status).to be 200
            expect(response.headers["Content-Type"]).to eq "application/json; charset=utf-8"
            expect(response_json["successful"]).to be true
        end

        it "test invalid request (no name)" do
            login_admin

            request_json = { }.to_json
            headers = json_headers

            post "/help/ticket_categories", params: request_json, headers: headers
            response_json = JSON.parse(response.body)

            expect(response.status).to be 200
            expect(response.headers["Content-Type"]).to eq "application/json; charset=utf-8"
            expect(response_json["successful"]).to be false
        end

        it "test invalid request (non-existent ancestry)" do
            login_admin

            request_json = {
                name: Faker::Verb.base,
                ancestry: "#{Faker::Number.number(digits: 6)}"
            }
            post "/help/ticket_categories", params: request_json, headers: headers
            response_json = JSON.parse(response.body)

            expect(response.status).to be 200
            expect(response.headers["Content-Type"]).to eq "application/json; charset=utf-8"
            expect(response_json["successful"]).to be false
        end

        it "test single workflow creation on category creation" do
            login_admin
            create_account
            CloudHelp::Sla.create!(
                name: Faker::Verb.base,
                body: Faker::Lorem.words(number: 30),
                expected_response_time: Faker::Number.number(digits: 2),
                expected_resolution_time: Faker::Number.number(digits: 2),
                default: true,
                account: @account
            )
            CloudHelp::TicketState.create!(
                name: Faker::Verb.base,
                initial: true,
                account: @account
            )
            CloudHelp::TicketState.create!(
                name: Faker::Verb.base,
                final: true,
                account: @account
            )
            ticket_type = CloudHelp::TicketType.create!(
                name: Faker::Verb.base,
                account: @account
            )
            request_json = {
                name: Faker::Verb.base
            }.to_json
            headers = json_headers

            post "/help/ticket_categories", params: request_json, headers: headers
            response_json = JSON.parse(response.body)

            expect(response.status).to be 200
            expect(response.headers["Content-Type"]).to eq "application/json; charset=utf-8"
            expect(response_json["successful"]).to be true
            expect(CloudHelp::TicketWorkflow.where(
                cloud_help_ticket_types_id: ticket_type.id,
                cloud_help_ticket_categories_id: response_json["data"]["id"]
            ).count).to be 1
        end

        it "test multiple workflow_creations on category creation" do
            login_admin
            create_account
            CloudHelp::Sla.create!(
                name: Faker::Verb.base,
                body: Faker::Lorem.words(number: 30),
                expected_response_time: Faker::Number.number(digits: 2),
                expected_resolution_time: Faker::Number.number(digits: 2),
                default: true,
                account: @account
            )
            CloudHelp::TicketState.create!(
                name: Faker::Verb.base,
                initial: true,
                account: @account
            )
            CloudHelp::TicketState.create!(
                name: Faker::Verb.base,
                final: true,
                account: @account
            )

            25.times do
                ticket_type = CloudHelp::TicketType.create!(
                    name: Faker::Verb.base,
                    account: @account
                )
                request_json = {
                    name: Faker::Verb.base
                }.to_json
                headers = json_headers

                post "/help/ticket_categories", params: request_json, headers: headers
                response_json = JSON.parse(response.body)

                expect(response.status).to be 200
                expect(response.headers["Content-Type"]).to eq "application/json; charset=utf-8"
                expect(response_json["successful"]).to be true
                expect(CloudHelp::TicketWorkflow.where(
                    cloud_help_ticket_types_id: ticket_type.id,
                    cloud_help_ticket_categories_id: response_json["data"]["id"]
                ).count).to be 1
            end
        end
    end


    describe "UPDATE integration test" do

        it "test valid request" do
            login_admin
            create_account

            ticket_category = CloudHelp::TicketCategory.create!(
                name: Faker::Verb.base,
                account: @account
            )
            request_json = {
                name: Faker::Verb.base
            }.to_json
            headers = json_headers

            put "/help/ticket_categories/#{ticket_category.id}", params: request_json, headers: headers
            response_json = JSON.parse(response.body)

            expect(response.status).to be 200
            expect(response.headers["Content-Type"]).to eq "application/json; charset=utf-8"
            expect(response_json["successful"]).to be true
        end

        it "test invalid request (name changed to nil)" do
            login_admin
            create_account

            ticket_category = CloudHelp::TicketCategory.create!(
                name: Faker::Verb.base,
                account: @account
            )
            request_json = {
                name: nil
            }.to_json
            headers = json_headers

            put "/help/ticket_categories/#{ticket_category.id}", params: request_json, headers: headers
            response_json = JSON.parse(response.body)

            expect(response.status).to be 200
            expect(response.headers["Content-Type"]).to eq "application/json; charset=utf-8"
            expect(response_json["successful"]).to be false
        end

        it "test invalid request (non-existent category)" do
            login_admin
            create_account

            request_json = {
                name: Faker::Verb.base
            }.to_json
            headers = json_headers

            put "/help/ticket_categories/#{Faker::Number.number(digits: 10)}", params: request_json, headers: headers
            response_json = JSON.parse(response.body)

            expect(response.status).to be 404
        end

        it "test invalid request (updating category from another account)" do
            login_admin
            create_account

            other_main_account = Account.create!(id: Account.order(id: :asc).last.id + 1)
            other_help_account = CloudHelp::Account.create!(id: other_main_account.id)
            ticket_category = CloudHelp::TicketCategory.create!(
                name: Faker::Verb.base,
                account: other_help_account
            )

            request_json = {
                name: Faker::Verb.base
            }.to_json
            headers = json_headers

            put "/help/ticket_categories/#{ticket_category.id}", params: request_json, headers: headers

            expect(response.status).to be 404
        end
    end

    describe "DESTROY integration test" do

        it "test valid request" do
            login_admin
            create_account

            ticket_category = CloudHelp::TicketCategory.create!(
                name: Faker::Verb.base,
                account: @account
            )

            delete "/help/ticket_categories/#{ticket_category.id}"
            response_json = JSON.parse(response.body)

            expect(response.status).to be 200
            expect(response_json["successful"]).to be true
        end

        it "test valid request (destroying parent to delete children)" do
            login_admin
            create_account

            ticket_category = CloudHelp::TicketCategory.create!(
                name: Faker::Verb.base,
                account: @account
            )

            child_category = CloudHelp::TicketCategory.create!(
                name: Faker::Verb.base,
                parent: ticket_category,
                account: @account
            )

            delete "/help/ticket_categories/#{ticket_category.id}"
            response_json = JSON.parse(response.body)

            expect(response.status).to be 200
            expect(response_json["successful"]).to be true
            expect(CloudHelp::TicketCategory.find_by(id: ticket_category.id)).to be nil
            expect(CloudHelp::TicketCategory.find_by(id: child_category.id)).to be nil
        end

        it "test invalid request (ticket associated to child category)" do
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
            child_category = CloudHelp::TicketCategory.create!(
                name: Faker::Verb.base,
                parent: ticket_category,
                account: @account
            )
            ticket_type = CloudHelp::TicketType.create!(
                name: Faker::Verb.base,
                account: @account
            )
            ticket_state = CloudHelp::TicketState.create!(
                name: Faker::Verb.base,
                account: @account
            )
            ticket_workflow = CloudHelp::TicketWorkflow.create!(
                ticket_category: child_category,
                ticket_type: ticket_type,
                sla: sla
            )
            ticket_workflow.details.create!(
                ticket_state: ticket_state
            )
            ticket = CloudHelp::Ticket.create!(
                account: @account,
                user: @user,
                detail_attributes: {
                    priority: ticket_priority,
                    source: ticket_source,
                    type: ticket_type,
                    category: ticket_category,
                    workflow_detail: ticket_workflow.details.first
                }
            )

            delete "/help/ticket_categories/#{ticket_category.id}"
            response_json = JSON.parse(response.body)

            expect(response.status).to be 200
            expect(response_json["successful"]).to be false
            expect(CloudHelp::TicketCategory.find_by(id: ticket_category.id)).not_to be nil
            expect(CloudHelp::TicketCategory.find_by(id: child_category.id)).not_to be nil
        end

        it "test invalid request (non-existent category)" do
            login_admin
            create_account

            delete "/help/ticket_categories/#{Faker::Number.number(digits: 10)}"
            response_json = JSON.parse(response.body)

            expect(response.status).to be 404
        end

        it "test invalid request (ticket associated to category)" do
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
            ticket_state = CloudHelp::TicketState.create!(
                name: Faker::Verb.base,
                account: @account
            )
            ticket_workflow = CloudHelp::TicketWorkflow.create!(
                ticket_category: ticket_category,
                ticket_type: ticket_type,
                sla: sla
            )
            ticket_workflow.details.create!(
                ticket_state: ticket_state
            )
            ticket = CloudHelp::Ticket.create!(
                account: @account,
                user: @user,
                detail_attributes: {
                    priority: ticket_priority,
                    source: ticket_source,
                    type: ticket_type,
                    category: ticket_category,
                    workflow_detail: ticket_workflow.details.first
                }
            )

            delete "/help/ticket_categories/#{ticket_category.id}"
            response_json = JSON.parse(response.body)

            expect(response.status).to be 200
            expect(response_json["successful"]).to be false
        end

        it "test invalid request (deleting category from another account)" do
            login_admin
            create_account

            other_main_account = Account.create!(id: Account.order(id: :asc).last.id + 1)
            other_help_account = CloudHelp::Account.create!(id: other_main_account.id)
            ticket_category = CloudHelp::TicketCategory.create!(
                name: Faker::Verb.base,
                account: other_help_account
            )

            delete "/help/ticket_categories/#{ticket_category.id}"

            expect(response.status).to be 404
        end
    end
end
