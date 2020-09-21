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
    protect_from_forgery with: :exception

    before_action :authenticate_user!
    before_action :check_account
    before_action :validate_privileges
    before_action :set_global_account
    before_action :set_request_helpers
    after_action :log_user_activity
    
    layout "layouts/application-lesli"

    # deprecated response methods

    def responseWithSuccessful(data = nil)
        respond_with_successful(data)
    end

    def responseWithError(message = "", details = [])
        respond_with_error(message, details)
    end

    def responseWithNotFound
        respond_with_not_found()
    end

    def responseWithUnauthorized(detail = {})
        respond_with_unauthorized(detail)
    end

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

    def authenticate_user
        if !user_signed_in?
            redirect_to root, notice: "Please Login to view that page!"
        end
    end

    def check_account
        # check if account is active only for html requests
        return true if not request.format.html?
        return if current_user.blank?
        return if controller_name == "accounts"
        redirect_to "/account/new" if current_user.account.status == "registered"
    end

    # Check if current_user has privileges to complete this request
    # allowed core methods:
    #   [:index, :create, :update, :destroy, :new, :show, :edit, :options, :search, :resources]
    def validate_privileges
        action = params[:action]
        action = "resources" if request.path.include?("resources")

        granted = current_user.privileges
        .where("role_privileges.grant_object = ?", params[:controller])
        .where("role_privileges.grant_#{action} = TRUE")
        .first

        # empty privileges if null privileges
        granted ||= {} 

        # if user do not has access to the requested route and can go to default route        
        if !granted["grant_#{action}"] === true && can_redirect_to_default_path
            return redirect_to current_user.role_detail[:default_path] 
        end 

        # privilege for object not found
        if granted.blank?
            log_activity("privilege_not_found")
            return respond_with_unauthorized({ controller: params[:controller], privilege: "grant_#{action}" }) 
        end

        if not granted["grant_#{action}"] === true
            log_activity("privilege_not_granted")
            return respond_with_unauthorized({ controller: params[:controller], privilege: "grant_#{action}" }) 
        end

    end


    def set_global_account 

        # @account is only for html requests
        return true if not request.format.html?

        @account = {
            company: { },
            settings: { },
            current_user: { },
            revision: get_revision,
            notifications: Courier::Bell::Notification.index(current_user, {}, "count")
        }

        return @account if current_user.account.blank?

        # add company information (account)
        @account[:company] = {
            id: current_user.account.id,
            name: current_user.account.company_name,
            tag_line: current_user.account.company_tag_line
        }

        # add custom settings
        @account[:settings] = { }
        current_user.account.settings.where.not(name: [
            "password_minimum_length", "password_expiration_time_months"
        ]).each do |setting|
            @account[:settings][setting[:name]] = setting[:value].to_s
        end

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
    
    # set query used to filter or sort data requests
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

    def log_activity description=nil
        puts "";puts "";
        puts "DEPRECATED: Use log_user_activity or current_user.activities.create instead"
        puts "";puts "";
        log_user_activity description
    end

    # Track all user activity
    # this is disabled by default in the settings file
    def log_user_activity description=nil

        return if !Rails.application.config.lesli_settings["configuration"]["security"]["log_activity"]

        current_user.activities.create({
            request_controller: request.method, 
            request_method: controller_path,
            request_action: action_name, 
            request_url: request.original_fullpath, 
            description: description
        })

    end

    # Track specific account activity
    # this is disabled by default in the settings file
    def log_account_activity system_module, system_process, description=nil, payload=nil

        return if !Rails.application.config.lesli_settings["configuration"]["security"]["log_activity"]

        account = Account.first

        account = current_user.account if not current_user.blank?

        account.activities.create({
            system_module: system_module,
            system_process: system_process,
            description: description,
            payload: payload
        })

    end
    
    # Check if user can be redirected to role default path
    def can_redirect_to_default_path
        return false if request[:format] == "json"
        return false if !["show", "index"].include?(params[:action])
        return false if current_user.role_detail[:default_path].blank?
        return false if current_user.role_detail[:default_path] == request.original_fullpath
        return true
    end 

end
