require 'rails_helper'

RSpec.describe "CloudHouse::Catalog::ProjectTypes", type: :request do
    include Devise::Test::IntegrationHelpers

    def login_admin
        @user = User.find_by(email: "admin@lesli.cloud")
        sign_in @user
    end

    def create_account
        if @user.account.house
            @account = @user.account.house
        else
            @account = CloudHouse::Account.new(id: @user.account.id)
        end
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

            get "/house/catalog/project_types.json"
            response_json = JSON.parse(response.body)

            expect(response.status).to be 200
            expect(response.headers["Content-Type"]).to eq "application/json; charset=utf-8"
            expect(response_json["successful"]).to be true
        end
        
        it "test http html response" do
            login_admin

            get "/house/catalog/project_types.html"
        
            expect(response.status).to be 200
            expect(response.headers["Content-Type"]).to eq "text/html; charset=utf-8"
        end
    end


    describe "SHOW integration test" do

        it "test http html response" do
            login_admin
            create_account

            project_type = CloudHouse::Catalog::ProjectType.create!(
                name: Faker::Verb.base,
                account: @account
            )

            get "/house/catalog/project_types/#{project_type.id}.html"
            expect(response.status).to be 200
            expect(response.headers["Content-Type"]).to eq "text/html; charset=utf-8"
        end

        it "test valid request" do
            login_admin
            create_account

            project_type = CloudHouse::Catalog::ProjectType.create!(
                name: Faker::Verb.base,
                account: @account
            )

            get "/house/catalog/project_types/#{project_type.id}.json"
            response_json = JSON.parse(response.body)

            expect(response.status).to be 200
            expect(response.headers["Content-Type"]).to eq "application/json; charset=utf-8"
            expect(response_json["successful"]).to be true
        end

        it "test invalid request (non-existent type)" do
            login_admin
            create_account

            get "/house/catalog/project_types/#{Faker::Number.number(digits: 6)}.json"
            response_json = JSON.parse(response.body)

            expect(response.status).to be 404
        end

        it "test invalid request (requesting type from another account)" do
            login_admin
            create_account

            other_account = Account.create!(id: Account.order(id: :asc).last.id + 1)
            project_type = CloudHouse::Catalog::ProjectType.create!(
                name: Faker::Verb.base,
                account: other_account.house
            )

            get "/house/catalog/project_types/#{project_type.id}.json"
            response_json = JSON.parse(response.body)

            expect(response.status).to be 404
        end
    end

    describe "NEW integration test" do

        it "test http html response" do
            login_admin

            get "/house/catalog/project_types/new.html"

            expect(response.status).to be 200
            expect(response.headers["Content-Type"]).to eq "text/html; charset=utf-8"
        end
    end


    describe "EDIT integration test " do

        it "test http html response" do
            login_admin

            get "/house/catalog/project_types/edit.html"

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

            post "/house/catalog/project_types", params: request_json, headers: headers
            response_json = JSON.parse(response.body)
            
            expect(response.status).to be 200
            expect(response.headers["Content-Type"]).to eq "application/json; charset=utf-8"
            expect(response_json["successful"]).to be true
        end

        it "test invalid request (no name)" do
            login_admin

            request_json = { }.to_json
            headers = json_headers

            post "/house/catalog/project_types", params: request_json, headers: headers
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

            project_type = CloudHouse::Catalog::ProjectType.create!(
                name: Faker::Verb.base,
                account: @account
            )
            request_json = {
                name: Faker::Verb.base
            }.to_json
            headers = json_headers

            put "/house/catalog/project_types/#{project_type.id}", params: request_json, headers: headers
            response_json = JSON.parse(response.body)

            expect(response.status).to be 200
            expect(response.headers["Content-Type"]).to eq "application/json; charset=utf-8"
            expect(response_json["successful"]).to be true
        end

        it "test invalid request (name changed to nil)" do
            login_admin
            create_account

            project_type = CloudHouse::Catalog::ProjectType.create!(
                name: Faker::Verb.base,
                account: @account
            )
            request_json = {
                name: nil
            }.to_json
            headers = json_headers

            put "/house/catalog/project_types/#{project_type.id}", params: request_json, headers: headers
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

            put "/house/catalog/project_types/#{Faker::Number.number(digits: 10)}", params: request_json, headers: headers
            response_json = JSON.parse(response.body)

            expect(response.status).to be 404
        end

        it "test invalid request (updating type from another account)" do
            login_admin
            create_account

            other_account = Account.create!(id: Account.order(id: :asc).last.id + 1)
            project_type = CloudHouse::Catalog::ProjectType.create!(
                name: Faker::Verb.base,
                account: other_account.house
            )

            request_json = {
                name: Faker::Verb.base
            }.to_json
            headers = json_headers

            put "/house/catalog/project_types/#{project_type.id}", params: request_json, headers: headers

            expect(response.status).to be 404
        end
    end

    describe "DESTROY integration test" do

        it "test valid request" do
            login_admin
            create_account

            project_type = CloudHouse::Catalog::ProjectType.create!(
                name: Faker::Verb.base,
                account: @account
            )

            delete "/house/catalog/project_types/#{project_type.id}"
            response_json = JSON.parse(response.body)

            expect(response.status).to be 200
            expect(response_json["successful"]).to be true
        end

        it "test invalid request (non-existent type)" do
            login_admin
            create_account

            delete "/house/catalog/project_types/#{Faker::Number.number(digits: 10)}"
            response_json = JSON.parse(response.body)

            expect(response.status).to be 404
        end

        it "test invalid request (project associated to type)" do
            login_admin
            create_account

            project_type = CloudHouse::Catalog::ProjectType.create!(
                name: Faker::Verb.base,
                account: @account
            )
            workflow_state = CloudHouse::WorkflowState.create!(
                name: Faker::Verb.base,
                account: @account
            )
            project_workflow = CloudHouse::Workflow.create!(
                name:  Faker::Verb.base,
                default: true,
                account: @account
            )
            project_workflow.details.create!(
                workflow_state: workflow_state
            )
            project = CloudHouse::Project.create!(
                account: @account,
                detail_attributes: {
                    type: project_type,
                    workflow_detail: project_workflow.details.first
                }
            )

            delete "/house/catalog/project_types/#{project_type.id}"
            response_json = JSON.parse(response.body)

            expect(response.status).to be 200
            expect(response_json["successful"]).to be false
        end

        it "test invalid request (deleting type from another account)" do
            login_admin
            create_account

            other_account = Account.create!(id: Account.order(id: :asc).last.id + 1)
            project_type = CloudHouse::Catalog::ProjectType.create!(
                name: Faker::Verb.base,
                account: other_account.house
            )

            delete "/house/catalog/project_types/#{project_type.id}"

            expect(response.status).to be 404
        end
    end
end
