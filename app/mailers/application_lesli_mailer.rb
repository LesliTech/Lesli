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

        # get class that is executing the mailer
        module_info = self.class.name.split("::")

        # mailers from engines
        return "#{(module_info[0].underscore)}/emails" if module_info.length > 1

        # mailers from core
        return "emails"

    }

    
    after_action :log_mail_requests

    def initialize
        
        super

        # defined on: LesliMails/src/partials/data.html
        @email = { }
        @data = { }

    end 


    def log_mail_requests
        # TODO: Save template path and view used within the email
        Account::Activity.log_email("#{self.class.to_s}/#{self.action_name}", "email_sent", {
            subject: self.message.subject,
            from: self.message.from,
            to: self.message.to
        }) 
    end

end
