class LesliMailer < ApplicationMailer

    def welcome(to, variation:"standard")

        send2()
        
    end

    def user_new_password(subject, data, token, template: "", options: {})
        to = data[:email]
        data = data.merge({
            href: "#{default_url_options[:host]}/password/edit?reset_password_token=#{token}"
        })
        send2(to, subject, data, template: template, options: options)
    end

    def test(to: "ldonis@lomax.com.gt")
        send2(to, "Email test from Lesli - "+Time.now.to_s, {}, template: "", options: { template_name: "welcome" })
    end

end
