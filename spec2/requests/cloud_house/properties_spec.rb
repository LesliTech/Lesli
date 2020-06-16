require 'rails_helper'

RSpec.describe "CloudHouse::Propeties", type: :request do
    include Devise::Test::IntegrationHelpers

    def login_admin
        @user = User.find_by(email: "admin@lesli.cloud")
        sign_in @user
    end

    def create_property(account=nil)
        account = @account unless account
        
        property = CloudHouse::Property.create!(
            account: @user.account,
            user: @user,

            detail_attributes: {
                street_number: Faker::Number.number(digits: 3),
                street_name:  Faker::Verb.base
            }
        )
        return property
    end
    
    describe "INDEX integration test" do  

        it "test http json response" do
            login_admin

            get "/house/properties.json"
            response_json = JSON.parse(response.body)

            expect(response.status).to be 200
            expect(response.headers["Content-Type"]).to eq "application/json; charset=utf-8"
            expect(response_json["successful"]).to be true
        end
        
        it "test http html response" do
            login_admin

            get "/house/properties.html"
        
            expect(response.status).to be 200
            expect(response.headers["Content-Type"]).to eq "text/html; charset=utf-8"
        end
    end


    describe "SHOW integration test" do

        it "test http html response" do
            login_admin
            create_account
            
            property = create_property

            get "/house/properties/#{property.id}.html"
            expect(response.status).to be 200
            expect(response.headers["Content-Type"]).to eq "text/html; charset=utf-8"
        end

        it "test valid request" do
            login_admin

            property = create_property

            get "/house/properties/#{property.id}.json"
            response_json = JSON.parse(response.body)
            property_data = response_json["data"]

            expect(response.status).to be 200
            expect(response.headers["Content-Type"]).to eq "application/json; charset=utf-8"
            expect(response_json["successful"]).to be true
            expect(property_data["id"]).not_to be nil
            expect(property_data["detail_attributes"]).not_to be nil
            expect(property_data["detail_attributes"]["street_name"]).to eq property.detail.street_name
            expect(property_data["detail_attributes"]["street_number"]).to eq property.detail.street_number
        end
    end

    describe "NEW integration test" do

        it "test http html response" do
            login_admin

            get "/house/properties/new.html"

            expect(response.status).to be 200
            expect(response.headers["Content-Type"]).to eq "text/html; charset=utf-8"
        end
    end


    describe "EDIT integration test " do

        it "test http html response" do
            login_admin

            get "/house/properties/edit.html"

            expect(response.status).to be 200
            expect(response.headers["Content-Type"]).to eq "text/html; charset=utf-8"
        end
    end


    describe "CREATE integration test" do

        it "test valid request" do
            login_admin

            request_json = {
                property: {
                    cloud_house_accounts_id: @user.account.house.id,
                    detail_attributes: {
                        street_name: Faker::Verb.base,
                        street_number: Faker::Number.number(digits: 3)
                    }
                }
            }.to_json

            post "/house/properties", params: request_json
            response_json = JSON.parse(response.body)
            property_data = response_json["data"]

            expect(response.status).to be 200
            expect(response.headers["Content-Type"]).to eq "application/json; charset=utf-8"
            expect(response_json["successful"]).to be true
            expect(property_data["id"]).not_to be nil
        end
    end


    describe "UPDATE integration test" do

        it "test valid request" do
            login_admin

            property = create_property
            request_json = {
                property: {
                    detail_attributes: {
                        street_name: Faker::Verb.base,
                        street_number: Faker::Number.number(digits: 3),
                        street_other: Faker::Verb.base
                    }
                }
            }.to_json

            put "/house/properties/#{property.id}.json", params: request_json

            response_json = JSON.parse(response.body)
            property_data = response_json["data"]

            expect(response.status).to be 200
            expect(response.headers["Content-Type"]).to eq "application/json; charset=utf-8"
            expect(response_json["successful"]).to be true
        end
    end


    describe "DESTROY integration test" do

        it "test valid request" do
            login_admin

            property = create_property

            delete "/house/properties/#{property.id}"
            response_json = JSON.parse(response.body)

            expect(response.status).to be 200
            expect(response_json["successful"]).to be true

            get "/house/properties/#{property.id}.json"
            expect(response.status).to be 404
        end
    end
end
