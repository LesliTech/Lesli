=begin

Copyright (c) 2022, all rights reserved.

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

require "faker"
require "rails_helper"
require "support/helpers/response_helper"


# · Authentication context
# · ~·~     ~·~     ~·~     ~·~     ~·~     ~·~     ~·~     ~·~     ~·~     ~·~     ~·~     ~·~
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
# · ~·~     ~·~     ~·~     ~·~     ~·~     ~·~     ~·~     ~·~     ~·~     ~·~     ~·~     ~·~
RSpec.configure do |config|

    # Include devise helpers to be able to login on test runtime
    config.include Devise::Test::IntegrationHelpers

    # Include helper methods
    config.include ResponseHelpers

end
