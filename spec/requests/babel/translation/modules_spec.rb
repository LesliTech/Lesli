require 'rails_helper'
#require 'spec_helper'

RSpec.describe "CloudBabel::Translation::Modules", type: :request do
    include Devise::Test::IntegrationHelpers

    def login_admin
        @user = User.find_by(email: "admin@lesli.cloud")
        sign_in @user
    end

    def create_account
        @account = CloudHelp::Account.new(id: @user.account.id)
    end

    def json_headers
        {
            "Content-Type" => "application/json",
            "Accept" => "application/json"
        }
    end


    describe "GET:/babel/translation/modules" do

        it "return an array of modules" do
            login_admin

            get "/babel/translation/modules.json"
            expect(response).to have_http_status(:success) 
            expect(response.content_type).to eq("application/json; charset=utf-8")
            expect(JSON.parse(response.body)["successful"]).to eql(true)
            expect(JSON.parse(response.body)).to eql({ "successful"=> true })
        end

    end

end
