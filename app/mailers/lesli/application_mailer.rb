module Lesli
    class ApplicationMailer < ActionMailer::Base
        default from: "hello@lesli.tech"
        layout "lesli/layouts/mailer"
    end
end

