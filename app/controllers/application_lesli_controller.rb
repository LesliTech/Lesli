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
    include Interfaces::Application::Responder
    # include Application::Responder
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
        @account[:tasks] = Courier::Focus::Task.count(current_user)
        @account[:tickets] = Courier::Help::Ticket.count(current_user)
        @account[:pushs] = Rails.application.config.lesli.dig(:security, :enable_pushes)
        @account[:shortcuts] = current_user.shortcuts.select(:id, :name, :url)


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
            datetime: Rails.application.config.lesli.dig(:configuration, :datetime),
            currency: (Rails.application.config.lesli[:configuration][:currency] || {})
                .merge({ locale: Rails.application.config.lesli[:env][:default_locale] })
        }
        
        # set user information
        @account[:current_user] = {
            id: current_user.id,
            email: current_user.email,
            full_name: current_user.full_name,
            roles: current_user.roles.map(&:name),
            abilities: current_user.abilities_by_controller,
            max_object_level_permission: current_user.roles.map(&:object_level_permission).max
        }

        # 
        if defined?(CloudTalk)
            @account[:cloud_talk] = {
                firebase: Rails.application.credentials.providers&.dig(:firebase, :web)
            }
        end

    end


    # set customization only for lesli_cloud instance
    def set_customization

        # @account is only for html and pdf requests
        return unless (request.format.html? || request.format.pdf?)

        return unless Lesli.instance[:code] == "lesli_cloud"

        @account[:customization] = {}
        
        logos = {}
        logo_identifiers = Account::File.file_types.keys
        custom_logos = current_user.account.files.where("file_type in (?)", logo_identifiers).order(id: :desc).all
        logo_identifiers.each do |logo_identifier|
            custom_logo = custom_logos.find { |logo| logo.file_type == logo_identifier}
            next unless custom_logo

            custom_logo_url = "/administration/account/files/#{custom_logo.id}"
            custo_logo_url = custom_logo.attachment_url if custom_logo.attachment_identifier
            custom_logo_url = custom_logo.attachment_public_url if custom_logo.attachment_public_identifier

            logos[logo_identifier.to_sym] = custom_logo_url
        end
        @account[:customization][:logos] = logos

        colors = {}
        color_identifiers = ::Account::Setting.theme_settings_keys
        custom_colors = current_user.account.settings.where("name in (?)", color_identifiers).all
        color_identifiers.each do |color_identifier|
            custom_color = custom_colors.find { |color| color.name == color_identifier}
            next unless custom_color

            colors[color_identifier.to_sym] = custom_color.value
        end
        @account[:customization][:colors] = colors
    end


    # Check if current_user has privileges to complete this request
    # allowed core methods:
    #   [:index, :create, :update, :destroy, :new, :show, :edit, :options, :search, :resources]
    def authorize_privileges

        # check if user has access to the requested controller
        # this search is over all the privileges for all the roles of the user
        granted = current_user.has_privileges2?(params[:controller], params[:action])

        # check if user has access to the requested controller
        # this search is over all the privileges for all the roles of the user
        # Due this method is executed on every request, we use low level cache to improve performance
        # granted = current_user.has_privileges?([params[:controller]], [params[:action]])

        # Check if user can be redirected to role default path
        can_redirect_to_default_path = -> () {
            return false if request[:format] == "json"
            return false if !["show", "index"].include?(params[:action])
            return false if current_user.roles.first[:default_path].blank?
            return false if current_user.roles.first[:default_path] == request.original_fullpath
            return true
        }

        # if user do not has access to the requested route and can go to default route
        if (!granted && can_redirect_to_default_path.call())
            return redirect_to current_user.roles.first[:default_path]
        end

        # privilege for object not found
        if granted.blank?
            log_user_comments("privilege_not_found")
            return respond_with_unauthorized({ controller: params[:controller], privilege: params[:action] })
        end
        
        unless granted
            log_user_comments("privilege_not_granted")
            return respond_with_unauthorized({ controller: params[:controller], privilege: params[:action] }) 
        end
    end


    # Validate user authentication and session status
    def authorize_request

        # check if the users is logged into the system
        if not user_signed_in?

            message = "Please Login to view that page!"

            # check if requested url is valid
            if (request.get? && is_navigational_format? && !request.xhr? && !request.fullpath.blank?)

                # redirect only if the path worth it
                if request.fullpath != "/"

                    # redirect with requested url, so user will be redirected after login
                    redirect_to("/login?r=#{request.fullpath}", notice: message) and return 

                end

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
                redirect_to "/administration/profile#force-password-reset", notice: I18n.t("core.users/sessions.messages_danger_password_expired")
                return
            end
        end

    end

end
