Aws.config.update({
    region: Rails.application.credentials.providers[:aws][:region],
    access_key_id: Rails.application.credentials.providers[:aws][:access_key_id],
    secret_access_key: Rails.application.credentials.providers[:aws][:secret_access_key]
})
