require 'rails_helper'
=begin

Copyright (c) 2020, all rights reserved.

All the information provided by this platform is protected by international laws related  to 
industrial property, intellectual property, copyright and relative international laws. 
All intellectual or industrial property rights of the code, texts, trade mark, design, 
pictures and any other information belongs to the owner of this platform.

Without the written permission of the owner, any replication, modification,
transmission, publication is strictly forbidden.

For more information read the license file including with this software.

// · ~·~     ~·~     ~·~     ~·~     ~·~     ~·~     ~·~     ~·~     ~·~     ~·~     ~·~     ~·~
// · 

=end
RSpec.describe "Details", type: :request do
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

    describe do

        it "Testing details_options" do

            login_admin            
            find_account

            employee = CloudTeam::Employee.create!(
                account: @account_id,
                user: @user,
                detail_attributes: { 
                    first_name: 'Luis',
                    surname: 'Davila',
                    email: 'ldavila@lesli.com',
                    gender: 'Male'
                }
            )

            get '/team/options/details'
            response_json = JSON.parse(response.body)
            expect(response.status).to be 200
            expect(JSON.parse(response.body)["successful"]).to eql(true)
            expect(response.content_type).to eq("application/json; charset=utf-8")
            expect(JSON.parse(response.body)).to eql({
                "successful" => true,
                "data" => {
                    "blood_groups" => {
                        "negativeA"=>"A-", "negativeAB"=>"AB-", 
                        "negativeB"=>"B-", "negativeO"=>"O-", 
                        "positiveA"=>"A+", "positiveAB"=>"AB+", 
                        "positiveB"=>"B+", "positiveO"=>"O+"
                    }, 
                    "genders" => {
                        "female"=>"Female", "male"=>"Male", 
                        "nonbinary"=>"Non binary"
                        }, 
                    "marital_statuses" => {
                        "married"=>"Married", "single"=>"Single"
                    }
                }
            })

        end

    end

end
