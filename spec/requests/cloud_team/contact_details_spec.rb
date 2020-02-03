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
@description Contact detail testing

=end
RSpec.describe "ContactDetails", type: :request do
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

            employee.contact_detail = CloudTeam::Employee::ContactDetail.create(
                work_telephone: Faker::Number.number(digits: 10),
                work_mobile: Faker::Number.number(digits: 10), 
                work_email: Faker::Internet.email
            )

            get "/team/employees/#{employee.id}/contact_detail.json"
            response_json = JSON.parse(response.body)

            expect(response.status).to be 200
            expect(JSON.parse(response.body)["successful"]).to eql(true)
            expect(response.content_type).to eq("application/json; charset=utf-8")
        end

        it "test invalid request (non-existent priority)" do
            login_admin            
            find_account


            get "/team/employees/#{Faker::Number.number(digits: 6)}/contact_detail.json"
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

    describe "Testing Update" do

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

            employee.contact_detail = CloudTeam::Employee::ContactDetail.create(
                work_telephone: Faker::Number.number(digits: 10),
                work_mobile: Faker::Number.number(digits: 10), 
                work_email: Faker::Internet.email
            )

            params = {
                :employee_contact_detail => {
                    work_telephone: Faker::Number.number(digits: 10),
                    work_mobile: Faker::Number.number(digits: 10), 
                    work_email: Faker::Internet.email
                }
            }.to_json
            headers = json_headers

            put "/team/employees/#{employee.id}/contact_detail", params: params, headers: headers
            response_json = JSON.parse(response.body)

            expect(response.status).to be 200
            expect(JSON.parse(response.body)["successful"]).to eql(true)
            expect(response.content_type).to eq("application/json; charset=utf-8")
        end
        
        it "Test invalid request (unexistent priority)" do
            
            login_admin            
            find_account

            params = {
                :employee_contact_detail => {
                    work_telephone: Faker::Number.number(digits: 10),
                    work_mobile: Faker::Number.number(digits: 10), 
                    work_email: Faker::Internet.email
                }
            }.to_json
            headers = json_headers

            put "/team/employees/#{Faker::Number.number(digits: 10)}/contact_detail", params: params, headers: headers
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

end
