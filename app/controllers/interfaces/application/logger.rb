=begin

Copyright (c) 2023, all rights reserved.

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

            def get_user_agent as_string = true

                # How to use this gem?
                # UserAgent.parse(request.env["HTTP_USER_AGENT"])

                http_user_agent = request.env["HTTP_USER_AGENT"]

                # parse user agent
                user_agent = UserAgent.parse(http_user_agent)

                user_agent_version = user_agent.version.to_a.first(2).join('.')

                # return user agent as object
                if as_string == false
                    return {
                        platform: user_agent.platform,
                        os: user_agent.os,
                        browser: user_agent.browser,
                        version: user_agent_version
                    }
                end

                # return user agent info as string
                return "#{user_agent.platform} #{user_agent.os} - #{user_agent.browser} #{user_agent_version}"

            end


            # Track all user activity
            # this is disabled by default in the settings file
            def log_user_requests

                return if !Rails.application.config.lesli.dig(:security, :log_activity)
                return unless current_user
                return unless session[:user_session_id]

                # Try to save a unique record for this request configuration
                current_user.requests.upsert({
                        request_controller: controller_path,
                        request_method: request.method,
                        request_action: action_name,
                        request_format: request.format.symbol || "html",
                        request_url: request.path,
                        user_sessions_id: session[:user_session_id],
                        request_count: 1
                    },

                    # group of columns to consider a request as unique
                    unique_by: [:request_controller, :request_action, :request_format, :users_id, :user_sessions_id],

                    # if request id is not unique, increase the counter for this configuration
                    on_duplicate: Arel.sql("request_count = user_requests.request_count + 1")
                )

                # update the last used date for the current session
                current_user.sessions.where(id: session[:user_session_id]).first&.touch(:last_used_at)

            end


            # Track user agents
            # this is disabled by default in the settings file
            def log_user_agent

                return if !Rails.application.config.lesli.dig(:security, :log_activity)
                return unless current_user
                return unless session[:user_session_id]

                user_agent = get_user_agent(false)

                # Try to save a unique record for this agent configuration
                current_user.agents.upsert({
                        os: user_agent[:os] || "unknown",
                        platform: user_agent[:platform] || "unknown",
                        browser: user_agent[:browser] || "unknown",
                        version: user_agent[:version] || "unknown",
                        count: 1
                    },

                    # group of columns to consider a agent as unique
                    unique_by: [:platform, :os, :browser, :version, :users_id],

                    # if request id is not unique, increase the counter for this configuration
                    on_duplicate: Arel.sql("count = user_agents.count + 1")
                )
            end


            # Track specific account activity
            # this is disabled by default in the settings file
            def log_account_activity system_module, system_process, title=nil, payload=nil, description=nil

                return if !Rails.application.config.lesli.dig(:security, :log_activity)

                account = Account.first

                return account.activities.create({
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
