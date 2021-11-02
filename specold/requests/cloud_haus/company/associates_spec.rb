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

    def create_associate(account = nil)
        account = @account unless account
        create_associate_props(account)
        associate = CloudHouse::Company::Associate.create!(
            service: @service, 
            company: @company
        )
        return associate
    end

    def create_associate_props(account = nil)
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
        company_category = CloudHouse::Catalog::CompanyCategory.create!(
            account: account,
            name: Faker::Verb.base
        )
        @company = CloudHouse::Company.create!(
            account: account,
            status: workflow_status,
            company_category: company_category
        )
        business_service = CloudHouse::Catalog::BusinessService.create!(
            account: account,
            name: Faker::Verb.base
        )
        employee = CloudHouse::Employee.create!(
            account: account,
            company: @company
        )
        @service = CloudHouse::Employee::Service.create!(
            employee: employee, 
            business_service: business_service
        )
    end

    def json_headers
        {
            "Content-Type" => "application/json",
            "Accept" => "application/json"
        }
    end
    
    def path
        return "/crm/companies/#{@company.id}/associates"
    end
    
    describe "INDEX integration test" do  

        it "test http json response" do
            login_admin
            create_account
            create_associate_props

            get "#{path}.json"
            response_json = JSON.parse(response.body)

            expect(response.status).to be 200
            expect(response.headers["Content-Type"]).to eq "application/json; charset=utf-8"
            expect(response_json["successful"]).to be true
        end
        
        # it "test http html response" do
        #     login_admin
        #     create_account
        #     create_associate_props
            
        #     get "#{path}.html"
        
        #     expect(response.status).to be 200
        #     expect(response.headers["Content-Type"]).to eq "text/html; charset=utf-8"
        # end

    end

    describe "SHOW integration test" do

        # it "test http html response" do
        #     login_admin
        #     create_account
        #     create_associate_props

        #     get "#{path}.html"

        #     expect(response.status).to be 200
        #     expect(response.headers["Content-Type"]).to eq "text/html; charset=utf-8"
        # end

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
            create_associate_props

            get "#{path}/#{Faker::Number.number(digits: 6)}.json"
            response_json = JSON.parse(response.body)

            expect(response.status).to be 404
        end

        # it "test invalid request (requesting services from another account)" do
        #     login_admin
        #     create_account
        #     other_account = Account.create!(id: Account.order(id: :asc).last.id + 1)
        #     associate = create_associate(other_account.house)
            
        #     get "#{path}/#{associate.id}.json"
        #     response_json = JSON.parse(response.body)

        #     expect(response.status).to be 404
        # end

    end

    describe "NEW integration test" do

        # it "test http html response" do
        #     login_admin
        #     create_account
        #     create_associate_props

        #     get "#{path}/new.html"

        #     expect(response.status).to be 200
        #     expect(response.headers["Content-Type"]).to eq "text/html; charset=utf-8"
        # end

    end

    describe "EDIT integration test " do

        # it "test http html response" do
        #     login_admin
        #     create_account
        #     create_associate_props

        #     get "#{path}/edit.html"

        #     expect(response.status).to be 200
        #     expect(response.headers["Content-Type"]).to eq "text/html; charset=utf-8"
        # end

    end

    describe "CREATE integration test" do

        it "test valid request" do
            login_admin
            create_account
            create_associate_props

            request_json = {
                company_id: @company.id,
                cloud_house_accounts_id: @account.id,
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
            create_associate_props
            
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
            create_associate_props
            
            delete "#{path}/#{Faker::Number.number(digits: 10)}"
            response_json = JSON.parse(response.body)

            expect(response.status).to be 404
        end

        # it "test invalid request (deleting associate from another account)" do
        #     login_admin
        #     create_account
        #     other_account = Account.create!(id: Account.order(id: :asc).last.id + 1)
        #     create_associate(other_account.house)

        #     delete "#{path}/#{@associate.id}"

        #     expect(response.status).to be 404
        # end

    end

    describe "UPDATE integration test" do

        it "test valid request" do
            login_admin
            create_account
            associate = create_associate
            create_associate_props
            
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

        # it "test invalid request (updating associate from another account)" do
        #     login_admin
        #     create_account
        #     other_account = Account.create!(id: Account.order(id: :asc).last.id + 1)
        #     create_associate(other_account.house)

        #     request_json = {
        #         company_id: @company.id,
        #         associate: {
        #             cloud_house_employee_services_id: @service.id,
        #         }
        #     }.to_json
        #     headers = json_headers

        #     put "#{path}/#{@associate.id}", params: request_json, headers: headers
        #     expect(response.status).to be 404
        # end

    end

end
