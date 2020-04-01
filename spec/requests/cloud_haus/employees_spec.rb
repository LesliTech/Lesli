require 'rails_helper'

RSpec.describe "CloudHouse::Employees", type: :request do
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

    def create_employee(account = nil)
        account = @account unless account
        create_employee_props
        employee = CloudHouse::Employee.create!(
            account: account,
            user: @user,
            company: @company,
            status: @workflow_status
        )
        return employee
    end

    def create_employee_props
        workflow = CloudHouse::Workflow.create!(
            account: @account,
            name:  Faker::Verb.base,
            default: true
        )
        @workflow_status = CloudHouse::Workflow::Status.create!(
            name: Faker::Verb.base,
            workflow: workflow
        )
        company_category = CloudHouse::Catalog::CompanyCategory.create!(
            account: @account,
            name: Faker::Verb.base
        )
        @company = CloudHouse::Company.create!(
            account: @account,
            status: @workflow_status,
            company_category: company_category
        )
    end

    def json_headers
        {
            "Content-Type" => "application/json",
            "Accept" => "application/json"
        }
    end
    
    def path
        "/crm/employees"
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
        
        # it "test http html response" do
        #     login_admin
            
        #     get "#{path}.html"
        
        #     expect(response.status).to be 200
        #     expect(response.headers["Content-Type"]).to eq "text/html; charset=utf-8"
        # end

    end

    describe "SHOW integration test" do

        # it "test http html response" do
        #     login_admin
        #     create_account
        #     employee = create_employee

        #     get "#{path}/#{employee.id}.html"
            
        #     expect(response.status).to be 200
        #     expect(response.headers["Content-Type"]).to eq "text/html; charset=utf-8"
        # end

        it "test valid request" do
            login_admin
            create_account
            employee = create_employee
            
            get "#{path}/#{employee.id}.json"
            response_json = JSON.parse(response.body)

            expect(response.status).to be 200
            expect(response.headers["Content-Type"]).to eq "application/json; charset=utf-8"
            expect(response_json["successful"]).to be true
        end

        it "test invalid request (non-existent employee)" do
            login_admin
            create_account

            get "#{path}/#{Faker::Number.number(digits: 6)}.json"
            response_json = JSON.parse(response.body)

            expect(response.status).to be 404
        end

        it "test invalid request (requesting employees from another account)" do
            login_admin
            create_account

            other_account = Account.create!(id: Account.order(id: :asc).last.id + 1)
            employee = create_employee(other_account.house)
            
            get "#{path}/#{employee.id}.json"
            response_json = JSON.parse(response.body)

            expect(response.status).to be 404
        end

    end

    describe "NEW integration test" do

        # it "test http html response" do
        #     login_admin

        #     get "#{path}/new.html"

        #     expect(response.status).to be 200
        #     expect(response.headers["Content-Type"]).to eq "text/html; charset=utf-8"
        # end
        
    end

    describe "EDIT integration test " do

        # it "test http html response" do
        #     login_admin

        #     get "#{path}/edit.html"

        #     expect(response.status).to be 200
        #     expect(response.headers["Content-Type"]).to eq "text/html; charset=utf-8"
        # end

    end

    describe "CREATE integration test" do

        it "test valid request" do
            login_admin
            create_account
            create_employee_props

            request_json = {
                employee: {
                    cloud_house_companies_id: @company.id,
                    detail_attributes: {
                        first_name: Faker::Verb::base
                    }
                }
            }.to_json
            headers = json_headers

            post "#{path}", params: request_json, headers: headers
            response_json = JSON.parse(response.body)
            
            expect(response.status).to be 200
            expect(response.headers["Content-Type"]).to eq "application/json; charset=utf-8"
            expect(response_json["successful"]).to be true
        end

        it "test invalid request (no company)" do
            login_admin
            create_account
            create_employee_props
            
            request_json = {
                employee: {
                    cloud_house_companies_id: nil,
                    detail_attributes: {}
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

        # it "test valid request" do
        #     login_admin
        #     create_account
        #     employee = create_employee
            
        #     delete "#{path}/#{employee.id}"
        #     response_json = JSON.parse(response.body)
            
        #     expect(response.status).to be 200
        #     expect(response_json["successful"]).to be true
        # end

        it "test invalid request (non-existent employee)" do
            login_admin
            create_account

            delete "#{path}/#{Faker::Number.number(digits: 10)}"
            response_json = JSON.parse(response.body)
            expect(response.status).to be 404
        end

        it "test invalid request (deleting employee from another account)" do
            login_admin
            create_account
            other_account = Account.create!(id: Account.order(id: :asc).last.id + 1)
            employee = create_employee(other_account.house)

            delete "#{path}/#{employee.id}"

            expect(response.status).to be 404
        end
        
    end

    describe "UPDATE integration test" do

        it "test valid request" do
            login_admin
            create_account
            employee = create_employee

            request_json = {
                employee: {
                    detail_attributes: {
                        first_name: Faker::Verb.base
                    }
                }
            }.to_json
            headers = json_headers

            put "#{path}/#{employee.id}", params: request_json, headers: headers
            response_json = JSON.parse(response.body)

            expect(response.status).to be 200
            expect(response.headers["Content-Type"]).to eq "application/json; charset=utf-8"
            expect(response_json["successful"]).to be true
        end

        it "test invalid request (updating employee from another account)" do
            login_admin
            create_account
            other_account = Account.create!(id: Account.order(id: :asc).last.id + 1)
            employee = create_employee(other_account.house)

            request_json = {
                employee: {
                    detail_attributes: {
                        first_name: Faker::Verb.base
                    }
                }
            }.to_json
            headers = json_headers

            put "#{path}/#{employee.id}", params: request_json, headers: headers
            expect(response.status).to be 404
        end

    end

end
