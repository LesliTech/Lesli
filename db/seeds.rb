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

L2.br(4)


# including tools for seeders
load Lesli::Engine.root.join("db", "seed", "tools.rb")


# loading core seeders
load Lesli::Engine.root.join("db", "seed", "#{Rails.env.downcase}.rb")


# loading engine seeders
# Rails.application.config.lesli.dig(:engines).each do |engine|

#     # every instance (builder module) is loaded into the platform using the same name of the engine
#     instance_klass = engine[:name].safe_constantize

#     L2.msg(
#         "Loading seeds for #{instance_klass} environment", 
#         "Version: #{instance_klass::VERSION} - Build: #{instance_klass::BUILD}"
#     )

#     # dynamic load seeds from installed engines
#     instance_klass::Engine.load_seed
# end


# # exec maintenance tasks
#Rake.application.invoke_task("app:maintenance")


#L2.cow("Seed process completed!")
