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

class ApplicationLesliController < ApplicationController
    include Application::Responder
    include Application::Requester
    include Application::Logger
    include Application::Polyfill

    protect_from_forgery with: :exception

    before_action :set_locale
    before_action :authorize_request
    before_action :authorize_privileges
    before_action :set_helpers_for_request
    before_action :set_helpers_for_account
    before_action :set_customization
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
        return if !request.format.html?
        
        @account[:revision] = LC::System::Info.revision()
        @account[:notifications] = Courier::Bell::Notification.count(current_user, true)        
        @account[:announcements] = Courier::Bell::Announcement.list(current_user, {filters: {base_path: request.path, end_at: true, start_at: true, status: true}}).to_json.html_safe
        @account[:tasks] = Courier::Focus::Task.count(current_user)
        @account[:cable] = Rails.application.config.lesli_settings["configuration"]["security"]["enable_websockets"] || false

        
        # default customization, set on before_action :set_customization hook
        @account[:customization] = { :logo => "image.svg", :color_primary => "#1f7ce3" }


        return @account if current_user.account.blank?


        # add company information (account)
        @account[:company] = {
            id: current_user.account.id,
            name: current_user.account.company_name,
            tag_line: current_user.account.company_tag_line,
            phone_number_1: current_user.account.phone_number_1,
            public_email: current_user.account.public_email,
            address: current_user.account.address,
            website: current_user.account.website
        }

        @account[:settings] = { 
            datetime: Rails.application.config.lesli_settings["configuration"]["datetime"],
            currency: (Rails.application.config.lesli_settings["configuration"]["currency"] || {})
                .merge({ locale: Rails.application.config.lesli_settings["env"]["default_locale"] })
        }

        # set user abilities
        abilities = {}

        current_user.privileges
        .select(
            "grant_object",
            "bool_or(grant_index) as grant_index",
            "bool_or(grant_edit) as grant_edit",
            "bool_or(grant_show) as grant_show",
            "bool_or(grant_new) as grant_new",
            "bool_or(grant_create) as grant_create",
            "bool_or(grant_update) as grant_update",
            "bool_or(grant_destroy) as grant_destroy",
            "bool_or(grant_search) as grant_search",
            "bool_or(grant_resources) as grant_resources",
            "bool_or(grant_options) as grant_options",
            "bool_or(grant_list) as grant_list"
        )
        .group("grant_object")
        .each do |privilege| 
            abilities[privilege["grant_object"]] = privilege
        end

        # set user information
        @account[:current_user] = { 
            id: current_user.id,
            email: current_user.email,
            full_name: current_user.full_name,
            roles: current_user.roles.map(&:name),
            abilities: abilities
        }

    end


    # set customization only for lesli_cloud instance
    def set_customization

        # @account is only for html requests
        return if !request.format.html?

        return unless Lesli.instance[:code] == "lesli_cloud"
    
        @account[:customization] = Rails.cache.fetch("customization", expires_in: 12.hours) do
            custom_logo = current_user.account.files.where(name: "company_logo").last
            custom_logo = custom_logo.attachment.url if custom_logo
            {
                logo: custom_logo
            }
        end
        
    end


    # Check if current_user has privileges to complete this request
    # allowed core methods:
    #   [:index, :create, :update, :destroy, :new, :show, :edit, :options, :search, :resources]
    def authorize_privileges
        
        action = params[:action]
        
        # This verifies that we are inside an actions/resources namespace, but outside the actions/resources controller
        action = "resources" if request.path.include?("/resources/") && (self.class.name.demodulize.gsub("Controller", "").downcase != "resources")
        action = "actions" if request.path.include?("/actions/") && (self.class.name.demodulize.gsub("Controller", "").downcase != "actions")

        # check if user has access to the requested controller
        # this search is over all the privileges for all the roles of the user
        granted = current_user.privileges
        .where("role_privileges.grant_object = ?", params[:controller])
        .where("role_privileges.grant_#{action} = TRUE")
        .first

        # Check if user can be redirected to role default path
        can_redirect_to_default_path = -> () { 
            return false if request[:format] == "json"
            return false if !["show", "index"].include?(params[:action])
            # TODO: add support for multiple roles
            return false if current_user.roles.first[:default_path].blank?
            return false if current_user.roles.first[:default_path] == request.original_fullpath
            return true
        }

        # empty privileges if null privileges
        granted ||= {} 

        # if user do not has access to the requested route and can go to default route        
        if ((granted["grant_#{action}"] == false || granted.blank?) && can_redirect_to_default_path.call())
            # TODO: add support for multiple roles
            return redirect_to current_user.roles.first[:default_path] 
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

    
    # Validate user authentication and session status
    def authorize_request

        # check if the users is logged into the system
        if not user_signed_in?

            message = "Please Login to view that page!"

            # check if requested url is valid
            if (request.get? && is_navigational_format? && !request.xhr? && !request.fullpath.blank?)

                # redirect with requested url, so user will be redirected after login
                redirect_to("/login?r=#{request.fullpath}", notice: message) and return 

            end 

            # redirect to root route
            redirect_to("/login", notice: message) and return 

        end

        # run aditinal validations only for html requests
        return true if not request.format.html?

        # get the current user session 
        current_session = current_user.sessions.find_by(id: session[:user_session_id])

        # check if user has an active session
        if current_session.equal? nil or !current_session.active?
            current_user.logs.create({ title: "system_session_logout", description: "session finished by the system"})
            sign_out current_user
            redirect_to "/logout" and return
        end

        if !current_session.expiration_at.blank? && current_session.expiration_at < Time.current
            current_user.logs.create({ title: "system_session_logout", description: "session expired by the system"})
            sign_out current_user
            redirect_to "/logout" and return
        end

        # check password expiration date
        if current_user.has_expired_password?
            unless controller_name == "profiles"
                current_user.logs.create({ description: "redirect_due_to_expired_password" })
                redirect_to "/administration/profile#security", notice: I18n.t("core.users/sessions.messages_danger_password_expired")
                return 
            end
        end

    end

end
