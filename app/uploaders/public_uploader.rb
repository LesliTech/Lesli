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
class PublicUploader < CarrierWave::Uploader::Base
    storage :fog

    # Override the directory where uploaded files will be stored.
    # This is a sensible default for uploaders that are meant to be mounted:
    def store_dir
        ["storage", "public", model.class.lesli_classname.underscore.sub("/file", ""), model.cloud_object.id].join("/")
    end

    # Override the filename of the uploaded files:
    # Avoid using model.id or version_name here, see uploader/store.rb for details.
    def filename
        if original_filename
            if model.id && ! original_filename.start_with?(model.id.to_s)
                return "#{model.id}-#{original_filename}"
            else
                return original_filename
            end
        end

        return nil
    end
end

CarrierWave.configure do |config|
    # Global credentials are the default setting
    aws_credetials = {
        provider: "AWS",
        path_style: true,
        aws_access_key_id:     Rails.application.credentials.dig(:providers, :aws, :access_key_id),
        aws_secret_access_key: Rails.application.credentials.dig(:providers, :aws, :secret_access_key),
        region:                Rails.application.credentials.dig(:providers, :aws, :region)
    }
    aws_bucket = Rails.application.credentials.dig(:providers, :aws, :bucket)

    # However, if there are specfic credentials, those will be used
    if Rails.application.credentials.dig(:providers, :aws, :s3)
        aws_credetials[:aws_access_key_id] = Rails.application.credentials.providers[:aws][:s3][:access_key_id]
        aws_credetials[:aws_secret_access_key] = Rails.application.credentials.providers[:aws][:s3][:secret_access_key]
        aws_credetials[:region] = Rails.application.credentials.providers[:aws][:s3][:region]


        aws_bucket = Rails.application.credentials.providers[:aws][:s3][:bucket]
    end

    config.fog_credentials = aws_credetials
    config.fog_directory  = aws_bucket
    config.fog_public     = false
    config.fog_attributes = { cache_control: "public, max-age=#{365.days.to_i}" }
end
