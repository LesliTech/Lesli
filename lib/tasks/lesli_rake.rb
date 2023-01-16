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
require "./lesli"


# 
class LesliRake
    include Rake::DSL

    # print a message with a cow character
    def message_cow message = "Process completed successfully"

        # ids of the prettiest cows in the library
        pretty_cows = [46,33,32,31,29,27,21,10,5]

        # get a random cow id
        random_cows = rand(0..(pretty_cows.size-1))

        # show simple text message
        #message((Cow.new({ :cow => Cow.cows[pretty_cows[random_cows]] })).say(message))
        
    end

    def message message
        LC::Debug.msgc message
    end

    def message_separator
        LC::Debug.separator_blank
    end 

    # execute shell commands
    def command command
        system command
    end

end
