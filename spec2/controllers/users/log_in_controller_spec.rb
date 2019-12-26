require 'rails_helper'
require 'spec_helper'

RSpec.configure do |config|
    config.include Devise::Test::ControllerHelpers, :type => :controller
end

RSpec.describe Users::SessionsController, Users::RegistrationsController, type: :controller do

    before :each do
        request.env["devise.mapping"] = Devise.mappings[:user]
    end

    describe "Wrong email and passwordin the log in" do
      it "Sign in" do 
          post :create, params: {
              user: {
                  user: "ldavila23@gmail.com",
                  password: "lomax202020",
                  password_confirmation: "lomax202020"
              }
          }
          expect(JSON.parse(response.body)).to eql({"error"=>{"details"=>nil, "message"=>"Invalid email or password"}, "successful"=>false})
      end
  end

end
