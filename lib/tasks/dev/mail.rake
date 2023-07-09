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

require "./lib/tasks/lesli_rake"

class DevMail < LesliRake

    def initialize
        namespace :dev do
            namespace :mail do

                desc ""
                task :test => :environment do |task, args|
                    ARGV.each { |a| task a.to_sym do ; end }

                    if ARGV[1].blank?
                        message("please enter an email address to send the tests")
                        return 
                    end 

                    email = ARGV[1] 

                    # execute command
                    test email
        
                end

            end

        end

    end

    private

    # Push code to remote branch/origin for all engines
    def test email

        # check if the email exists
        user = User.find_by(:email => email)

        # if email does not belong to user
        user = User.first if user.blank?

        # change the destinatary
        user.email = email

        token = "a!1b&2c@3d$4e%5"

        # send email tests
        [
            InvitesMailer.with(user).invitation_card,
            UserMailer.with(user: user).welcome,
            UserMailer.with(user: user).invitation_instructions,
            UserMailer.with(user: user, token: token).reset_password_instructions,
            UserMailer.with(user: user, token: token).pass_instructions,
            UserMailer.with(user: user, token: token).otp_instructions
        ].each do |mailer|
            p mailer[:Subject].value
            mailer.deliver_now
            sleep(2)
        end 

        message_separator 
        message_cow

    end

end

DevMail.new
