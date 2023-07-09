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
