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

TODO: 
    - exec login form test

=end

# include helpers, configuration & initializers for request tests
require 'lesli_request_helper'

RSpec.describe 'GET:/login', type: :request do
    it 'is expected to respond with login view' do
        get '/login'
        expect(response).to have_http_status(:success)
        expect(response.content_type).to eq("text/html; charset=utf-8")
        expect(response.body).to include("/password/new")
        expect(response.body).to include("/register")
        expect(response.body).to include("/pass/new")
        expect(response.body).to include("/otp/new")
    end
end



RSpec.feature 'GET:/login', :type => :feature do
    it 'is expected to respond with login view' do
        visit "/login"
        expect(page.status_code).to be(200)
        expect(page.response_headers['Content-Type']).to eq("text/html; charset=utf-8")
        expect(page).to have_link('', href: '/password/new')
        expect(page).to have_link('', href: '/register')
        expect(page).to have_link('', href: '/pass/new')
        expect(page).to have_link('', href: '/otp/new')
    end
end

RSpec.describe "devise/sessions/new", type: :view do

    it 'is expected to render html login view' do

        render

        assert_select "main.lesli"
        assert_select "main > section.hero.is-fullheight.lesli"
        assert_select "form"

        assert_select "form input", { :count => 3 }

        assert_select("form input[name='user_email']", { :count => 1 })
        assert_select("form input[name='user_password']", { :count => 1 })
        assert_select("form input[type='submit']", { :count => 1 })

    end

end
