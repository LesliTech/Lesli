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

Lesli - Your Smart Business Assistant

Powered by https://www.lesli.tech
Building a better future, one line of code at a time.

@contact  <hello@lesli.tech>
@website  <https://lesli.tech>
@license  Propietary - all rights reserved.

// · ~·~     ~·~     ~·~     ~·~     ~·~     ~·~     ~·~     ~·~     ~·~     ~·~     ~·~     ~·~
// · 

=end

require 'rails_helper'
require 'spec_helper'
require 'byebug'


RSpec.configure do |config|
    config.include Devise::Test::IntegrationHelpers
end

def dl_account
    return account = User.find_by(email: "crm.admin@deutsche-leibrenten.de").account
end

RSpec.describe 'get /crm', type: :request do  
    it "invalid html request made by user with kop role" do
        user = dl_account.users.create({ 
            email: "#{DateTime.now.strftime('%s')}#{rand(100)}@lesli.cloud", 
            password: DateTime.now.strftime('%s'),
            password_confirmation: DateTime.now.strftime('%s'),
            roles_id: Role.joins(:detail).where("role_details.name = ?", "kop").first.id
        })

        user.confirm if not user.confirmed?
        user.save!

        sign_in user

        get "/crm"
        
        expect(response).to have_http_status(302) 
    end
end

RSpec.describe 'post /house/projects/list.json', type: :request do  
    it "invalid json request made by user with kop role" do
        user = dl_account.users.create({ 
            email: "#{DateTime.now.strftime('%s')}#{rand(100)}@lesli.cloud", 
            password: DateTime.now.strftime('%s'),
            password_confirmation: DateTime.now.strftime('%s'),
            roles_id: Role.joins(:detail).where("role_details.name = ?", "kop").first.id
        })

        user.confirm if not user.confirmed?
        user.save!

        sign_in user

        post "/house/projects/list.json"

        expect(response).to have_http_status(401) 
        expect(JSON.parse(response.body)["successful"]).to eql(false)
        expect(JSON.parse(response.body)["error"]["message"]).to eql(I18n.t("core.shared.unauthorized_error_message"))
    end
end

RSpec.describe 'get /kop', type: :request do  

    it "valid access to kop area by user with kop role" do
        user = dl_account.users.create({ 
            email: "#{DateTime.now.strftime('%s')}#{rand(100)}@lesli.cloud", 
            password: DateTime.now.strftime('%s'),
            password_confirmation: DateTime.now.strftime('%s'),
            roles_id: Role.joins(:detail).where("role_details.name = ?", "b2b").first.id
        })

        user.confirm if not user.confirmed?
        user.save!     
           
        sign_in user

        get "/#{user.role.detail.default_path}"

        expect(response).to have_http_status(:success) 
    end
end

RSpec.describe 'get /{default_path}', type: :request do  

    it "valid access to default path using a user with role b2b" do
        user = dl_account.users.create({ 
            email: "#{DateTime.now.strftime('%s')}#{rand(100)}@lesli.cloud", 
            password: DateTime.now.strftime('%s'),
            password_confirmation: DateTime.now.strftime('%s'),
            roles_id: Role.joins(:detail).where("role_details.name = ?", "b2b").first.id
        })

        user.confirm if not user.confirmed?
        user.save!        
        sign_in user

        get "/#{user.role.detail.default_path}"

        expect(response).to have_http_status(:success) 
    end
end
