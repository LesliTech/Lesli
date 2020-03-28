require 'rails_helper'

RSpec.describe "CloudHaus::Projects", type: :request do
    include Devise::Test::IntegrationHelpers

    def login_admin
        # @user = User.find_by(email: "admin@lesli.cloud")
        @user = User.find_by(email: "crm.admin@deutsche-leibrenten.de")
        sign_in @user
    end

    def create_account
        if @user.account.house
            @account = @user.account.house
        else
            @account = CloudHouse::Account.new(id: @user.account.id)
        end
    end

    def create_project(account=nil)
        account = @account unless account
        workflow = CloudHouse::Workflow.create!(
            name:  Faker::Verb.base,
            default: true,
            account: account
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
            name: Faker::Verb.base,
            account: account
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
            main_employee: @user,
            detail_attributes: {}
        )
        return project
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

            get "/crm/projects.json"
            response_json = JSON.parse(response.body)

            expect(response.status).to be 200
            expect(response.headers["Content-Type"]).to eq "application/json; charset=utf-8"
            expect(response_json["successful"]).to be true
        end
        
        it "test http html response" do
            login_admin

            get "/crm/projects.html"
        
            expect(response.status).to be 200
            expect(response.headers["Content-Type"]).to eq "text/html; charset=utf-8"
        end
    end


    describe "SHOW integration test" do

        it "test http html response" do
            login_admin
            create_account
            
            project = create_project

            get "/crm/projects/#{project.id}.html"
            expect(response.status).to be 200
            expect(response.headers["Content-Type"]).to eq "text/html; charset=utf-8"
        end

    end


end