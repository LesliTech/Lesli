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

Lesli · Ruby on Rails SaaS Development Framework.

Made with ♥ by https://www.lesli.tech
Building a better future, one line of code at a time.

@contact  hello@lesli.tech
@website  https://www.lesli.tech
@license  GPLv3 http://www.gnu.org/licenses/gpl-3.0.en.html

// · ~·~     ~·~     ~·~     ~·~     ~·~     ~·~     ~·~     ~·~     ~·~
// · 
=end

# · 
namespace :lesli do 
    namespace :engine do

        desc "Initialize model data for new installed engines"
        task :install => :environment do |task, args|
            engine_install
        end
    end

    # Initialize model data for new installed engines
    def engine_install

        L2.msg("Initialize model data for new installed engines")

        # scan rails routes to build the controllers index
        Rake::Task['lesli:controllers:build'].invoke

        Rake::Task['lesli:role:privileges'].invoke

        # scan rails routes to build the base of translations
        Rake::Task['lesli:babel:build'].invoke if defined?(LesliBabel)

        # print the lesli gems
        Rake::Task['lesli:status'].invoke 
    end
end
