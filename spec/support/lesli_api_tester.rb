=begin
    
Lesli

Copyright (c) 2023, Lesli Technologies, S. A.

This program is free software: you can redistribute it and/or modify
it under the terms of the GNU General Public License as published by
the Free Software Foundation, either version 3 of the License, or
(at your option) any later version.

This program is distributed in the hope that it will be useful,
but WITHOUT ANY WARRANTY; without even the implied warranty of
MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the
GNU General Public License for more details.

You should have received a copy of the GNU General Public License
along with this program. If not, see http://www.gnu.org/licenses/.

Lesli · Ruby on Rails Development Platform.

Made with ♥ by https://www.lesli.tech
Building a better future, one line of code at a time.

@contact  hello@lesli.tech
@website  https://www.lesli.tech
@license  GPLv3 http://www.gnu.org/licenses/gpl-3.0.en.html

// · ~·~     ~·~     ~·~     ~·~     ~·~     ~·~     ~·~     ~·~     ~·~
// ·     
=end

require "faker"
require "rails_helper"
require "support/helpers/response_helper"


# · Authentication context
RSpec.shared_context "request api authentication" do

    password = Rails.application.config.lesli.dig(:security, :password)
    password = password + Time.now.year.to_s + "$"

    @token = nil

    # Creates a new valid user session
    before(:each) do
        @query = {
            search: "",
            filters: {},
            pagination: {
                perPage: 15,
                page: 1,
                order: "desc",
                orderBy: "id",
                orderColumn: "id"
            }
        }

        @current_user = User.first

        if @token.blank?

            # get JWT for api authentication
            post('/api/v2.0/auth/login', params: {
                "email": @current_user.email,
                "password": password,
                "source": "rspec_tests"
            })

            @token = JSON.parse(response.body).dig("token")

        end

    end

    # Overwrite get method to include authorization headers
    def get(path, params:nil, headers:nil)

        # push authorization headers
        headers ||= {'Authorization' => "Bearer #{ @token }"}

        # execute base get method with our custom headers
        super(path, :params => params, :headers => headers)

    end

    # Overwrite post method to include authorization headers
    def post(path, params:nil, headers:nil)

        if path == '/api/users/authentication'
            super(path, :params => params)
            return 0
        end

        # push authorization headers
        headers ||= {'Authorization' => "Bearer #{ @token }"}

        # execute base post method with our custom headers
        super(path, :params => params, :headers => headers)

    end

    # Overwrite delete method to include authorization headers
    def delete(path, params:nil, headers:nil)
        # add authorization headers
        headers ||= { "Authorization" => "Bearer #{ @token }" }

        # execute base delete request with our custom headers
        super(path, :params => params, :headers => headers)
    end

    # Overwrite put method to include authorization headers
    def put(path, params:nil, headers:nil)
        # add authorization headers
        headers ||= { "Authorization" => "Bearer #{ @token }" }

        # execute base put request with our custom headers
        super(path, :params => params, :headers => headers)
    end
end


# · Configuration
RSpec.configure do |config|

    # Include devise helpers to be able to login on test runtime
    config.include Devise::Test::IntegrationHelpers

    # Include helper methods
    config.include ResponseHelpers

end
