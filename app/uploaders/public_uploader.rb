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
        aws_access_key_id:     Rails.application.credentials.providers[:aws][:access_key_id],
        aws_secret_access_key: Rails.application.credentials.providers[:aws][:secret_access_key],
        region:                Rails.application.credentials.providers[:aws][:region]
    }
    aws_bucket = Rails.application.credentials.providers[:aws][:bucket]

    # However, if there are specfic credentials, those will be used
    if Rails.application.credentials.providers[:aws][:s3]
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
