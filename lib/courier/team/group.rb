=begin

Lesli

Copyright (c) 2023, Lesli Technologies, S. A.

This program is free software: you can redistribute it and/or modify
it under the terms of the GNU General Public License as published by
the Free Software Foundation, either version 3 of the License, or
(at your option) any later version.

This program is distributed in the hope that it will be useful,
but WITHOUT ANY WARRANTY; without even the implied warranty of
MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the
GNU General Public License for more details.

You should have received a copy of the GNU General Public License
along with this program. If not, see http://www.gnu.org/licenses/.

Lesli · Your Smart Business Assistant. 

Made with ♥ by https://www.lesli.tech
Building a better future, one line of code at a time.

@contact  hello@lesli.tech
@website  https://lesli.tech
@license  GPLv3 http://www.gnu.org/licenses/gpl-3.0.en.html

// · ~·~     ~·~     ~·~     ~·~     ~·~     ~·~     ~·~     ~·~     ~·~     ~·~     ~·~     ~·~
// · 

=end

module Courier
    module Team
        class Group
            def self.find(current_user, id)
                return {} unless defined? CloudTeam
                CloudTeam::GroupServices.new(current_user).find(id)
            end

            def self.index(current_user, query)
                return {} unless defined? CloudTeam
                CloudTeam::GroupServices.new(current_user, query).index()
            end

            def self.create(current_user, params)
                return nil unless defined? CloudTeam
                CloudTeam::GroupServices.new(current_user).create(params)
            end

            def self.update(current_user, id, params)
                return nil unless defined? CloudTeam

                group = CloudTeam::GroupServices.new(current_user).find(id)
                return nil unless group.found?

                group.update(params)
            end

            def self.destroy(current_user, id)
                return nil unless defined? CloudTeam

                group = CloudTeam::GroupServices.new(current_user).find(id)
                return nil unless group.found?

                group.destroy
            end
        end
    end
end
