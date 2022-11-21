=begin
Copyright (c) 2022, all rights reserved.

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
class User::AuthProvider < ApplicationLesliRecord
    belongs_to :user, foreign_key: 'users_id'

    after_create :initialize_integration_calendar

    def get_user_provider(users_id, provider)
        return User::AuthProvider.find_by(users_id: users_id, provider: provider)
    end

    # @return [CloudDriver::Calendar] Finds or creates a calendar for the user for the specific provider
    def initialize_integration_calendar
        Courier::Driver::Calendar.create_user_calendar(
            self.user,
            name: 'Google Calendar',
            source_code: 'google',
        ) if self.provider == 'Google'
    end

end
