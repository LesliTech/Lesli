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

# path is a variable of wenever class that returns the current path of the application
RAILS_ROOT = path

# output file
set :output, "log/schedule.log"

# config files
require_relative "boot"

# Gem class
require "rubygems"

# Needed to fetch current engines
require "#{RAILS_ROOT}/lesli.rb"

# include all schedule.rb of each engine
Lesli::engines().map do |engine|
    schedule_path = "#{Gem.loaded_specs[engine[:code]].full_gem_path}/config/schedule.rb"

    if(File.exist?(schedule_path)) # load file
        instance_eval(File.read(schedule_path), schedule_path)
    end
end
