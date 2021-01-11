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

        def self.test
        end

        def self.msg *messages
            separator_blank
            separator_blank
            messages.each do |message|
                p message
                puts separator_lines
            end
            separator_blank
        end

        def self.deprecation message
            separator_blank
            puts bg_red("\n\nDEPRECATED METHOD: #{ caller[0] }, #{ message }\n")
            separator_blank
        end

        def self.msgc *messages
            msg(*messages)
        end

        def self.simple_msg *messages
            msgc(*messages)
        end

        private

        def self.separator_blank
            puts ""; puts ""; 
        end

        def self.separator_lines characters = 80
            return '---     ---     ---     ---     ---'
        end

        def self.red(text) return "\e[31m#{ text }\e[0m" end
        def self.bold(text) return "\e[1m#{ text }\e[22m" end
        def self.blink(text) return "\e[5m#{ text }\e[25m" end
        def self.bg_red(text) return "\e[41m#{ text }\e[0m" end
        def self.bg_brown(text) return "\e[43m#{ text }\e[0m" end

    end

end
