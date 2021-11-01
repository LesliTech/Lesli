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


#
require "./lib/tasks/lesli_tasks"


#
class LesliCliRake < LesliTasks

    def initialize
        namespace :lesli do

            desc ""
            task :user => :environment do |task, args|

                ARGV.each { |a| task a.to_sym do ; end }
    
                action = ARGV[0]
                
                # validate action to be executed
                ['add'].include?(action)

                # delete first element of array
                params = ARGV.drop(1)
                
                # execute requested action
                self.send(action, params)

            end

        end

    end

    private 

    def add email

        email = email[0]

        #password_length = 24
        #password = Devise.friendly_token.first(password_length)
        #user = User.new(:email => email, :password => password, :password_confirmation => password)
        #user.skip_confirmation!

        if user.save
            message_cow("User created successfully")
            message_separator
            message("#{email} - #{password}")
            message_separator
        else
            message_separator
            message_error(user.errors.full_messages.to_sentence)
            message_separator
        end

    end

    def list mode

        mode = mode[0]

        ['all'].include?(mode)

        message_separator
        message("my list of users")
        message_separator
        message_cow("Users listed successfully")

    end

end


#
LesliCliRake.new
