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

                return if !Rails.application.config.lesli.dig(:security, :enable_analytics)
                return unless current_user
                return unless session[:user_session_id]

                # Try to save a unique record for this request configuration
                current_user.requests.upsert({
                        request_controller: controller_path,
                        request_method: request.method,
                        request_action: action_name,
                        user_session_id: session[:user_session_id],
                        request_count: 1
                    },

                    # group of columns to consider a request as unique
                    unique_by: [:request_controller, :request_action, :user_id, :user_session_id],

                    # if request id is not unique, increase the counter for this configuration
                    on_duplicate: Arel.sql("request_count = user_requests.request_count + 1")
                )

                # update the last used date for the current session
                current_user.sessions.where(id: session[:user_session_id]).first&.touch(:last_used_at)

            end


            # Track user agents
            # this is disabled by default in the settings file
            def log_user_agent

                return if !Rails.application.config.lesli.dig(:security, :enable_analytics)
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
                    unique_by: [:platform, :os, :browser, :version, :user_id],

                    # if request id is not unique, increase the counter for this configuration
                    on_duplicate: Arel.sql("count = user_agents.count + 1")
                )
            end


            # Track specific account activity
            # this is disabled by default in the settings file
            def log_account_activity system_module, system_process, title=nil, payload=nil, description=nil

                return if !Rails.application.config.lesli.dig(:security, :enable_analytics)

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
