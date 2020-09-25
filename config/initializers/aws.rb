Aws.config.update({
    region: Rails.application.credentials.providers[:aws][:region],
    access_key_id: Rails.application.credentials.providers[:aws][:access_key_id],
    secret_access_key: Rails.application.credentials.providers[:aws][:secret_access_key]
})

if Rails.configuration.lesli_settings["env"]["action_mailer"]["delivery_method"] == "ses"
    Aws::Rails.add_action_mailer_delivery_method(:ses,
        credentials: Aws::Credentials.new(    
            Rails.application.credentials.providers[:aws][:ses][:access_key_id],
            Rails.application.credentials.providers[:aws][:ses][:secret_access_key]
        )
    )
end
