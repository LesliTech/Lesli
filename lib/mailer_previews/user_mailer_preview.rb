class UserMailerPreview < ActionMailer::Preview
    def welcome
        UserMailer.with(user: User.first).welcome
    end

    def reset_password_instructions
        UserMailer.with(
            user: User.first, 
            token: "my_reset_password_token"
        ).reset_password_instructions
    end
end
