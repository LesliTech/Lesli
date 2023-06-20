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

class Files::AwsUploadJob < ApplicationJob
    queue_as :default

    def perform(file)
        begin
            if file.public
                if file.attachment.file && (!file.attachment_public.file || (file.attachment_public_identifier != file.attachment_identifier))
                    file.update!(attachment_public: file.attachment)

                    if file.attachment_public
                        file.update!(attachment: nil)

                        # Sanity check in case the file got deleted when uploading it to AWS
                        # We reload the ActiveRecord because the one received as parameter is not up to date
                        file.update!(attachment_public: nil) unless file.class.find_by(id: file.id)
                    end
                end
            else
                if file.attachment.file && (!file.attachment_s3.file || (file.attachment_s3_identifier != file.attachment_identifier))
                    file.update!(attachment_s3: file.attachment)

                    if file.attachment_s3
                        file.update!(attachment: nil)

                        # Sanity check in case the file got deleted when uploading it to AWS
                        # We reload the ActiveRecord because the one received as parameter is not up to date
                        file.update!(attachment_s3: nil) unless file.class.find_by(id: file.id)
                    end
                end
            end
        rescue => error
            file.cloud_object.account.account.activities.create({
                system_module: file.class.name.split("::")[0],
                system_process: "aws_uploader",
                payload: error.to_json
            })
        end
    end
end
