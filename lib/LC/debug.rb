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

    # Ugly but useful debug message
    class Debug


        def self.info *messages
            messages.each do |message|
                puts pretty(message, :white, :blue)
            end 
        end

        def self.warn *messages
            message_string = pretty_separator(:yellow)
            messages.each do |message|
                message_string << pretty("WARNING:\ " <<  message, :black, :yellow)
            end
            puts message_string
        end


        def self.error *messages
            messages.each do |message|
                puts pretty(message, :white, :red)
            end
        end


        def self.success *messages
            messages.each do |message|
                puts pretty(message, :black, :green)
            end
        end


        def self.fatal *messages
            messages.each do |message|
                puts pretty(blink(message), :yellow, :red)
            end
        end


        def self.msg *messages
            separator_blank
            separator_blank
            messages.each do |message|
                p message
                separator_line
            end
            separator_blank
        end

        def self.msgc *messages
            msg(messages)
        end

        def self.list *messages
            #messages.each do |message|
            #    puts message
            #end
            puts messages.join("\n")
            separator_blank
        end


        def self.deprecation message
            separator_blank
            puts colorize("\n\nDEPRECATED METHOD: #{ caller[0] }, #{ message }\n", :white, :red)
            separator_blank
        end

        def self.simple_msg message
            puts message
        end
        
        private


        COLOURS = { 
            default: '38', 
            yellow: '1;33',
            white: '1;37', 
            green: '32',  
            black: '30', 
            blue: '34', 
            red: '31'
        }.freeze


        BG_COLOURS = { 
            default: '0', 
            yellow: '103', 
            white: '107', 
            green: '42', 
            black: '40', 
            blue: '44',
            red: '41'
        }.freeze


        def self.blink(text) 
            return "\e[5m#{ text }\e[25m" 
        end


        def self.separator_blank
            puts ""; puts ""; 
        end 


        def self.separator_line
            puts '---     ---     ---     ---     ---'
        end


        def self.colorize(text, colour = :default, bg_colour = :default)
            colour_code = COLOURS[colour]
            bg_colour_code = BG_COLOURS[bg_colour]
            return "\e[#{bg_colour_code};#{colour_code}m#{text}\e[0m".squeeze(';')
        end


        def self.pretty_separator(bg_colour = :default)
            colorize("\n", :black, bg_colour)
        end

        def self.pretty(message, colour = :default, bg_colour = :default)
            colorize("\n\ \ #{ message }\n", colour, bg_colour)
        end


        def self.colortable
            names = %w(black red green yellow blue pink cyan white default)
            fgcodes = (30..39).to_a - [38]
            
            s = ''
            reg  = "\e[%d;%dm%s\e[0m"
            bold = "\e[1;%d;%dm%s\e[0m"
            puts '                       color table with these background codes:'
            puts '          40       41       42       43       44       45       46       47       49'
            names.zip(fgcodes).each {|name,fg|
                s = "#{fg}"
                puts "%7s "%name + "#{reg}  #{bold}   "*9 % [fg,40,s,fg,40,s,  fg,41,s,fg,41,s,  fg,42,s,fg,42,s,  fg,43,s,fg,43,s,  
                fg,44,s,fg,44,s,  fg,45,s,fg,45,s,  fg,46,s,fg,46,s,  fg,47,s,fg,47,s,  fg,49,s,fg,49,s ]
            }
        end

    end

end
