require 'rails_helper'
require 'byebug'

RSpec.describe "House::Companies", type: :request do
    
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
        CloudHouse::Company.create(
            cloud_house_accounts_id: account.nil? ? @account.id : account.id 
        )        
    end

    def json_headers
        {
            "Content-Type" => "application/json",
            "Accept" => "application/json"
        }
    end
    
    def path
        "/house/companies"
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
            get "#{path}.html"
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

            request_json = {
                company: {
                    detail_attributes: {
                        name: Faker::Verb::base
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

        it "test invalid request (no name)" do
            login_admin
            create_account

            request_json = {
                company: {
                    detail_attributes: {

                    }
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
            company = create_company

            request_json = {
                company: {
                    detail_attributes: {
                        name: Faker::Verb.base
                    }
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
            other_account = Account.create!(id: Account.order(id: :asc).last.id + 1)
            company = create_company(other_account.house)

            request_json = {
                company: {
                    detail_attributes: {
                        name: Faker::Verb.base
                    }
                }
            }.to_json
            headers = json_headers

            put "#{path}/#{company.id}", params: request_json, headers: headers
            expect(response.status).to be 404
        end
    end
end