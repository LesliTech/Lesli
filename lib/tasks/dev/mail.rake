=begin

Copyright (c) 2021, all rights reserved.

All the information provided by this platform is protected by international laws related  to 
industrial property, intellectual property, copyright and relative international laws. 
All intellectual or industrial property rights of the code, texts, trade mark, design, 
pictures and any other information belongs to the owner of this platform.

Without the written permission of the owner, any replication, modification,
transmission, publication is strictly forbidden.

For more information read the license file including with this software.

// · ~·~     ~·~     ~·~     ~·~     ~·~     ~·~     ~·~     ~·~     ~·~     ~·~     ~·~     ~·~
// · 

=end

require "./lib/tasks/lesli_tasks"

class DevMail < LesliTasks

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
        UserMailer.with(user: user).welcome.deliver_now
        UserMailer.with(user: user).invitation_instructions.deliver_now
        UserMailer.with(user: user, token: token).reset_password_instructions.deliver_now
        UserMailer.with(user: user, token: token).pass_instructions.deliver_now
        UserMailer.with(user: user, token: token).otp_instructions.deliver_now

        message_separator
        message_cow

    end

end

DevMail.new
