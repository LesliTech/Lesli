
require 'rails_helper'
require 'spec_helper'

RSpec.configure do |config|
    config.include Devise::Test::ControllerHelpers, :type => :controller
end

RSpec.describe Users::RegistrationsController, type: :controller do

    before :each do
        request.env["devise.mapping"] = Devise.mappings[:user]
    end

    describe "Sign up" do
        it "Register a new user" do
            post :create, params: {
                user: {
                    email: "new_user@gmail.com",
                    password: "lomax202020",
                    password_confirmation: "lomax202020"
                }
            }
            expect(response.status).to eq(200)
            expect(JSON.parse(response.body)).to eql({ "successful"=> true })
        end
    end

    describe "User already exists" do
        it "User" do
            post :create, params: {
                user: {
                    email: "new_user@gmail.com",
                    password: "123456",
                    password_confirmation: "123456"
                }
            }
            expect(response.status).to eq(200)
            #expect(JSON.parse(response.body)).to eql({"error"=>{"details"=>nil, "message"=>"Email has already been taken"}, "successful"=>false})
        end
    end

    describe "User and password in blank" do
        it "User and password" do
            post :create, params: {
                user: {
                    email: "",
                    paswword: "",
                    password_confirmation: ""
                }
            }
            expect(response.status).to eq(200)
            expect(JSON.parse(response.body)).to eql({"error"=>{"details"=>nil, "message"=>"Email can't be blank, Password can't be blank, and Password confirmation doesn't match Password"}, "successful"=>false})
        end
    end

    describe "Password doesn't match" do
        it "Password" do
            post :create, params: {
                user: {
                    email: "ldavila12456@gmail.com",
                    paswword: '',
                    password_confirmation: '1245'
                }
            }
            expect(JSON.parse(response.body)).to eql({"error"=>{"details"=>nil, "message"=>"Password can't be blank and Password confirmation doesn't match Password"}, "successful"=>false})
        end
    end

end

