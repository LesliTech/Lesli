class UserMailer < ApplicationMailer

    def registration(user)
        mail(
            to: project.employee.email,
            subject: "#{project.code} #{I18n.t('mailer.project.new_project.subject')}",
            template_path: 'mailer/projects_mails',
            template_name: 'new_project'
        )
    end
end
