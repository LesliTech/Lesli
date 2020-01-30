require 'rails_helper'

RSpec.describe "CloudHouse::Projects", type: :request do
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

    def create_project(account=nil)
        account = @account unless account
        project_type = CloudHouse::Catalog::ProjectType.create!(
            name: Faker::Verb.base,
            account: account
        )
        workflow_state = CloudHouse::WorkflowState.create!(
            name: Faker::Verb.base,
            account: account
        )
        project_workflow = CloudHouse::Workflow.create!(
            name:  Faker::Verb.base,
            default: true,
            account: account
        )
        project_workflow.details.create!(
            workflow_state: workflow_state
        )
        project = CloudHouse::Project.create!(
            account: account,
            detail_attributes: {
                type: project_type,
                workflow_detail: project_workflow.details.first
            }
        )
        return project
    end

    def create_project_workflow
        @project_type = CloudHouse::Catalog::ProjectType.create!(
            name: Faker::Verb.base,
            account: @account
        )
        @workflow_state_initial = CloudHouse::WorkflowState.create!(
            name: Faker::Verb.base,
            account: @account,
            initial: true
        )
        @workflow_state_final = CloudHouse::WorkflowState.create!(
            name: Faker::Verb.base,
            account: @account,
            initial: true
        )
        @workflow = CloudHouse::Workflow.create!(
            name:  Faker::Verb.base,
            default: true,
            account: @account
        )
        @workflow.details.create!(
            workflow_state: @workflow_state_initial,
            next_states: "#{@workflow_state_final.id}"
        )
        @workflow.details.create!(
            workflow_state: @workflow_state_final
        )
        @project_workflow = CloudHouse::ProjectWorkflow.create!(
            cloud_house_catalog_project_types_id: @project_type.id,
            cloud_house_workflows_id: @workflow.id,
            account: @account
        )
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

            get "/house/projects.json"
            response_json = JSON.parse(response.body)

            expect(response.status).to be 200
            expect(response.headers["Content-Type"]).to eq "application/json; charset=utf-8"
            expect(response_json["successful"]).to be true
        end
        
        it "test http html response" do
            login_admin

            get "/house/projects.html"
        
            expect(response.status).to be 200
            expect(response.headers["Content-Type"]).to eq "text/html; charset=utf-8"
        end
    end


    describe "SHOW integration test" do

        it "test http html response" do
            login_admin
            create_account
            
            project = create_project

            get "/house/projects/#{project.id}.html"
            expect(response.status).to be 200
            expect(response.headers["Content-Type"]).to eq "text/html; charset=utf-8"
        end

        it "test valid request" do
            login_admin
            create_account

            project = create_project

            get "/house/projects/#{project.id}.json"
            response_json = JSON.parse(response.body)

            expect(response.status).to be 200
            expect(response.headers["Content-Type"]).to eq "application/json; charset=utf-8"
            expect(response_json["successful"]).to be true
        end

        it "test invalid request (non-existent projects)" do
            login_admin
            create_account

            get "/house/projects/#{Faker::Number.number(digits: 6)}.json"
            response_json = JSON.parse(response.body)

            expect(response.status).to be 404
        end

        it "test invalid request (requesting projects from another account)" do
            login_admin
            create_account

            other_account = Account.create!(id: Account.order(id: :asc).last.id + 1)
            project = create_project(other_account.house)

            get "/house/projects/#{project.id}.json"
            response_json = JSON.parse(response.body)

            expect(response.status).to be 404
        end
    end

    describe "NEW integration test" do

        it "test http html response" do
            login_admin

            get "/house/projects/new.html"

            expect(response.status).to be 200
            expect(response.headers["Content-Type"]).to eq "text/html; charset=utf-8"
        end
    end


    describe "EDIT integration test " do

        it "test http html response" do
            login_admin

            get "/house/projects/edit.html"

            expect(response.status).to be 200
            expect(response.headers["Content-Type"]).to eq "text/html; charset=utf-8"
        end
    end


    describe "CREATE integration test" do

        it "test valid request" do
            login_admin
            create_account
            create_project_workflow

            request_json = {
                project: {
                    cloud_house_accounts_id: @account.id,
                    detail_attributes: {
                        cloud_house_catalog_project_types_id: @project_type.id
                    }
                }
            }.to_json
            headers = json_headers

            post "/house/projects", params: request_json, headers: headers
            response_json = JSON.parse(response.body)
            
            expect(response.status).to be 200
            expect(response.headers["Content-Type"]).to eq "application/json; charset=utf-8"
            expect(response_json["successful"]).to be true
        end

        it "test invalid request (no type)" do
            login_admin
            create_account

            request_json = {
                project: {
                    cloud_house_accounts_id: @account.id,
                    detail_attributes: {
                        cloud_house_catalog_project_types_id: nil
                    }
                }
            }.to_json
            headers = json_headers

            post "/house/projects", params: request_json, headers: headers
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
            create_project_workflow

            initial_workflow_detail = @workflow.details.find_by(workflow_state: @workflow_state_initial)
            project = CloudHouse::Project.create!(
                account: @account,
                detail_attributes: {
                    type: @project_type,
                    workflow_detail: initial_workflow_detail
                }
            )

            request_json = {
                project: {
                    detail_attributes: {
                        cloud_house_catalog_workflow_details_id: initial_workflow_detail.id
                    }
                }
            }.to_json
            headers = json_headers

            put "/house/projects/#{project.id}", params: request_json, headers: headers
            response_json = JSON.parse(response.body)

            expect(response.status).to be 200
            expect(response.headers["Content-Type"]).to eq "application/json; charset=utf-8"
            expect(response_json["successful"]).to be true
        end

        it "test invalid request (type changed to nil)" do
            login_admin
            create_account
            create_project_workflow

            initial_workflow_detail = @workflow.details.find_by(workflow_state: @workflow_state_initial)
            project = CloudHouse::Project.create!(
                account: @account,
                detail_attributes: {
                    type: @project_type,
                    workflow_detail: initial_workflow_detail
                }
            )

            request_json = {
                project: {
                    detail_attributes: {
                        cloud_house_catalog_project_types_id: nil
                    }
                }
            }.to_json
            headers = json_headers

            put "/house/projects/#{project.id}", params: request_json, headers: headers
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

            put "/house/projects/#{Faker::Number.number(digits: 10)}", params: request_json, headers: headers
            response_json = JSON.parse(response.body)

            expect(response.status).to be 404
        end

        it "test invalid request (updating project from another account)" do
            login_admin
            create_account
            create_project_workflow

            initial_workflow_detail = @workflow.details.find_by(workflow_state: @workflow_state_initial)
            other_account = Account.create!(id: Account.order(id: :asc).last.id + 1)
            project = CloudHouse::Project.create!(
                account: other_account.house,
                detail_attributes: {
                    type: @project_type,
                    workflow_detail: initial_workflow_detail
                }
            )

            request_json = {
                project: {
                    detail_attributes: {
                        cloud_house_catalog_workflow_details_id: initial_workflow_detail.id
                    }
                }
            }.to_json
            headers = json_headers

            put "/house/projects/#{project.id}", params: request_json, headers: headers

            expect(response.status).to be 404
        end
    end

    describe "DESTROY integration test" do

        it "test valid request" do
            login_admin
            create_account
            create_project_workflow

            initial_workflow_detail = @workflow.details.find_by(workflow_state: @workflow_state_initial)
            project = CloudHouse::Project.create!(
                account: @account,
                detail_attributes: {
                    type: @project_type,
                    workflow_detail: initial_workflow_detail
                }
            )

            delete "/house/projects/#{project.id}"
            response_json = JSON.parse(response.body)

            expect(response.status).to be 200
            expect(response_json["successful"]).to be true
        end

        it "test invalid request (non-existent project)" do
            login_admin
            create_account

            delete "/house/projects/#{Faker::Number.number(digits: 10)}"
            response_json = JSON.parse(response.body)

            expect(response.status).to be 404
        end

        it "test invalid request (deleting project from another account)" do
            login_admin
            create_account
            create_project_workflow

            initial_workflow_detail = @workflow.details.find_by(workflow_state: @workflow_state_initial)
            other_account = Account.create!(id: Account.order(id: :asc).last.id + 1)
            project = CloudHouse::Project.create!(
                account: other_account.house,
                detail_attributes: {
                    type: @project_type,
                    workflow_detail: initial_workflow_detail
                }
            )

            delete "/house/projects/#{project.id}"

            expect(response.status).to be 404
        end
    end
end
