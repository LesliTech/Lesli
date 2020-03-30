class NotificationMailer < ApplicationMailer

    def notify
        @user = params[:user]
        @subject = params[:subject]
        @body = params[:body]
        @href = params[:href]
        @format = params[:format]
        @cloud_object_type = params[:cloud_object_type]
        
        mail(
            to: "ldonis@lomax.com.gt",#to: @user.email,
            subject: "Lesli Cloud Notification: @subject",
            template_path: 'mailers/notification_mailer'
        )
    end
end
