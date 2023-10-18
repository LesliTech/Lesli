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

module Lesli
    class User::SessionService < ApplicationLesliService

        # create a new session
        def create(user_agent, remote_ip, session_source="devise_standard_session")

            # register a new unique session
            current_session = current_user.sessions.create({
                :remote => remote_ip,

                :agent_os => user_agent[:os] || "unknown",
                :agent_platform => user_agent[:platform] || "unknown",
                :agent_browser => user_agent[:browser] || "unknown",
                :agent_version => user_agent[:version] || "unknown",
                
                :session_source => session_source,
                :last_used_at => Date2.new.get,

                :usage_count => 1
            })

            # register a successful sign-in log for the current user
            current_user.logs.update(
                session_id: current_session[:id], 
                title: "session_creation_successful", 
                description: current_session[:session_source] 
            )

            # register or sync the current_user with the user representation on Firebase
            #Courier::One::Firebase::User.sync_user(@resource) if defined? CloudOne

            return current_session

        end
    end
end
