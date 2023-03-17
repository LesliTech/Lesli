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

class User::SessionService

    def initialize(resource, log)
        @resource = resource
        @log = log
    end

    # register a new session
    def register(user_agent, remote_ip, session_source="devise_standard_session")

        # register a new unique session
        current_session = @resource.sessions.create({
            :user_agent => user_agent,
            :user_remote => remote_ip,
            :session_source => session_source,
            :last_used_at => LC::Date.now
        })

        # register a successful sign-in log for the current user
        @log.update(
            user_sessions_id: current_session[:id], 
            title: "session_creation_successful", 
            description: current_session[:session_source] 
        )

        # register or sync the current_user with the user representation on Firebase
        Courier::One::Firebase::User.sync_user(@resource) if defined? CloudOne

        return current_session

    end

    # get default path of role (if role has default path)
    def default_path

        # default path to redirect the user
        default_path = @resource.has_role_with_default_path? || "/"

        # if first loggin for account owner send him to the onboarding page
        if @resource.account.onboarding? && @resource.has_roles?("owner")
            default_path = "/onboarding"
        end

        default_path
    end 

end
