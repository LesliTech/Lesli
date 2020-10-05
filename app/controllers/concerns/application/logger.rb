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

module Application

    module Logger
        extend ActiveSupport::Concern

        included do
        end

        def get_user_agent as_string: true

            # How to use this gem?
            # UserAgent.parse(request.env["HTTP_USER_AGENT"])

            http_user_agent = request.env["HTTP_USER_AGENT"]

            # parse user agent
            user_agent = UserAgent.parse(http_user_agent)

            # return user agent info as string
            return "#{user_agent.platform} #{user_agent.os} - #{user_agent.browser} #{user_agent.version}" if as_string == true

            user_agent

        end

        # Track all user activity
        # this is disabled by default in the settings file
        def log_user_requests description=nil

            return if !Rails.application.config.lesli_settings["configuration"]["security"]["log_activity"]

            current_user.requests.create({
                request_agent: get_user_agent,
                request_controller: controller_path,
                request_method: request.method,
                request_action: action_name, 
                request_url: request.original_fullpath,
                user_sessions_id: session[:user_session_id]
                #params: request.filtered_parameters.except(:controller, :action)
            })

        end

        # Track all user activity
        # this is disabled by default in the settings file
        def log_user_comments description=nil

            return if !Rails.application.config.lesli_settings["configuration"]["security"]["log_activity"]

            current_user.logs.create({
                session_uuid: session[:session_uuid],
                description: description
            })

        end


        # Track specific account activity
        # this is disabled by default in the settings file
        def log_account_activity system_module, system_process, description=nil, payload=nil

            return if !Rails.application.config.lesli_settings["configuration"]["security"]["log_activity"]

            account = Account.first

            account.activities.create({
                system_module: system_module,
                system_process: system_process,
                description: description,
                payload: payload
            })

        end


        # Set default query params for:
        #   pagination
        #   sorting
        #   filtering
        def set_request_helpers
            @query = {
                filters: params[:filters] ? params[:filters] : {},
                pagination: {
                    perPage: (params[:perPage] ? params[:perPage].to_i : 15),
                    page: (params[:page] ? params[:page].to_i : 1),
                    order: (params[:order] ? params[:order] : "desc"),
                    orderColumn: (params[:orderColumn] ? params[:orderColumn] : "id")
                }
            }
        end


    end

end
