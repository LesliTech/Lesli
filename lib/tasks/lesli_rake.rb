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
