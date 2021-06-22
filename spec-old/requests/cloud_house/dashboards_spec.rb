require 'rails_helper'

RSpec.describe "CloudHouse::Dashboards", type: :request do

    include Devise::Test::IntegrationHelpers

    before(:all) do
        login_admin
    end

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

    describe "GET /cloud_house/dashboards" do
        it "works! (now write some real specs)" do
            get "/house"
            expect(response).to have_http_status(:success) 
        end
    end
end
