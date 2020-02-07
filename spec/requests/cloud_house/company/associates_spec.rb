require 'rails_helper'
require 'byebug'

RSpec.describe "House::employees", type: :request do
    
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

    def create_company(account=nil)
        @company = CloudHouse::Company.create(
            cloud_house_accounts_id: account.nil? ? @account.id : account.id 
        )        
    end

    def create_business_service(account=nil)
        @business_service = CloudHouse::Catalog::BusinessService.create(
            name: Faker::Verb.base,
            cloud_house_accounts_id: account.nil? ? @account.id : account.id
        )        
    end
    
    def create_employee(account=nil)
        create_company(account)
        @employee = CloudHouse::Employee.create(
            cloud_house_accounts_id: account.nil? ? @account.id : account.id,
            cloud_house_companies_id: @company.id
        )        
    end

    def create_service(account=nil)
        create_business_service(account)
        create_employee(account)
        @service = CloudHouse::Employee::Service.create(cloud_house_employees_id: @employee.id, cloud_house_catalog_business_services_id: @business_service.id)
    end

    def create_associate(account=nil)
        create_service(account)
        CloudHouse::Company::Associate.create(cloud_house_employee_services_id: @service.id, cloud_house_companies_id: @company.id)
    end

    def json_headers
        {
            "Content-Type" => "application/json",
            "Accept" => "application/json"
        }
    end
    
    def path
        "/house/companies/#{@company.id}/associates"
    end
    
    describe "INDEX integration test" do  

        it "test http json response" do
            login_admin
            create_account
            create_company

            get "#{path}.json"
            response_json = JSON.parse(response.body)

            expect(response.status).to be 200
            expect(response.headers["Content-Type"]).to eq "application/json; charset=utf-8"
            expect(response_json["successful"]).to be true
        end
        
        it "test http html response" do
            login_admin
            create_account
            create_company
            
            get "#{path}.html"
        
            expect(response.status).to be 200
            expect(response.headers["Content-Type"]).to eq "text/html; charset=utf-8"
        end
    end

    describe "SHOW integration test" do

        it "test http html response" do
            login_admin
            create_account
            create_company

            get "#{path}.html"
            expect(response.status).to be 200
            expect(response.headers["Content-Type"]).to eq "text/html; charset=utf-8"
        end

        it "test valid request" do
            login_admin
            create_account
            associate = create_associate
            
            get "#{path}/#{associate.id}.json"
            response_json = JSON.parse(response.body)

            expect(response.status).to be 200
            expect(response.headers["Content-Type"]).to eq "application/json; charset=utf-8"
            expect(response_json["successful"]).to be true
        end

        it "test invalid request (non-existent associate)" do
            login_admin
            create_account
            create_company

            get "#{path}/#{Faker::Number.number(digits: 6)}.json"
            response_json = JSON.parse(response.body)

            expect(response.status).to be 404
        end

        it "test invalid request (requesting services from another account)" do
            login_admin
            create_account

            other_account = Account.create!(id: Account.order(id: :asc).last.id + 1)
            associate = create_associate(other_account.house)
            
            get "#{path}/#{associate.id}.json"
            response_json = JSON.parse(response.body)

            expect(response.status).to be 404
        end
    end

    describe "NEW integration test" do

        it "test http html response" do
            login_admin
            create_account
            create_company

            get "#{path}/new.html"

            expect(response.status).to be 200
            expect(response.headers["Content-Type"]).to eq "text/html; charset=utf-8"
        end
    end

    describe "EDIT integration test " do

        it "test http html response" do
            login_admin
            create_account
            create_company

            get "#{path}/edit.html"

            expect(response.status).to be 200
            expect(response.headers["Content-Type"]).to eq "text/html; charset=utf-8"
        end
    end

    describe "CREATE integration test" do

        it "test valid request" do
            login_admin
            create_account
            create_service

            request_json = {
                company_id: @company.id,
                associate: {
                    cloud_house_employee_services_id: @service.id,
                }
            }.to_json
            headers = json_headers
            
            post "#{path}", params: request_json, headers: headers
            response_json = JSON.parse(response.body)
            
            expect(response.status).to be 200
            expect(response.headers["Content-Type"]).to eq "application/json; charset=utf-8"
            expect(response_json["successful"]).to be true
        end

        it "test invalid request (no cloud_house_employee_services_id)" do
            login_admin
            create_account
            create_service
            
            request_json = {
                company_id: @company.id,
                associate: {
                    cloud_house_employee_services_id: nil,
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
            associate = create_associate
            
            delete "#{path}/#{associate.id}"
            response_json = JSON.parse(response.body)
            
            expect(response.status).to be 200
            expect(response_json["successful"]).to be true
        end

        it "test invalid request (non-existent associate)" do
            login_admin
            create_account
            create_company
            puts "here"
            delete "#{path}/#{Faker::Number.number(digits: 10)}"
            response_json = JSON.parse(response.body)

            expect(response.status).to be 404
        end

        it "test invalid request (deleting associate from another account)" do
            login_admin
            create_account

            other_account = Account.create!(id: Account.order(id: :asc).last.id + 1)
            associate = create_associate(other_account.house)

            delete "#{path}/#{associate.id}"

            expect(response.status).to be 404
        end
    end

    describe "UPDATE integration test" do

        it "test valid request" do
            login_admin
            create_account
            associate = create_associate
            
            request_json = {
                company_id: @company.id,
                associate: {
                    cloud_house_employee_services_id: @service.id,
                }
            }.to_json
            headers = json_headers

            put "#{path}/#{associate.id}", params: request_json, headers: headers
            response_json = JSON.parse(response.body)

            expect(response.status).to be 200
            expect(response.headers["Content-Type"]).to eq "application/json; charset=utf-8"
            expect(response_json["successful"]).to be true
        end

        it "test invalid request (updating associate from another account)" do
            login_admin
            create_account
            other_account = Account.create!(id: Account.order(id: :asc).last.id + 1)
            associate = create_associate(other_account.house)

            request_json = {
                company_id: @company.id,
                associate: {
                    cloud_house_employee_services_id: @employee.id,
                }
            }.to_json
            headers = json_headers

            put "#{path}/#{associate.id}", params: request_json, headers: headers
            expect(response.status).to be 404
        end
    end
end
