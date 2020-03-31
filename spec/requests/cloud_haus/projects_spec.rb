require 'rails_helper'

RSpec.describe "CloudHaus::Projects", type: :request do
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

    def create_project(account = nil)
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
        property = CloudHouse::Property.create!(
            account: account,
            status: workflow_status
        )
        company_category = CloudHouse::Catalog::CompanyCategory.create!(
            account: account,
            name: Faker::Verb.base
        )
        company = CloudHouse::Company.create!(
            account: account,
            status: workflow_status,
            company_category: company_category
        )
        main_employee = CloudHouse::Employee.create!(
            account: account,
            company: company
        )
        project = CloudHouse::Project.create!(
            account: account,
            status: workflow_status,
            property: property,
            main_employee: @user
        )
        return project
    end

    def create_project_props
        workflow = CloudHouse::Workflow.create!(
            account: @account,
            name:  Faker::Verb.base,
            default: true
        )
        @workflow_status = CloudHouse::Workflow::Status.create!(
            name: Faker::Verb.base,
            workflow: workflow
        )
        @property = CloudHouse::Property.create!(
            account: @account,
            status: @workflow_status
        )
        company_category = CloudHouse::Catalog::CompanyCategory.create!(
            account: @account,
            name: Faker::Verb.base
        )
        company = CloudHouse::Company.create!(
            account: @account,
            status: @workflow_status,
            company_category: company_category
        )
        @main_employee = CloudHouse::Employee.create!(
            account: @account,
            company: company
        )
        @catalog_project_type = CloudHouse::Catalog::ProjectType.create!(
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
        "/crm/projects"
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
            project = create_project

            get "#{path}/#{project.id}.html"

            expect(response.status).to be 200
            expect(response.headers["Content-Type"]).to eq "text/html; charset=utf-8"
        end

        # it "test valid request" do
        #     login_admin
        #     create_account
        #     project = create_project

        #     get "#{path}/#{project.id}.json"
        #     response_json = JSON.parse(response.body)

        #     expect(response.status).to be 200
        #     expect(response.headers["Content-Type"]).to eq "application/json; charset=utf-8"
        #     expect(response_json["successful"]).to be true
        # end

        it "test invalid request (non-existent project)" do
            login_admin
            create_account

            get "#{path}/#{Faker::Number.number(digits: 6)}.json"
            response_json = JSON.parse(response.body)

            expect(response.status).to be 404
        end

        it "test invalid request (requesting projects from another account)" do
            login_admin
            create_account
            other_account = Account.create!(id: Account.order(id: :asc).last.id + 1)
            project = create_project(other_account.house)

            get "#{path}/#{project.id}.json"
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

        # it "test valid request" do
        #     login_admin
        #     create_account
        #     create_project_props

        #     request_json = {
        #         project: {
        #             cloud_house_accounts_id: @account.id,
        #             main_employee_id: @main_employee.id,
        #             cloud_house_catalog_project_types_id: @catalog_project_type.id,
        #             cloud_house_properties_id: @property.id,
        #             cloud_house_workflow_statuses_id: @workflow_status.id
        #         }
        #     }.to_json
        #     headers = json_headers

        #     post "#{path}", params: request_json, headers: headers
        #     response_json = JSON.parse(response.body)
            
        #     expect(response.status).to be 200
        #     expect(response.headers["Content-Type"]).to eq "application/json; charset=utf-8"
        #     expect(response_json["successful"]).to be true
        # end

        it "test invalid request (no props)" do
            login_admin
            create_account

            request_json = {
                project: {
                    main_employee_id: nil,
                    cloud_house_accounts_id: @account.id,
                    cloud_house_catalog_project_types_id: nil,
                    cloud_house_properties_id: nil,
                    cloud_house_workflow_statuses_id: nil
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


    describe "UPDATE integration test" do

        it "test valid request" do
            login_admin
            create_account
            create_project_props
            project = create_project

            request_json = {
                project: {
                    cloud_house_workflow_statuses_id: @workflow_status.id
                }
            }.to_json
            headers = json_headers

            put "#{path}/#{project.id}", params: request_json, headers: headers
            response_json = JSON.parse(response.body)

            expect(response.status).to be 200
            expect(response.headers["Content-Type"]).to eq "application/json; charset=utf-8"
            expect(response_json["successful"]).to be true
        end

        it "test invalid request (workflow status changed to nil)" do
            login_admin
            create_account
            # create_project_props
            project = create_project

            request_json = {
                project: {
                    cloud_house_workflow_statuses_id: nil
                }
            }.to_json
            headers = json_headers

            put "#{path}/#{project.id}", params: request_json, headers: headers
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

            put "#{path}/#{Faker::Number.number(digits: 10)}", params: request_json, headers: headers
            response_json = JSON.parse(response.body)

            expect(response.status).to be 404
        end

        it "test invalid request (updating project from another account)" do
            login_admin
            create_account
            create_project_props
            other_account = Account.create!(id: Account.order(id: :asc).last.id + 1)
            project = create_project(other_account.house)

            request_json = {
                project: {
                    cloud_house_workflow_statuses_id: @workflow_status.id
                }
            }.to_json
            headers = json_headers

            put "#{path}/#{project.id}", params: request_json, headers: headers

            expect(response.status).to be 404
        end

    end

    describe "DESTROY integration test" do

        # it "test valid request" do
        #     login_admin
        #     create_account
        #     project = create_project

        #     delete "#{path}/#{project.id}"
        #     response_json = JSON.parse(response.body)

        #     expect(response.status).to be 200
        #     expect(response_json["successful"]).to be true
        # end

        it "test invalid request (non-existent project)" do
            login_admin
            create_account

            delete "#{path}/#{Faker::Number.number(digits: 10)}"
            response_json = JSON.parse(response.body)

            expect(response.status).to be 404
        end

        it "test invalid request (deleting project from another account)" do
            login_admin
            create_account
            other_account = Account.create!(id: Account.order(id: :asc).last.id + 1)
            project = create_project(other_account.house)

            delete "#{path}/#{project.id}"
            response_json = JSON.parse(response.body)

            expect(response.status).to be 404
        end

    end

end