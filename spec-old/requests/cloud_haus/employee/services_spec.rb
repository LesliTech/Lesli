require 'rails_helper'

RSpec.describe "CloudHaus::Employees", type: :request do
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

    def create_service(account = nil)
        account = @account unless account
        create_service_props(account)
        service = CloudHouse::Employee::Service.create!(
            employee: @employee, 
            business_service: @business_service
        )
        return service
    end

    def create_service_props(account = nil)
        account = @account unless account
        create_employee(account)
        create_business_service(account)
    end

    def create_employee(account = nil)
        account = @account unless account
        workflow = CloudHouse::Workflow.create!(
            account: account,
            name:  Faker::Verb.base,
            default: true
        )
        workflow_status = CloudHouse::Workflow::Status.create!(
            name: Faker::Verb.base,
            workflow: workflow
        )
        catalog_company_category = CloudHouse::Catalog::CompanyCategory.create!(
            account: account,
            name: Faker::Verb.base
        )
        company = CloudHouse::Company.create!(
            account: account,
            status: workflow_status,
            company_category: catalog_company_category
        )
        @employee = CloudHouse::Employee.create!(
            account: account,
            company: company
        )
    end

    def create_business_service(account = nil)
        account = @account unless account
        @business_service = CloudHouse::Catalog::BusinessService.create!(
            account: account,
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
        "/crm/employees/#{@employee.id}/services"
    end
    
    describe "INDEX integration test" do  

        it "test http json response" do
            login_admin
            create_account
            create_employee

            get "#{path}.json"
            response_json = JSON.parse(response.body)

            expect(response.status).to be 200
            expect(response.headers["Content-Type"]).to eq "application/json; charset=utf-8"
            expect(response_json["successful"]).to be true
        end
        
        # it "test http html response" do
        #     login_admin
        #     create_account
        #     create_employee
            
        #     get "#{path}.html"
        
        #     expect(response.status).to be 200
        #     expect(response.headers["Content-Type"]).to eq "text/html; charset=utf-8"
        # end
        
    end

    describe "SHOW integration test" do

        # it "test http html response" do
        #     login_admin
        #     create_account
        #     service = create_service

        #     get "#{path}/#{service.id}.html"

        #     expect(response.status).to be 200
        #     expect(response.headers["Content-Type"]).to eq "text/html; charset=utf-8"
        # end

        it "test valid request" do
            login_admin
            create_account
            service = create_service
            
            get "#{path}/#{service.id}.json"
            response_json = JSON.parse(response.body)

            expect(response.status).to be 200
            expect(response.headers["Content-Type"]).to eq "application/json; charset=utf-8"
            expect(response_json["successful"]).to be true
        end

        it "test invalid request (non-existent service)" do
            login_admin
            create_account
            create_employee

            get "#{path}/#{Faker::Number.number(digits: 6)}.json"
            response_json = JSON.parse(response.body)

            expect(response.status).to be 404
        end

        # it "test invalid request (requesting services from another account)" do
        #     login_admin
        #     create_account
        #     other_account = Account.create!(id: Account.order(id: :asc).last.id + 1)
        #     service = create_service(other_account.house)
            
        #     get "#{path}/#{service.id}.json"
        #     response_json = JSON.parse(response.body)

        #     expect(response.status).to be 404
        # end

    end

    describe "NEW integration test" do

        # it "test http html response" do
        #     login_admin
        #     create_account
        #     create_employee

        #     get "#{path}/new.html"

        #     expect(response.status).to be 200
        #     expect(response.headers["Content-Type"]).to eq "text/html; charset=utf-8"
        # end

    end

    describe "EDIT integration test " do

        # it "test http html response" do
        #     login_admin
        #     create_account
        #     create_employee

        #     get "#{path}/edit.html"

        #     expect(response.status).to be 200
        #     expect(response.headers["Content-Type"]).to eq "text/html; charset=utf-8"
        # end

    end

    describe "CREATE integration test" do

        it "test valid request" do
            login_admin
            create_account
            create_employee
            create_business_service
            
            request_json = {
                employee_id: @employee.id,
                service: {
                    cloud_house_catalog_business_services_id: @business_service.id,
                }
            }.to_json
            headers = json_headers
            
            post "#{path}", params: request_json, headers: headers
            response_json = JSON.parse(response.body)
            
            expect(response.status).to be 200
            expect(response.headers["Content-Type"]).to eq "application/json; charset=utf-8"
            expect(response_json["successful"]).to be true
        end

        it "test invalid request (no cloud_house_catalog_business_services_id)" do
            login_admin
            create_account
            create_employee
            
            request_json = {
                employee_id: @employee.id,
                service: {
                    cloud_house_catalog_business_services_id: nil
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
            service = create_service
            
            delete "#{path}/#{service.id}"
            response_json = JSON.parse(response.body)
            
            expect(response.status).to be 200
            expect(response_json["successful"]).to be true
        end

        it "test invalid request (non-existent service)" do
            login_admin
            create_account
            create_employee

            delete "#{path}/#{Faker::Number.number(digits: 10)}"
            response_json = JSON.parse(response.body)

            expect(response.status).to be 404
        end

        # it "test invalid request (deleting service from another account)" do
        #     login_admin
        #     create_account
        #     other_account = Account.create!(id: Account.order(id: :asc).last.id + 1)
        #     service = create_service(other_account.house)

        #     delete "#{path}/#{service.id}"

        #     expect(response.status).to be 404
        # end
    end

    describe "UPDATE integration test" do

        it "test valid request" do
            login_admin
            create_account
            service = create_service
            create_service_props
            
            request_json = {
                employee_id: @employee.id,
                service: {
                    cloud_house_catalog_business_services_id: @business_service.id
                }
            }.to_json
            headers = json_headers

            put "#{path}/#{service.id}", params: request_json, headers: headers
            response_json = JSON.parse(response.body)

            expect(response.status).to be 200
            expect(response.headers["Content-Type"]).to eq "application/json; charset=utf-8"
            expect(response_json["successful"]).to be true
        end

        # it "test invalid request (updating service from another account)" do
        #     login_admin
        #     create_account
        #     other_account = Account.create!(id: Account.order(id: :asc).last.id + 1)
        #     service = create_service(other_account.house)
        #     create_service_props

        #     request_json = {
        #         employee_id: @employee.id,
        #         service: {
        #             cloud_house_catalog_business_services_id: @business_service.id
        #         }
        #     }.to_json
        #     headers = json_headers

        #     put "#{path}/#{service.id}", params: request_json, headers: headers
        #     expect(response.status).to be 404
        # end

    end

end
