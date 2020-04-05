class ApplicationMailer < ActionMailer::Base
    layout 'mailer'

    def send(to, subject, data, template: "")

        # define path for email templates, folder by engine
        template_path = ""
        case self.class.name
        when "BellMailer"
            template_path = "mailers/bell"
        when "FocusMailer"
            template_path = "mailers/focus"
        when "HouseMailer"
            template_path = "mailers/house"
        else
            template_path = "mailers/lesli"
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
            template_path: template_path
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
