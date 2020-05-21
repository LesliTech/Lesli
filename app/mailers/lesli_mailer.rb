class LesliMailer < ApplicationMailer

    def welcome(to, variation:"standard")

        send()
        
    end

    def user_new_password(subject, data, token, template: "")
        to = data[:email]
        data = data.merge({
            href: "#{default_url_options[:host]}/password/edit?reset_password_token=#{token}"
        })
        send(to, subject, data, template:"")
    end

    def test(to: "ldonis@lomax.com.gt")
        send(to, "Email test from Lesli - "+Time.now.to_s, {})
    end

end
