require 'rails_helper'
=begin

Lesli

Copyright (c) 2020, Lesli Technologies, S. A.

All the information provided by this website is protected by laws of Guatemala related 
to industrial property, intellectual property, copyright and relative international laws. 
Lesli Technologies, S. A. is the exclusive owner of all intellectual or industrial property
rights of the code, texts, trade mark, design, pictures and any other information.
Without the written permission of Lesli Technologies, S. A., any replication, modification,
transmission, publication is strictly forbidden.
For more information read the license file including with this software.

LesliCloud - Your Smart Business Assistant

Powered by https://www.lesli.tech
Building a better future, one line of code at a time.

@author   Luis Davila
@license  Propietary - all rights reserved.
@version  0.1.0-alpha
@description Employee tests

=end
RSpec.describe "Employees", type: :request do
    include Devise::Test::IntegrationHelpers

    
    def login_admin
        @user = User.find_by(email: "admin@lesli.cloud")
        sign_in @user
    end

    def find_account
        @account_id = CloudTeam::Account.find_by(id: @user.account.id)
    end

    def json_headers
        {
            "Content-Type" => "application/json",
            "Accept" => "application/json"
        }
    end

    describe "Testing Index" do

        it "Test json response" do
            login_admin
            get "/team/employees.json"

            response_json = JSON.parse(response.body)

            expect(response.status).to be 200
            expect(JSON.parse(response.body)["successful"]).to eql(true)
            expect(response.content_type).to eq("application/json; charset=utf-8")
            expect(JSON.parse(response.body)).to eql({
                "successful"=> true
            })
        end

        it "Test html response" do
            login_admin
            get "/team/employees.html"

            expect(response.status).to be 200
            expect(response.content_type).to eq("text/html; charset=utf-8")
        end

    end

    describe "Testing Show" do

        it "Test json response" do
            login_admin            
            find_account

            employee = CloudTeam::Employee.create!(
                account: @account_id,
                user: @user,
                detail_attributes: { 
                    first_name: 'Luis',
                    surname: 'Davila',
                    email: 'ldavila@lesli.com'
                }
            )
            get "/team/employees/#{employee.id}.json"
            response_json = JSON.parse(response.body)

            expect(response.status).to be 200
            expect(JSON.parse(response.body)["successful"]).to eql(true)
            expect(response.content_type).to eq("application/json; charset=utf-8")
        end

        it "Test html response" do
            login_admin            
            find_account

            employee = CloudTeam::Employee.create!(
                account: @account_id,
                user: @user,
                detail_attributes: { 
                    first_name: 'Luis',
                    surname: 'Davila',
                    email: 'ldavila@lesli.com'
                }
            )
            get "/team/employees/#{employee.id}.html"

            expect(response.status).to be 200
            expect(response.content_type).to eq("text/html; charset=utf-8")
        end

        it "test invalid request (non-existent priority)" do
            login_admin            
            find_account

            get "/team/employees/#{Faker::Number.number(digits: 6)}.json"
            response_json = JSON.parse(response.body)

            expect(response.status).to be 404
            expect(JSON.parse(response.body)["successful"]).to eql(false)
            expect(response.content_type).to eq("application/json; charset=utf-8")
            expect(JSON.parse(response.body)).to eql({
                "successful"=> false,
                "error" => {
                    "details"=>[], 
                    "message"=>"Not found"
                }
            })
        end

    end

    describe "Testing Create" do

        it "Test valid request" do
            login_admin            
            find_account

            params = {
                :employee => {
                    detail_attributes: { 
                        first_name: Faker::Name.name,
                        surname: Faker::Name.name,
                        email: Faker::Internet.email
                    }
                }
            }.to_json
            headers = json_headers

            post "/team/employees", params: params, headers: headers
            response_json = JSON.parse(response.body)
            
            expect(response.status).to be 200
            expect(JSON.parse(response.body)["successful"]).to eql(true)
            expect(response.content_type).to eq("application/json; charset=utf-8")

        end

        it "Test invalid request (no firs_name)" do
            login_admin            
            find_account

            params = {
                :employee => {
                    detail_attributes: { 
                        surname: Faker::Name.name,
                        email: Faker::Internet.email
                    }
                }
            }.to_json
            headers = json_headers

            post "/team/employees", params: params, headers: headers
            response_json = JSON.parse(response.body)
            
            expect(response.status).to be 200
            expect(JSON.parse(response.body)["successful"]).to eql(false)
            expect(response.content_type).to eq("application/json; charset=utf-8")
            expect(JSON.parse(response.body)).to eql({
                "successful" => false,
                "error" => {
                    "details"=>nil, 
                    "message"=>["Detail first name can't be blank"]
                }
            })

        end

    end

    describe "Testing Update" do

        it "Test valid request"do
            login_admin            
            find_account

            employee = CloudTeam::Employee.create!(
                account: @account_id,
                user: @user,
                detail_attributes: { 
                    first_name: Faker::Name.name,
                    surname: Faker::Name.name,
                    email: Faker::Internet.email
                }
            )

            params = {
                :employee => {
                    detail_attributes: { 
                        first_name: Faker::Name.name,
                        surname: Faker::Name.name,
                        email: Faker::Internet.email
                    }
                }
            }.to_json
            headers = json_headers

            put "/team/employees/#{employee.id}", params: params, headers: headers
            response_json = JSON.parse(response.body)
            
            expect(response.status).to be 200
            expect(JSON.parse(response.body)["successful"]).to eql(true)
            expect(response.content_type).to eq("application/json; charset=utf-8")

        end

        it "Test invalid request (first_name changed to nil)" do
            login_admin            
            find_account

            employee = CloudTeam::Employee.create!(
                account: @account_id,
                user: @user,
                detail_attributes: { 
                    first_name: Faker::Name.name,
                    surname: Faker::Name.name,
                    email: Faker::Internet.email
                }
            )

            params = {
                :employee => {
                    detail_attributes: { 
                        first_name: nil,
                        surname: Faker::Name.name,
                        email: Faker::Internet.email
                    }
                }
            }.to_json
            headers = json_headers

            put "/team/employees/#{employee.id}", params: params, headers: headers
            response_json = JSON.parse(response.body)
            
            expect(response.status).to be 200
            expect(JSON.parse(response.body)["successful"]).to eql(false)
            expect(response.content_type).to eq("application/json; charset=utf-8")
            expect(JSON.parse(response.body)).to eql({
                "successful"=> false,
                "error" => {
                    "details"=>nil, 
                    "message"=>"Detail first name can't be blank"
                }
            })

        end

        it "Test invalid request (unexistent priority)" do
            login_admin            
            find_account

            params = {
                :employee => {
                    detail_attributes: { 
                        first_name: Faker::Name.name,
                        surname: Faker::Name.name,
                        email: Faker::Internet.email
                    }
                }
            }.to_json
            headers = json_headers

            put "/team/employees/#{Faker::Number.number(digits: 10)}", params: params, headers: headers
            response_json = JSON.parse(response.body)
            
            expect(response.status).to be 404
            expect(JSON.parse(response.body)["successful"]).to eql(false)
            expect(response.content_type).to eq("application/json; charset=utf-8")
            expect(JSON.parse(response.body)).to eql({
                "successful"=> false,
                "error" => {
                    "details"=>[], 
                    "message"=>"Not found"
                }
            })

        end

    end

    describe "Testing destroy" do

        it "Test valid request"do
            login_admin            
            find_account

            employee = CloudTeam::Employee.create!(
                account: @account_id,
                user: @user,
                detail_attributes: { 
                    first_name: Faker::Name.name,
                    surname: Faker::Name.name,
                    email: Faker::Internet.email
                }
            )

            delete "/team/employees/#{employee.id}"
            response_json = JSON.parse(response.body)

            expect(response.status).to be 200
            expect(JSON.parse(response.body)["successful"]).to eql(true)
            expect(response.content_type).to eq("application/json; charset=utf-8")
            expect(JSON.parse(response.body)).to eql({
                "successful"=> true
            })
        end

        it "Test invalid request (deleting a wrong employee id)"do
            login_admin            
            find_account

            employee = CloudTeam::Employee.create!(
                account: @account_id,
                user: @user,
                detail_attributes: { 
                    first_name: Faker::Name.name,
                    surname: Faker::Name.name,
                    email: Faker::Internet.email
                }
            )

            delete "/team/employees/#{Faker::Number.number(digits: 6)}"
            response_json = JSON.parse(response.body)

            expect(response.status).to be 404
            expect(JSON.parse(response.body)["successful"]).to eql(false)
            expect(response.content_type).to eq("application/json; charset=utf-8")
            expect(JSON.parse(response.body)).to eql({
                "successful"=> false,
                "error"=> {
                    "details"=> [], 
                    "message"=>"Not found"
                }
            })
        end

    end

end
