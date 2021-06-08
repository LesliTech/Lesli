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
        @account[:announcements] = 0 #Courier::Bell::Announcement.count(current_user)
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

        current_user.privilege_actions
        .select("
            bool_or(role_privilege_actions.status) as value,
            system_controller_actions.name as action,
            system_controllers.name as controller
        ")
        .joins(action: [:system_controller])
        .group("
            system_controller_actions.name,
            system_controllers.name
        ")
        .each do |route|            
            abilities[route["controller"]] = {} if abilities[route["controller"]].nil?
            
            abilities[route["controller"]].merge(route["action"] => route["value"])
        end

        puts "LOG: FINALITO "
        puts abilities
        
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
        
        # check if user has access to the requested controller
        # this search is over all the privileges for all the roles of the user
        granted = current_user.privilege_actions
        .joins(action: [:system_controller])
        .where("system_controllers.name = ?", params[:controller])
        .where("system_controller_actions.name = '#{params[:action]}'")
        &.first.present?
        
        # Check if user can be redirected to role default path
        can_redirect_to_default_path = -> () { 
            return false if request[:format] == "json"
            return false if !["show", "index"].include?(params[:action])
            # TODO: add support for multiple roles
            return false if current_user.roles.first[:default_path].blank?
            return false if current_user.roles.first[:default_path] == request.original_fullpath
            return true
        }

        # if user do not has access to the requested route and can go to default route        
        if (!granted && can_redirect_to_default_path.call())
            # TODO: add support for multiple roles
            return redirect_to current_user.roles.first[:default_path] 
        end 

        # privilege for object not found
        unless granted
            log_user_comments("privilege_not_found")
            return respond_with_unauthorized({ controller: params[:controller], privilege: params[:action] }) 
        end
    end

    
    # Validate user authentication and session status
    def authorize_request

        # check if the users is logged into the system
        if not user_signed_in?
            redirect_to root, notice: "Please Login to view that page!"
            return 
        end

        # check if account is active (only for html requests)
        return true if not request.format.html?

        # check if user has an active session
        current_session = current_user.sessions.find_by(id: session[:user_session_id])

        if current_session.equal? nil or not current_session.active?
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
