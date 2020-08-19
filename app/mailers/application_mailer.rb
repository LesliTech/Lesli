class ApplicationMailer < ActionMailer::Base
    layout 'mailer'

    def send(to, subject, data, template: "", options: {})

        # define path for email templates, folder by engine
        template_path = ""
        if template && ! template.empty?
            template_path = template
        else
            case self.class.name
            when "BellMailer"
                template_path = "mailers/bell"
            when "DriverMailer"
                template_path = "mailers/driver"
            when "FocusMailer"
                template_path = "mailers/focus"
            when "HouseMailer"
                template_path = "mailers/house"
            when "DeutscheLeibrentenMailer"
                template_path = "mailers/deutsche_leibrenten"
            else
                template_path = "mailers/lesli"
            end
        end

        @data = data

        # send email
        email = mail(
            to: to,
            bcc: "ldonis@lomax.com.gt",
            from: "Deutsche Leibrenten CRM <no-reply@deutsche-leibrenten.de>", 
            subject: subject,
            template_path: template_path,
            template_name: options[:template_name]
        )

        SystemActivity.log_email(
            template_path.gsub("mailers/", ""),
            {
                subject: subject,
                to: to,
                body: email.body.encoded
            }
        )

        return email
    end
end
