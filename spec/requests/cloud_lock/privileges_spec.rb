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
@description Privileges testing

=end
RSpec.describe "Privileges", type: :request do
    include Devise::Test::IntegrationHelpers

    def login_admin
        @user = User.find_by(email: "admin@lesli.cloud")
        sign_in @user
    end

    def find_account
        @account_id = CloudLock::Account.find_by(id: @user.account.id)
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
            find_account

            role = CloudLock::Role.create!(
                name: Faker::Verb.base,
                account: @account_id
            )

            get "/lock/roles/#{role.id}/privileges.json"

            response_json = JSON.parse(response.body)
            expect(response).to have_http_status(:success) 
            expect(response.content_type).to eq("application/json; charset=utf-8")
            expect(JSON.parse(response.body)["successful"]).to eql(true)
        end

        it "Test json response (non-existent role)" do
            login_admin
            find_account

            role = CloudLock::Role.create!(
                name: Faker::Verb.base,
                account: @account_id
            )

            get "/lock/roles/#{Faker::Number.number(digits: 6)}/privileges.json"

            expect(response.status).to be 404
            expect(response.headers["Content-Type"]).to eq "application/json; charset=utf-8"
            expect(JSON.parse(response.body)["successful"]).to eql(false)
            expect(JSON.parse(response.body)).to eql({
                "successful" => false,
                "error" => {
                    "details"=>[], 
                    "message"=>"Not found"
                }
            })
        end

    end

    describe "SHOW integration test" do

        it "Test json response" do
            login_admin
            find_account

            role = CloudLock::Role.create!(
                name: Faker::Verb.base,
                account: @account_id
            )

            privileges = CloudLock::Role::Privilege.create!(
                privilege_index: true,
                privilege_create: true,
                privilege_new: false,
                cloud_lock_roles_id: role.id
            )
            get "/lock/roles/#{role.id}/privileges.json"
            response_json = JSON.parse(response.body)


            expect(response).to have_http_status(:success) 
            expect(response.headers["Content-Type"]).to eq "application/json; charset=utf-8"
            expect(response_json["successful"]).to be true
        end

        it "Test json response (non-existent role)" do
            login_admin
            find_account

            role = CloudLock::Role.create!(
                name: Faker::Verb.base,
                account: @account_id
            )

            privileges = CloudLock::Role::Privilege.create!(
                privilege_index: true,
                privilege_create: true,
                privilege_new: false,
                cloud_lock_roles_id: role.id
            )
            get "/lock/roles/#{Faker::Number.number(digits: 6)}/privileges.json"
            response_json = JSON.parse(response.body)

            expect(response.status).to be 404
            expect(response.headers["Content-Type"]).to eq "application/json; charset=utf-8"
            expect(JSON.parse(response.body)["successful"]).to eql(false)
            expect(JSON.parse(response.body)).to eql({
                "successful"=> false,
                "error" => {
                    "details"=>[], 
                    "message"=>"Not found"
                }
            })
        end        

    end

    describe "UPDATE integration test" do

        it "test valid request" do
            login_admin
            find_account

            role = CloudLock::Role.create!(
                name: Faker::Verb.base,
                account: @account_id
            )
            privileges = CloudLock::Role::Privilege.create!(
                privilege_index: true,
                privilege_create: true,
                privilege_new: false,
                cloud_lock_roles_id: role.id
            )
            request_json = {
                role_privilege: {
                    privilege_index: false
                }
            }.to_json
            headers = json_headers

            put "/lock/roles/#{role.id}/privileges/#{privileges.id}", params: request_json, headers: headers
            response_json = JSON.parse(response.body)

            expect(response.status).to be 200
            expect(response.headers["Content-Type"]).to eq "application/json; charset=utf-8"
            expect(response_json["successful"]).to be true
        end

        it "test invalid request" do
            login_admin
            find_account

            role = CloudLock::Role.create!(
                name: Faker::Verb.base,
                account: @account_id
            )
            privileges = CloudLock::Role::Privilege.create!(
                privilege_index: true,
                privilege_create: true,
                privilege_new: false,
                cloud_lock_roles_id: role.id
            )
            request_json = {
                privilege_index: false,
            }.to_json
            headers = json_headers

            put "/lock/roles/#{role.id}/privileges/#{Faker::Number.number(digits: 6)}", params: request_json, headers: headers
            response_json = JSON.parse(response.body)

            expect(response.status).to be 404
            expect(response.headers["Content-Type"]).to eq "application/json; charset=utf-8"
            expect(response_json["successful"]).to be false
            expect(JSON.parse(response.body)).to eql({
                "successful"=> false,
                "error" => {
                    "details"=>[], 
                    "message"=>"Not found"
                }
            })
        end

    end

    describe "Destroy integration test" do

        it "test valid request" do
            login_admin
            find_account

            role = CloudLock::Role.create!(
                name: Faker::Verb.base,
                account: @account_id
            )
            privileges = CloudLock::Role::Privilege.create!(
                privilege_index: true,
                privilege_create: true,
                privilege_new: false,
                cloud_lock_roles_id: role.id
            )

            delete "/lock/roles/#{role.id}/privileges/#{privileges.id}"
            response_json = JSON.parse(response.body)

            expect(response).to have_http_status(:success) 
            expect(response.headers["Content-Type"]).to eq "application/json; charset=utf-8"
            expect(JSON.parse(response.body)["successful"]).to eql(true)
            expect(JSON.parse(response.body)).to eql({
                "data" => nil,
                "successful" => true
            })
        end

        it "test invalid request" do
            login_admin
            find_account

            role = CloudLock::Role.create!(
                name: Faker::Verb.base,
                account: @account_id
            )
            privileges = CloudLock::Role::Privilege.create!(
                privilege_index: true,
                privilege_create: true,
                privilege_new: false,
                cloud_lock_roles_id: role.id
            )

            delete "/lock/roles/#{role.id}/privileges/#{Faker::Number.number(digits: 10)}"
            response_json = JSON.parse(response.body)

            expect(response.status).to be 404
            expect(response_json["successful"]).to be false
        end

    end


end
