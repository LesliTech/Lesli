Aws.config.update({
    region: Rails.application.credentials.services[:aws][:region],
    access_key_id: Rails.application.credentials.services[:aws][:access_key_id],
    secret_access_key: Rails.application.credentials.services[:aws][:secret_access_key]
})
