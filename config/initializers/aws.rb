Aws.config.update({
    region: Rails.application.credentials.s3[:region],
    access_key_id: Rails.application.credentials.s3[:access_key_id],
    secret_access_key: Rails.application.credentials.s3[:secret_access_key]
})
