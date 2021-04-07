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

class ApplicationLesliMailer < ActionMailer::Base

    layout "mailer"


    # Set a dynamic template according to the engine that is sending the email
    # this is equivalent to: default template_path: -> { "engine_name/emails" }
    default template_path: -> { 

        instance = Rails.application.config.lesli_settings["instance"]

        # get class that is executing the mailer
        module_info = self.class.name.split("::")

        # mailers from engines
        if module_info.length > 1
            return "#{ instance[:code] }/emails/#{(module_info[0].underscore)}/#{ module_info[1].underscore }" 
        end

        # mailers from core
        return "#{ instance[:code] }/emails/#{ module_info[0].underscore }"

    }

    
    after_action :log_mail_requests

    def initialize
        
        super

        # some @email data is defined on: LesliMails/src/partials/data.html
        @custom = {}
        @email = {}
        @data = {}
        @app = {}

    end 


    protected


    def build_data_from_params(params, data={})

        # make custom data available in mailer method and mailer template
        @data = @data.merge(data)

        build_app_from_params(params)

        build_customization_from_params(params)

    end


    def build_customization_from_params(params)

        @custom[:logo] = "/images/brand/lesli-name.svg"
        
        return if params[:user].blank?

        custom_logo = params[:user].account.files.where(name: "company_logo").last

        @custom[:logo] = custom_logo.attachment.url if custom_logo

    end

    
    def build_app_from_params(params)

        @app[:host] = default_url_options[:host]
        @app[:instance] = Rails.application.config.lesli_settings["instance"]
        @app[:company] = {
            id: 0,
            name: "",
            tag_line: "",
        }

        return if params[:user].blank?

        @app[:company] = {
            id: params[:user].account.id,
            name: params[:user].account.company_name,
            tag_line: params[:user].account.company_tag_line,
        }

    end

    def build_recipients_from_users(users)
        if users.is_a?(Array)
            users.map { |user| email_address_with_name(user.email, user.full_name) } 
        end
    end

    def build_recipients_from_contacts(contacts)
        if contacts.is_a?(Array)
            contacts.map { |contact| email_address_with_name(contact[:email], contact[:name]) }
        end
    end

    def build_recipients_from_emails()
    end

    
    private


    def log_mail_requests title="email_sent", payload=nil

        if payload.blank?
            payload = {
                subject: self.message.subject,
                to: self.message.to
            }
        end

        # TODO: Save template path and view used within the email
        Account::Activity.log_email("#{self.class.to_s}/#{self.action_name}", self.action_name, title, payload) 

    end

end
