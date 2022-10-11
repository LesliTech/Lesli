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


        def self.msgc *messages
            puts messages.join("\n")
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


        def self.info *messages
            message_string = pretty_separator(:blue)
            messages.each do |message|
                message_string << pretty("INFO:\ " <<  message, :white, :blue)
            end
            puts message_string
        end


        def self.warn *messages
            message_string = pretty_separator(:yellow)
            messages.each do |message|
                message_string << pretty("WARNING:\ " <<  message, :black, :yellow)
            end
            puts message_string
        end


        def self.error *messages, path:false
            message_string = pretty_separator(:red)
            messages.each do |message|
                message_string << pretty("ERROR:\ " <<  message, :white, :red)
                message_string << pretty("PATH:\ " <<  caller[0], :white, :red) if path
            end
            puts message_string
        end


        def self.success *messages
            message_string = pretty_separator(:green)
            messages.each do |message|
                message_string << pretty("SUCCESS:\ " <<  message, :black, :green)
            end
            puts message_string
        end


        def self.fatal *messages
            messages.each do |message|
                puts pretty(blink(message), :yellow, :red)
            end
        end


        def self.deprecation message
            separator_blank
            puts colorize("\n\nDEPRECATED METHOD: #{ caller[0] }, #{ message }\n", :white, :red)
            separator_blank
        end


        def self.alert(text) 
            return "\e[5m#{ text }\e[25m" 
        end


        def self.separator_blank count=1
            puts ("\n" * count);
        end 


        def self.separator_line count=8
            puts '-*-     ' * count
        end 


        def self.list *messages
            puts messages.join("\n")
            separator_blank
        end


        def self.table data
            # tputcols is not available on windows
            return if Gem.win_platform?
            return unless data.size > 0

            if data.class.name == "ActiveRecord::Relation"
                data = data.to_a.map(&:serializable_hash) 
            end

            # get the available characters in terminal width
            terminal_width = `tput cols`.to_i

            # get the number of columns to print base on the data hash
            cols = data.first.keys.count + 1

            # get the available space for every column
            col_width = (terminal_width / cols) - 1

            # validate that we have minimum space to render the table
            return if col_width <= 0

            # separator for every column and row
            separator = ('| ' << ('- ' * (col_width / 2)))

            # add extra blank spaces to adjust the col_width only if col_width not a even number
            separator += (' ') if (col_width - separator.size).odd?
        
            # print data as table :)
            data.each_with_index do |row, index|
    
                # only for table header
                if index == 0 

                    # print table titles
                    puts '| ' << row.keys.map { |key| key.to_s.upcase.ljust(col_width) }.join('| ')

                    # print header separators, only for visible columns
                    puts separator * (cols - 1)

                end 
    
                # join hash values as a line and justify every value to print value
                # in its own column
                puts '| ' << row.values.map { |value| value.to_s.ljust(col_width) }.join('| ')

            end

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


        def self.colorize(text, colour = :default, bg_colour = :default)
            colour_code = COLOURS[colour]
            bg_colour_code = BG_COLOURS[bg_colour]
            return "\e[#{bg_colour_code};#{colour_code}m#{text}\e[0m".squeeze(';')
        end
        

        def self.pretty(message, colour = :default, bg_colour = :default)
            colorize("\n\ \ #{ message }\n", colour, bg_colour)
        end


        def self.pretty_separator(bg_colour = :default)
            colorize("\n", :black, bg_colour)
        end

        
    end

end
