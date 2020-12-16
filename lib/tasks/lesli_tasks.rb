=begin

Copyright (c) 2020, all rights reserved.

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


# dependencies
require "ruby_cowsay"
require "./lesli"


class LesliTasks
    include Rake::DSL


    # prints a simple plain message
    def message message
        puts message
    end


    # print a message with a cow character
    def message_cow message = "Process completed successfully"

        # show simple text message
        message((Cow.new({ :cow => Cow.cows[(rand(1..49) - 1)] })).say(message))
        
    end

    
    # print a default error message
    def message_error message = "Error executing process"
        message message
    end


    # print blank spaces to add space between messages
    def message_separator
        puts "";
        message "---   ---   ---   ---   ---   ---   ---   ---   ---   ---"
        puts ""; puts "";
    end


    # execute shell commands
    def command command
        message command
        #system command
    end

end
