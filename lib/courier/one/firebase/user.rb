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
            class User

                def self.registration(current_user, registration_params)
                    return unless defined? CloudOne
                    CloudOne::Firebase::User.registration(current_user, registration_params)
                end

                def self.update_photo(current_user, photo_url)
                    return unless defined? CloudOne
                    CloudOne::Firebase::User.update_photo(current_user, photo_url)
                end

                def self.update_data(current_user, params)
                    return unless defined? CloudOne
                    CloudOne::Firebase::User.update_data(current_user, params)
                end

                def self.generated_password(current_user)
                    return unless defined? CloudOne
                    CloudOne::Firebase::User.generated_password(current_user)
                end

            end
        end
    end
end
