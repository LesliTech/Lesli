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
    
=end

RSpec.shared_context 'api authentication' do   

    password = Rails.application.config.lesli[:ecurity][:password][:development]
    password = password + Time.now.year.to_s + "$"

    @token = nil

    # Creates a new valid user session
    before(:all) do

        if @token.blank?

            # get JWT for api authentication
            post '/api/users/authentication', params: {
                authentication: {
                    "email": User.first.email,
                    "password": password,
                    "source": "Rspec tests"
                }
            }

            @token = JSON.parse(response.body)["data"]["token"]

        end
    end

    # Overwrite get method to include authorization headers
    def get(path, params:nil, headers:nil)

        # push authorization headers
        headers ||= {'Authorization' => "Bearer #{ @token }"}

        # execute base get method with our custom headers
        super(path, :params => params, :headers => headers)
        
    end

end
