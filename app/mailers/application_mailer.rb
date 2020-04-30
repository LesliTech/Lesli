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
            when "HausMailer"
                template_path = "mailers/haus"
            else
                template_path = "mailers/lesli"
            end
        end

        @data = data

        puts "~     ~     ~     ~     ~     ~     ~     ~     ~"
        puts "~     ~     ~     ~     ~     ~     ~     ~     ~"
        puts "~     ~     ~     ~     ~     ~     ~     ~     ~"
        p data
        puts "~     ~     ~     ~     ~     ~     ~     ~     ~"
        puts "~     ~     ~     ~     ~     ~     ~     ~     ~"
        puts "~     ~     ~     ~     ~     ~     ~     ~     ~"

        # send email
        mail(
            to: to,
            subject: subject,
            template_path: template_path,
            template_name: options[:template_name]
        )

        # full configuration for email
        # mail(
        #    to: 'marketing@deutsche-leibrenten.de',
        #    cc: current_kop.email,
        #    bcc: 'ldonis@lomax.com.gt',
        #    from: "Deutsche Leibrenten CRM <no-reply@deutsche-leibrente.de>", 
        #    reply_to: "#{current_kop.email}",
        #    subject: 'Bestellformular',
        #    template_path: 'mailer/kops_mails',
        #    template_name: 'request_order'
        # )

    end

end
