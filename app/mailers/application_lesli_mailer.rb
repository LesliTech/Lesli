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
        @email = { }
        @data = { }
        @app = { 
            host: default_url_options[:host],
            instance: Rails.application.config.lesli_settings["instance"]
        }

    end 


    protected


    def build_data_from_params(params)
        return {} if params[:user].blank?
        

        custom_logo = params[:user].account.files.where(name: "company_logo").last
        logo = "/images/brand/lesli-name.svg"
        logo = custom_logo.attachment.url if custom_logo

        @app["company"] = {
            id: params[:user].account.id,
            name: params[:user].account.company_name,
            tag_line: params[:user].account.company_tag_line,
            logo: logo
        }
    end


    def build_recipients_from_params(params)

        # Single recipient email
        if params[:to].is_a?(User)
            user = params[:to]
            params[:to] = email_address_with_name(user.email, user.full_name)
        end

        if params[:cc].is_a?(User)
            user = params[:cc]
            params[:cc] = email_address_with_name(user.email, user.full_name)
        end

        if params[:bcc].is_a?(User)
            user = params[:bcc]
            params[:bcc] = email_address_with_name(user.email, user.full_name)
        end


        # Multi recipient email
        if params[:to].is_a?(Array)
            params[:to] = params[:to].map{ |user| email_address_with_name(user.email, user.full_name) } 
        end

        if params[:cc].is_a?(Array)
            params[:cc] = params[:cc].map{ |user| email_address_with_name(user.email, user.full_name) } 
        end

        if params[:bcc].is_a?(Array)
            params[:bcc] = params[:bcc].map{ |user| email_address_with_name(user.email, user.full_name) } 
        end


        # TODO: to add support to recipients as string emails, use params[:emails] instead of the :to key
        if params[:to].blank?
            log_mail_requests("email_not_sent", { error: "email_recipient_not_found" })
        end

        params

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
