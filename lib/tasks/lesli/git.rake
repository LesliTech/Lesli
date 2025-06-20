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
    namespace :git do

        desc "Commit pending changes from all engines"
        task commit: :environment do

            # default params
            git_message = "add updates from development"


            # execute command
            commit git_message

        end
    end

    # Commit pending changes from all engines
    def commit git_message

        # for every installed engine
        pp LesliSystem.engines(:local => true)
        # LesliSystem.engines_local.each do |name, engine|

        #     engine_path = Rails.root.join("engines", name)

        #     pp name

        #     next

        #     next unless File.exist?(engine_path)

        #     L2.m("Working with: #{name}")
        #     system("cd ./engines/#{name} && git add --all && git commit -m \"#{ git_message }\"")

        # end
    end
end
