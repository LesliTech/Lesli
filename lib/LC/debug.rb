=begin

Lesli

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

module LC

    # Ugly but useful debug message - for rails console or plain text files
    class Debug

        def self.msg *messages
            puts ""; puts ""; puts ""; puts ""; 
            puts "#     #     #     #     #     #     #     #     #     #     #"
            puts "#     #     #     #     #     #     #     #     #     #     #"
            messages.each do |message|
                p message
                puts "=     =     =     =     =     =     =     =     =     =     ="
            end
            puts "#     #     #     #     #     #     #     #     #     #     #"
            puts "#     #     #     #     #     #     #     #     #     #     #"
            puts ""; puts ""; 
        end

        def self.msgc *messages
            puts ""; puts ""; puts ""; puts ""; 
            messages.each do |message|
                puts message
            end
            puts "~      ~      ~      ~      ~      ~      ~      ~      ~      ~"
            puts ""; puts ""; 
        end

        def self.simple_msg *messages
            self.msgc messages
        end

    end

end
