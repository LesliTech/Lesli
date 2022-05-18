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

require "./lib/tasks/lesli_rake"

class DevDocs < LesliRake


    def initialize
        namespace :dev do
            namespace :docs do
                desc "build"
                task :build => :environment do |task, args|

                    if defined? CloudDevelopment

                        # execute command
                        Rake::Task['cloud_development:docs:build'].invoke

                    end

                end

            end
        end
    end

end

# Instantiate the class to define the tasks:
DevDocs.new
