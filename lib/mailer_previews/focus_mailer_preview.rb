
class FocusMailerPreview < ActionMailer::Preview
    def task_new
        FocusMailer.with(user: User.first).task_new
    end
end
