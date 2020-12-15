class UserMailer < ApplicationLesliMailer

    def welcome
        @data = {
            name: "Luis Donis"
        }
        mail(to: "ldonis@lomax.com.gt", subject: 'Welcome to My Awesome Site')
    end

end
