class LesliMailer < ApplicationMailer

    def email

        mail(
            to: ["ldonis@lomax.com.gt", "ldonis.emc2@gmail.com"],
            subject: "Lesli Cloud Notification: @subject",
            template_path: 'cloud_haus/mailers'
        )

        #mail(
        #    to: 'marketing@deutsche-leibrenten.de',
        #    cc: current_kop.email,
        #    bcc: 'ldonis@lomax.com.gt',
        #    from: "Deutsche Leibrenten CRM <no-reply@deutsche-leibrente.de>", 
        #    reply_to: "#{current_kop.email}",
        #    subject: 'Bestellformular',
        #    template_path: 'mailer/kops_mails',
        #    template_name: 'request_order'
        #)

    end

end
