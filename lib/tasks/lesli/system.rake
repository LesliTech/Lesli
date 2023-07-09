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

namespace :lesli do

    namespace :system do

        desc "Print server statistics & Lesli setting status"
        task :status => :environment do |task, args|

            # get lesli settings
            revision = Lesli::System.revision()
            settings = Lesli::System.settings()

            L2.br()

            # print available languages
            L2.table(settings.dig(:configuration, :locales_available).map { |locale|
                { :languages => locale[1], :code => locale[0] }
            })

            L2.br(3)

            # print disk status
            L2.table([LC::System::FileSystem.stats('/', 'GB')])

            L2.br(4)

        end

    end

end
