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

require "i18n-js"

# · 
namespace :lesli do 
    namespace :babel do 

        desc "Scan and register labels"
        task :scan => :environment do |task, args|
            Rake::Task['lesli_babel:scan'].invoke
        end 

        desc "Scan and register labels"
        task :load => :environment do |task, args|
            Rake::Task['lesli_babel:load'].invoke
        end 

        desc "Export translations to json files"
        task :export => :environment do |task, args|
            Rake::Task['lesli_babel:export'].invoke
        end 
    end

    namespace :guard do 

        desc "Syncing privileges for all the available roles"
        task :privileges => :environment do |task, args|
            Rake::Task['lesli_guard:privileges'].invoke
        end 
    end

    desc "Lesli module status"
    task :status => :environment do |task, args|

        # instance name from builder
        instance = Lesli.config.instance

        # get installed engines
        engines = Lesli::System.engines.map { |engine, engine_info|
            {
                :name => engine_info[:name],
                :code => engine_info[:code],
                :path => engine_info[:path],
                :version => engine_info[:version],
                :build => engine_info[:build]
            }
        }

        # print pretty instance information 
        L2.br(2)

        # core information
        L2.msg(instance)
        L2.br()

        # print list of engines
        L2.table(engines)
        L2.br(2)

    end
end
