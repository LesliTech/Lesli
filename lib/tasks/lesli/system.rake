=begin

Copyright (c) 2021, all rights reserved.

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

namespace :lesli do

    namespace :system do

        desc ""
        task :status => :environment do |task, args|

            revision = LC::System::Info.revision()
            settings = Lesli::settings()

            L2.br(4)

            L2.m(
                'Instance: ' << Rails.application.config.lesli[:instance][:name],
                'Version: ' << revision[:version],
                'Build: ' << revision[:build]
            )

            L2.br(3)

            L2.table (Lesli::engines.map { |engine| 
                {
                    :engine => engine[:code],
                    :version => "#{engine[:version]} (#{engine[:type]})",
                    :core => engine[:core]
                }
            })

            L2.br(3)

            L2.table(settings.dig("configuration", "locales_available").map { |locale| 
                { :languages => locale[1], :code => locale[0] }
            })

            L2.br(3)

            L2.table([LC::System::FileSystem.stats('/', 'GB')])

            L2.br(4)

        end

    end

end
