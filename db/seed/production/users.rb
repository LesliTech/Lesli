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

# IMPORTANT: The production users must be loaded from builder engine seeder

# development user
STDOUT.puts "Do you want to load dev users? (y/n)"
input = STDIN.gets.strip
if input == 'y'
    load "#{Rails.root}/db/seed/development/users.rb"
end
