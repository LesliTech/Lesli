class UserMailer < ApplicationLesliMailer

    # Sends an welcome email when new user is created
    # @data = {
    #     full_name: "Luis Donis"
    # }
    def welcome(user, subject="Welcome to My Awesome Site")
       @data = {}
        # rails 6.1
        # mail(to: email_address_with_name(user.email, user.full_name), subject: subject)
        mail(to: user.email, subject: subject)
    end

end
