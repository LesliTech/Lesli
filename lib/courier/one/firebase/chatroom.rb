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

module Courier
    module One
        module Firebase
            class Chatroom

                def self.create(current_user, members, chat_name=nil, type="normal", anonymous=false, user_uid=nil)
                    return unless defined? CloudOne
                    CloudOne::Firebase::Chatroom.create(current_user, members, chat_name, type)
                end

                def self.send_message(sender_user, chatroom_uid, message_text)
                    return unless defined? CloudOne
                    CloudOne::Firebase::Chatroom.send_message(sender_user, chatroom_uid, message_text)
                end

            end
        end
    end
end
