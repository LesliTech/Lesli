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


#
require "./lib/tasks/lesli_tasks"


#
class LesliCliRake < LesliTasks

    def initialize
        namespace :lesli do

            desc ""
            task :system => :environment do |task, args|

                ARGV.each { |a| task a.to_sym do ; end }
    
                action = ARGV[0]
                
                # validate action to be executed
                ['status'].include?(action)

                # delete first element of array
                params = ARGV.drop(1)
                
                # execute requested action
                self.send(action, params)

            end

        end

    end

    private 

    def status params

        revision = LC::System::Info.revision()

        LC::Debug.msgc(
            'Instance: ' << Rails.application.config.lesli[:instance][:name],
            'Version: ' << revision[:version],
            'Build: ' << revision[:build]
        )

        LC::Debug.separator_blank

        LC::Debug.table (Lesli::engines.map { |engine| 
            {:engine => engine[:code],:version => "#{engine[:version]} (#{engine[:type]})"}
        })

        LC::Debug.separator_blank

        settings = Lesli::settings()

        LC::Debug.table(settings.dig("configuration", "locales_available").map { |locale| 
            { :language => locale[1], :code => locale[0] }
        })        

    end

end


#
LesliCliRake.new
