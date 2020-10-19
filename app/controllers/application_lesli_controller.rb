=begin

Lesli

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

class ApplicationLesliController < ApplicationController
    include Application::Responder
    include Application::Requester
    include Application::Logger
    include Application::Polyfill

    protect_from_forgery with: :exception

    before_action :set_locale
    before_action :validate_session
    before_action :authorize_request
    before_action :authorize_privileges
    before_action :set_helpers_for_request
    before_action :set_helpers_for_account
    after_action  :log_user_requests
    
    layout "layouts/application-lesli"


    protected


    # @return [String] The name of this class, starting with 'Cloud'
    # @description Returns the Lesli engine and class name associated to this model. This method must be overwritten 
    #   if you create a new engine that inherits from another Lesli engine (like DeutscheLeibrenten previously CloudHaus)
    # @example
    #   # inside CloudHouse::ProjectsController, this instruction
    #   puts lesli_classname # Will diplay 'CloudHouse::ProjectsController'
    #   # inside DeutscheLeibrenten::ProjectsController, this instruction
    #   puts lesli_classname # should also diplay 'CloudHouse::ProjectsController'
    def self.lesli_classname
        return self.name
    end


    private


    # Set default query params for:
    #   pagination
    def set_helpers_for_account 

        # @account is only for html requests
        return true if not request.format.html?

        @account = {
            company: { },
            settings: {
                datetime: Rails.application.config.lesli_settings["configuration"]["datetime"]
            },
            current_user: { },
            revision: LC::System::Info.revision,
            notifications: Courier::Bell::Notification.index(current_user, {}, "count")
        }

        return @account if current_user.account.blank?

        # add company information (account)
        @account[:company] = {
            id: current_user.account.id,
            name: current_user.account.company_name,
            tag_line: current_user.account.company_tag_line
        }

        # set user abilities
        abilities = {}
        current_user.role.privileges.each do |privilege|
            abilities[privilege.grant_object] = privilege
        end

        # set user information
        @account[:current_user] = { 
            id: current_user.id,
            email: current_user.email,
            full_name: current_user.full_name,
            role: current_user.role.detail.name,
            abilities: abilities
        }

        @account

    end


    # Check if current_user has privileges to complete this request
    # allowed core methods:
    #   [:index, :create, :update, :destroy, :new, :show, :edit, :options, :search, :resources]
    def authorize_privileges
        
        action = params[:action]
        action = "resources" if request.path.include?("resources")

        granted = current_user.privileges
        .where("role_privileges.grant_object = ?", params[:controller])
        .where("role_privileges.grant_#{action} = TRUE")
        .first

        # Check if user can be redirected to role default path
        can_redirect_to_default_path = -> () { 
            return false if request[:format] == "json"
            return false if !["show", "index"].include?(params[:action])
            return false if current_user.role_detail[:default_path].blank?
            return false if current_user.role_detail[:default_path] == request.original_fullpath
            return true
        }

        # empty privileges if null privileges
        granted ||= {} 

        # if user do not has access to the requested route and can go to default route        
        if granted["grant_#{action}"] == false && can_redirect_to_default_path.call()
            return redirect_to current_user.role_detail[:default_path] 
        end 

        # privilege for object not found
        if granted.blank?
            log_user_comments("privilege_not_found")
            return respond_with_unauthorized({ controller: params[:controller], privilege: "grant_#{action}" }) 
        end

        if granted["grant_#{action}"] == false
            log_user_comments("privilege_not_granted")
            return respond_with_unauthorized({ controller: params[:controller], privilege: "grant_#{action}" }) 
        end

    end

    # validate session
    def validate_session
        if not request[:format] == "json"
            if (current_user.sessions.last.last_used_at.blank?)
                sign_out current_user
                redirect_to "/login", notice: "Please Login to view that page!"
            end
        end
    end
    
    # Validate user authentication and session status
    def authorize_request
        # check if user has an active session
        if not user_signed_in?
            redirect_to root, notice: "Please Login to view that page!"
        end

        # check if account is active (only for html requests)
        return true if not request.format.html?
        return if current_user.blank?
        return if controller_name == "accounts"

        # force user to complete registration before continue
        redirect_to "/account/new" if current_user.account.status == "registered"

    end

end
