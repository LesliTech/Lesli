module Quill
    class Delta
        def initialize(delta)
            @delta = delta
        end

        def to_html
            convert(@delta)
        end

        def break_line(insert)
            string = ""
            insert.split(/(?<=\n)/).each do |text|
                if text.end_with?("\n")
                    string << "<p> #{text.delete("\n")}</p>"
                else
                    string << "<p> #{text}</p>"
                end
            end
            string
        end

        def convert(delta)
            string = ""
            delta = delta['ops']
            delta.each do |operation|
                
                ##LC::Debug.msg(operation[:insert], operation[:attributes])

                if operation['insert'] == "\n"
                    #end_of_line(node['attributes'])
                elsif operation['insert'].include?("\n")
                    string << break_line(operation['insert'])
                else
                    string << break_line(operation['insert'])
                end
                
            end
            string
        end

    end
end
