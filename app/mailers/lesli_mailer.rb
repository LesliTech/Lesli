class LesliMailer < ApplicationMailer

    def welcome(to, variation:"standard")

        send()
        
    end

end
