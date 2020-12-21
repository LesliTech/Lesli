class UserMailerPreview < ActionMailer::Preview
    def welcome_email
        UserMailer.with(user: User.first).welcome_email
    end
end
