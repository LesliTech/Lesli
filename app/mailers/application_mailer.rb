=begin

Lesli

Copyright (c) 2023, Lesli Technologies, S. A.

This program is free software: you can redistribute it and/or modify
it under the terms of the GNU General Public License as published by
the Free Software Foundation, either version 3 of the License, or
(at your option) any later version.

This program is distributed in the hope that it will be useful,
but WITHOUT ANY WARRANTY; without even the implied warranty of
MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the
GNU General Public License for more details.

You should have received a copy of the GNU General Public License
along with this program. If not, see http://www.gnu.org/licenses/.

Lesli · Your Smart Business Assistant. 

Made with ♥ by https://www.lesli.tech
Building a better future, one line of code at a time.

@contact  hello@lesli.tech
@website  https://lesli.tech
@license  GPLv3 http://www.gnu.org/licenses/gpl-3.0.en.html

// · ~·~     ~·~     ~·~     ~·~     ~·~     ~·~     ~·~     ~·~     ~·~     ~·~     ~·~     ~·~
// ·

=end

class ApplicationMailer < ActionMailer::Base
    layout 'mailer'

    def send2(to, subject, data, template: "", options: {})

        # define path for email templates, folder by engine
        template_path = ""
        if template && ! template.empty?
            template_path = template
        else
            case self.class.name
            when "BellMailer"
                template_path = "mailers/bell"
            when "DriverMailer"
                template_path = "mailers/driver"
            when "FocusMailer"
                template_path = "mailers/focus"
            when "HouseMailer"
                template_path = "mailers/house"
            when "DeutscheLeibrentenMailer"
                template_path = "mailers/deutsche_leibrenten"
            else
                template_path = "mailers/lesli"
            end
        end

        @data = data

        # send email
        email = mail(
            to: to,
            cc: options[:cc],
            from: "Deutsche Leibrenten CRM <no-reply@deutsche-leibrente.de>", 
            subject: subject,
            template_path: template_path,
            template_name: options[:template_name]
        )
=begin
        Account::Activity.log_email(
            template_path.gsub("mailers/", ""),
            {
                subject: subject,
                to: to,
                body: email.body.encoded
            }
        )
=end
        return email
    end
end
