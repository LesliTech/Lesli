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

module Interfaces
    module Application
        module Logger

            def get_user_agent as_string: true

                # How to use this gem?
                # UserAgent.parse(request.env["HTTP_USER_AGENT"])

                http_user_agent = request.env["HTTP_USER_AGENT"]

                # parse user agent
                user_agent = UserAgent.parse(http_user_agent)

                user_agent_version = user_agent.version.to_a.first(2).join('.')

                # return user agent as object
                return user_agent unless as_string == true

                # return user agent info as string
                return "#{user_agent.platform} #{user_agent.os} - #{user_agent.browser} #{user_agent_version}" 

            end

            # Track all user activity
            # this is disabled by default in the settings file
            def log_user_requests description=nil

                return if !Rails.application.config.lesli.dig(:security, :log_activity)
                return if not current_user
                return if not session[:user_session_id]

                current_user.requests.create({
                    request_agent: get_user_agent,
                    request_controller: controller_path,
                    request_method: request.method,
                    request_action: action_name,
                    request_format: request.format.symbol,
                    request_url: request.path,
                    params: request.query_parameters,
                    user_sessions_id: session[:user_session_id]
                })

                current_user.sessions.where(id: session[:user_session_id]).first&.touch(:last_used_at)

            end

            # Track all user activity
            # this is disabled by default in the settings file
            def log_user_comments description=nil

                return if !Rails.application.config.lesli[:security][:log_activity]

                current_user.logs.create({
                    user_sessions_id: session[:user_session_id],
                    description: description
                })

            end


            # Track specific account activity
            # this is disabled by default in the settings file
            def log_account_activity system_module, system_process, title=nil, payload=nil, description=nil

                return if !Rails.application.config.lesli[:security][:log_activity]

                account = Account.first

                account.activities.create({
                    system_module: system_module,
                    system_process: system_process,
                    description: description,
                    payload: payload,
                    title: title
                })

            end
        end
    end
end
