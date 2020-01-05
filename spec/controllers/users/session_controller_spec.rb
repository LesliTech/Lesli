=begin 

Lesli

Copyright (c) 2019, Lesli Technologies, S. A.

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

@author   LesliTech <hello@lesli.tech>
@license  Propietary - all rights reserved.
@version  0.1.0-alpha

// · ~·~     ~·~     ~·~     ~·~     ~·~     ~·~     ~·~     ~·~     ~·~     ~·~     ~·~     ~·~
// · 
=end

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