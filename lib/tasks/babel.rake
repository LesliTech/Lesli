=begin

Lesli

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

namespace :babel do

    task scan: :environment do
        return puts "Babel module not installed." if not defined?(CloudBabel)
        Rake::Task["cloud_babel:scan"].invoke
    end

    task build: :environment do
        return puts "Babel module not installed." if not defined?(CloudBabel)
        Rake::Task["cloud_babel:build"].invoke
    end

    task clean: :environment do
        return puts "Babel module not installed." if not defined?(CloudBabel)
        Rake::Task["cloud_babel:clean"].invoke
    end

    task rails: :environment do
        return puts "Babel module not installed." if not defined?(CloudBabel)
        Rake::Task["cloud_babel:rails"].invoke
    end

    task android: :environment do
        return puts "Babel module not installed." if not defined?(CloudBabel)
        Rake::Task["cloud_babel:android"].invoke
    end

    task ios: :environment do
        return puts "Babel module not installed." if not defined?(CloudBabel)
        Rake::Task["cloud_babel:ios"].invoke
    end

end
