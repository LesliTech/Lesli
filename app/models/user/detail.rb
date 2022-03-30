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

class User::Detail < ApplicationLesliRecord
    belongs_to :user, foreign_key: "users_id"
    after_update :update_associated_record

    before_save :validate_work_region

    enum salutation: {
        mr: 'mr',
        mrs: 'mrs',
        ms: 'ms'
    }

    def update_associated_record
        if saved_change_to_first_name? || saved_change_to_last_name? || saved_change_to_telephone?

            self.user.set_alias

            self.user.update(name: self.user.full_name)

            if defined? CloudOne

                data = {
                    full_name: self.user.full_name,
                    telephone: self.telephone,
                }

                CloudOne::Firebase::User.update_data(self.user, data)

            end
        end
    end

    protected

    def validate_work_region
        return true unless work_region
        return true if Account::Location.find_by_id(work_region)

        errors.add(:base, :work_region_invalid)
        throw :abort
    end
end
