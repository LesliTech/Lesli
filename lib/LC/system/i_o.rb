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

            # @return a Zip file that contains a list of files that are allocated in local storage, either in lesli/public or lesli/storage
            # @param zip_file [String] The relative path of the zip file to be created. The file will be allocated in lesli/public/tmp until it's released
            # @param files [Array] Array of strings that contain the relative path of the files to be added to the zip file
            # @description Creates a temporal zip file that contains all requested files and stores it in memory to be either used, stored
            #     or sent using an HTPP response
            # @example
            #     zip_file = LC::System::IO.zip("my_zip_file.zip", "image1.png", "documents/document1.pdf")
            #     send_data zip_file.read, filename: "all_documents_#{Date.today.strftime('%d_%B_%Y')}.zip", type: 'application/zip'
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
