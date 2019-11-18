require 'rails_helper'
require 'spec_helper'

RSpec.configure do |config|
    config.include Devise::Test::ControllerHelpers, :type => :controller
end

RSpec.describe Users::PasswordsController, type: :controller do

    before :each do
        request.env["devise.mapping"] = Devise.mappings[:user]
    end

    describe "Wrong email" do
        it "Invalidated email" do
            post :create, params: {
                user: {email: "ldavila12@gmail.com"}
            }
            expect(JSON.parse(response.body)).to eql({"error"=>{"details"=>nil, "message"=>"An error ocurred while sending the reset instructions. Please check the email address is correct"}, "successful"=>false})
        end
    end
end
