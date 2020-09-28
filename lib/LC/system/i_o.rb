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

module LC

    module System

        class IO

            def self.zip zip_file, files

                base_path = Rails.root.join("public", "tmp")

                zip_file = base_path.join(zip_file)

                FileUtils.rm zip_file, :force=>true

                Zip::File.open(zip_file, Zip::File::CREATE) do |zip|

                    files.each do |file|
                        zip.add file.sub(base_path.to_s.concat("/"), ""), file
                    end

                end

                zip_file
                
            end

        end

    end

end
