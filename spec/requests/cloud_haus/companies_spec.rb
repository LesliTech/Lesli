require 'rails_helper'

RSpec.describe "CloudHaus::Companies", type: :request do
    include Devise::Test::IntegrationHelpers

    def login_admin
        @user = User.find_by(email: "hello@lesli.cloud")
        sign_in @user
    end

    def create_account
        if @user.account.house
            @account = @user.account.house
        else
            @account = CloudHouse::Account.new(id: @user.account.id)
        end
    end

    def create_company(account = nil)
        account = @account unless account
        create_company_props
        company = CloudHouse::Company.create!(
            account: account,
            status: @workflow_status,
            company_category: @catalog_company_category
        )
        return company
    end

    def create_company_props
        workflow = CloudHouse::Workflow.create!(
            account: @account,
            name:  Faker::Verb.base,
            default: true
        )
        @workflow_status = CloudHouse::Workflow::Status.create!(
            name: Faker::Verb.base,
            workflow: workflow
        )
        @catalog_company_category = CloudHouse::Catalog::CompanyCategory.create!(
            account: @account,
            name: Faker::Verb.base
        )
    end

    def json_headers
        {
            "Content-Type" => "application/json",
            "Accept" => "application/json"
        }
    end
    
    def path
        "/crm/companies"
    end
    

    describe "INDEX integration test" do  

        it "test http json response" do
            login_admin

            get "#{path}.json"
            response_json = JSON.parse(response.body)

            expect(response.status).to be 200
            expect(response.headers["Content-Type"]).to eq "application/json; charset=utf-8"
            expect(response_json["successful"]).to be true
        end
        
        it "test http html response" do
            login_admin
            
            get "#{path}.html"
        
            expect(response.status).to be 200
            expect(response.headers["Content-Type"]).to eq "text/html; charset=utf-8"
        end

    end


    describe "SHOW integration test" do

        it "test http html response" do
            login_admin
            create_account
            company = create_company

            get "#{path}/#{company.id}.html"
            
            expect(response.status).to be 200
            expect(response.headers["Content-Type"]).to eq "text/html; charset=utf-8"
        end

        it "test valid request" do
            login_admin
            create_account
            company = create_company

            get "#{path}/#{company.id}.json"
            response_json = JSON.parse(response.body)

            expect(response.status).to be 200
            expect(response.headers["Content-Type"]).to eq "application/json; charset=utf-8"
            expect(response_json["successful"]).to be true
        end

        it "test invalid request (non-existent company)" do
            login_admin
            create_account

            get "#{path}/#{Faker::Number.number(digits: 6)}.json"
            response_json = JSON.parse(response.body)

            expect(response.status).to be 404
        end

        it "test invalid request (requesting companies from another account)" do
            login_admin
            create_account
            other_account = Account.create!(id: Account.order(id: :asc).last.id + 1)
            company = create_company(other_account.house)

            get "#{path}/#{company.id}.json"
            response_json = JSON.parse(response.body)

            expect(response.status).to be 404
        end

    end

    describe "NEW integration test" do

        it "test http html response" do
            login_admin

            get "#{path}/new.html"

            expect(response.status).to be 200
            expect(response.headers["Content-Type"]).to eq "text/html; charset=utf-8"
        end
    end

    describe "EDIT integration test " do

        it "test http html response" do
            login_admin

            get "#{path}/edit.html"

            expect(response.status).to be 200
            expect(response.headers["Content-Type"]).to eq "text/html; charset=utf-8"
        end
    end

    describe "CREATE integration test" do

        it "test valid request" do
            login_admin
            create_account
            create_company_props

            request_json = {
                company: {
                    cloud_house_accounts_id: @account.id,
                    cloud_house_workflow_statuses_id: @workflow_status.id,
                    cloud_house_catalog_company_categories_id: @catalog_company_category.id,
                }
            }.to_json
            headers = json_headers

            post "#{path}", params: request_json, headers: headers
            response_json = JSON.parse(response.body)
            
            expect(response.status).to be 200
            expect(response.headers["Content-Type"]).to eq "application/json; charset=utf-8"
            expect(response_json["successful"]).to be true
        end

        it "test invalid request (no props)" do
            login_admin
            create_account
            create_company_props

            request_json = {
                company: {
                    cloud_house_accounts_id: @account.id,
                    cloud_house_workflow_statuses_id: nil,
                    cloud_house_catalog_company_categories_id: nil
                }
            }.to_json
            headers = json_headers

            post "#{path}", params: request_json, headers: headers
            response_json = JSON.parse(response.body)

            expect(response.status).to be 200
            expect(response.headers["Content-Type"]).to eq "application/json; charset=utf-8"
            expect(response_json["successful"]).to be false
        end
    end

    describe "DESTROY integration test" do

        it "test valid request" do
            login_admin
            create_account
            company = create_company

            delete "#{path}/#{company.id}"
            response_json = JSON.parse(response.body)
            
            expect(response.status).to be 200
            expect(response_json["successful"]).to be true
        end

        it "test invalid request (non-existent company)" do
            login_admin
            create_account

            delete "#{path}/#{Faker::Number.number(digits: 10)}"
            response_json = JSON.parse(response.body)
            expect(response.status).to be 404
        end

        it "test invalid request (deleting company from another account)" do
            login_admin
            create_account
            other_account = Account.create!(id: Account.order(id: :asc).last.id + 1)
            company = create_company(other_account.house)

            delete "#{path}/#{company.id}"

            expect(response.status).to be 404
        end

    end

    describe "UPDATE integration test" do

        it "test valid request" do
            login_admin
            create_account
            create_company_props
            company = create_company

            request_json = {
                company: {
                    cloud_house_accounts_id: @account.id,
                    cloud_house_workflow_statuses_id: @workflow_status.id,
                    cloud_house_catalog_company_categories_id: @catalog_company_category.id
                }
            }.to_json
            headers = json_headers

            put "#{path}/#{company.id}", params: request_json, headers: headers
            response_json = JSON.parse(response.body)

            expect(response.status).to be 200
            expect(response.headers["Content-Type"]).to eq "application/json; charset=utf-8"
            expect(response_json["successful"]).to be true
        end

        it "test invalid request (updating company from another account)" do
            login_admin
            create_account
            create_company_props
            other_account = Account.create!(id: Account.order(id: :asc).last.id + 1)
            company = create_company(other_account.house)

            request_json = {
                company: {
                    cloud_house_accounts_id: @account.id,
                    cloud_house_workflow_statuses_id: @workflow_status.id,
                    cloud_house_catalog_company_categories_id: @catalog_company_category.id
                }
            }.to_json
            headers = json_headers

            put "#{path}/#{company.id}", params: request_json, headers: headers
            expect(response.status).to be 404
        end

    end

end
